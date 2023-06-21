import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:newprojectflutter/views/page/search.dart';
import 'package:newprojectflutter/views/page/trending.dart';
import 'package:newprojectflutter/views/project/service_details.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;
import 'package:newprojectflutter/resources/favorite.dart';
import 'package:newprojectflutter/resources/bookmark.dart';
import 'package:newprojectflutter/resources/proj_res.dart';

import '../../Swit.dart';
import '../../theme/theme_colors.dart';
import 'categorie.dart';
import 'myNotify.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var count;
  String avatarImg =
      "https://firebasestorage.googleapis.com/v0/b/bmarket-b690b.appspot.com/o/default-profile-pic-e1513291410505.jpg?alt=media&token=65125d4a-b59d-4853-b840-9f78bd63eaed";
  String servicImg =
      'https://firebasestorage.googleapis.com/v0/b/bmarket-b690b.appspot.com/o/default-image.png?alt=media&token=afcef964-c10f-45a6-8f8c-88ba1418d31f';
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  int a = 0;
  final List<String> imageList = [];
  countnotfi() async {
    count = await FirebaseFirestore.instance
        .collection('Notification')
        .where("userId", isEqualTo: _auth.currentUser!.uid)
        .where("state", isEqualTo: "غير مقروء")
        .count()
        .get();
  }

  updatecountnotfi() async {
    var query = await FirebaseFirestore.instance
        .collection('Notification')
        .where("userId", isEqualTo: _auth.currentUser!.uid)
        .get();
    for (int i = 0; i < query.docs.length; i++) {
      await FirebaseFirestore.instance
          .collection('Notification')
          .doc(query.docs[i]["notifyId"])
          .update({"state": "مقروء"});
    }
  }

  void getSliderImageFromDb() async {
    if (a == 0) {
      a = a + 1;
      var fireStore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await fireStore.collection('ads').get();
      if (mounted) {
        for (int length = 0; length < 4; length++) {
          imageList.add(snapshot.docs[length]['imgeAds']);
        }
      }
    } else {
      return null;
    }
  }

  getInformation(String iduserInserv) async {
    await ProjectRes().getInformation(iduserInserv);
  }

  verfiheart(String uid) async {
    await favorite().verfieheart(uid);
  }

  verfibookmark(String uid) async {
    await bookmark().verfibookmark(uid);
  }

  calucelsttrs() {
    ProjectRes().calcuelStars(globals.uidServ);
  }

  @override
  void initState() {
    avatarImg;
    servicImg;
    getSliderImageFromDb();
  }

  Widget promoCard(String imgres, String uid, String titelres) {
    return InkWell(
      onTap: () {
        //الكلاس هنا راني تحايلت معاها باه تصدق فكرة القلب
        setState(() {
          globals.uidServ = uid;
          verfiheart(globals.uidServ);
          verfibookmark(globals.uidServ);
          getInformation(globals.uidServ);
          calucelsttrs();
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const servdetail(),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 1.8 / 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: const EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imgres),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient:
                    LinearGradient(begin: Alignment.bottomRight, stops: const [
                  0.1,
                  0.8,
                ], colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.1),
                ]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.only(right: 5, bottom: 5),
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        height: 54,
                        width: 150,
                        child: Text(
                          titelres,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Alexandria'),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const PageScrollPhysics(),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 1),
                  child: Row(
                    children: [
                      Flexible(
                        child: CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 7, 36, 72)
                              .withOpacity(.3),
                          radius: 29,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(avatarImg),
                            radius: 25,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(_auth.currentUser!.uid)
                            .snapshots(),
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            if (snapshot.data!.get('photoUrl') != '') {
                              globals.myid = _auth.currentUser!.uid.toString();

                              avatarImg = snapshot.data!.get('photoUrl');
                              initState();
                            }
                            return Text(
                              'مرحبا، ${snapshot.data!.get('name')}👋',
                              style: const TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 7, 36, 72),
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                updatecountnotfi();
                                count = 0;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyNotify(),
                                  ),
                                );
                              },
                              icon: Icon(
                                  count == 0
                                      ? Icons.notification_add_outlined
                                      : Icons.notification_add_sharp,
                                  color: const Color.fromARGB(255, 7, 36, 72))),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Search(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.search_outlined,
                                  color: Color.fromARGB(255, 7, 36, 72))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  InkWell(
                    onTap: () {},
                    child: CarouselSlider(
                      items: imageList.map(
                        (url) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              child: Image.network(url,
                                  fit: BoxFit.cover, width: double.infinity),
                            ),
                          );
                        },
                      ).toList(),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 2,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () =>
                              carouselController.animateToPage(entry.key),
                          child: Container(
                            width: currentIndex == entry.key ? 17 : 7,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: currentIndex == entry.key
                                    ? Colors.blue
                                    : const Color.fromARGB(255, 7, 36, 72)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 20, top: 1),
                    child: const Text(
                      'الفئات',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 7, 36, 72),
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 4.5,
                    child: TextButton(
                      child: const Text(
                        'عرض الكل >',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Categorie()));
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: MediaQuery.of(context).size.width / 8,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 3 / 6,
                      crossAxisSpacing: 9,
                      mainAxisSpacing: 8),
                  children: [
                    //أثر الخطوات االأولى
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 203, 0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      child: const Text(
                        'بناء',
                        style: TextStyle(
                            fontSize: 27,
                            color: Color.fromARGB(255, 7, 36, 72),
                            fontFamily: 'Alnaseeb',
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white),
                            ]),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 203, 0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      child: const Text(
                        'ميكانيك',
                        style: TextStyle(
                            fontSize: 27,
                            color: Color.fromARGB(255, 7, 36, 72),
                            fontFamily: 'Alnaseeb',
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white),
                            ]),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 203, 0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      child: const Text(
                        'نجارة',
                        style: TextStyle(
                            fontSize: 27,
                            color: Color.fromARGB(255, 7, 36, 72),
                            fontFamily: 'Alnaseeb',
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white),
                            ]),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 203, 0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      child: const Text(
                        'خياطة',
                        style: TextStyle(
                            fontSize: 27,
                            color: Color.fromARGB(255, 7, 36, 72),
                            fontFamily: 'Alnaseeb',
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white),
                            ]),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 203, 0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      child: const Text(
                        'كهرباء',
                        style: TextStyle(
                            fontSize: 27,
                            color: Color.fromARGB(255, 7, 36, 72),
                            fontFamily: 'Alnaseeb',
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white),
                            ]),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 203, 0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      child: const Text(
                        'طبخ',
                        style: TextStyle(
                            fontSize: 27,
                            color: Color.fromARGB(255, 7, 36, 72),
                            fontFamily: 'Alnaseeb',
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 20, top: 1),
                    child: const Text(
                      'الشائعة',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 7, 36, 72),
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 4.2,
                    child: TextButton(
                      child: const Text(
                        'عرض الكل >',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Trending()));
                      },
                    ),
                  )
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Services')
                    .orderBy("Count", descending: true)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        primary: true,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: 6,
                        itemBuilder: (BuildContext context, int index) {
                          return promoCard(
                              snapshot.data!.docs[index]['imgUrl'],
                              snapshot.data!.docs[index]['serviceuid'],
                              snapshot.data!.docs[index]['title']);
                        });
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
