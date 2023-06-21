import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;
import 'package:line_icons/line_icons.dart';
import 'package:newprojectflutter/resources/favorite.dart';
import 'package:newprojectflutter/resources/bookmark.dart';
import 'package:newprojectflutter/views/project/service_details.dart';

import '../../resources/auth_res.dart';

class profileuser extends StatefulWidget {
  const profileuser({super.key});
  @override
  State<profileuser> createState() => _profileuserState();
}

class _profileuserState extends State<profileuser> {
  bool C1 = true, C2 = false, C3 = false;
  int index = 0;
  String bio = "", Cover = "";
  List<String> listservic = [];

  getallthereviwes() async {
    listservic = await AuthRes().getallthereviwes(globals.iduserProfile);
  }

  verfiheart(String uid) async {
    await favorite().verfieheart(uid);
  }

  verfibookmark(String uid) async {
    await bookmark().verfibookmark(uid);
  }

  ItemServ(String Image, String title, String desc, String uidserv) {
    return InkWell(
      onTap: () {
        globals.uidServ = uidserv;
        verfiheart(globals.uidServ);
        verfibookmark(globals.uidServ);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const servdetail(),
          ),
        );
      },
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(40, 0, 0, 0),
              blurRadius: 4,
              offset: Offset(4, 8), // Shadow position
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                      image: NetworkImage(Image), fit: BoxFit.cover)),
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  child: Text(title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Alexandria')),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: const EdgeInsets.only(right: 7),
                  child: Text(desc,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Alexandria')),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Services() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Services')
            .where('user', isEqualTo: globals.iduserProfile)
            .snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 9);
                },
                physics: const NeverScrollableScrollPhysics(),
                primary: true,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemServ(
                      snapshot.data!.docs[index]['imgUrl'],
                      snapshot.data!.docs[index]['title'],
                      snapshot.data!.docs[index]['description'],
                      snapshot.data!.docs[index]['serviceuid']);
                });
          }
        }));
  }

  About() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          alignment: Alignment.topRight,
          child: const Text("نبذة",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(bio,
            style: const TextStyle(
              wordSpacing: 2,
              height: 1.5,
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Alexandria',
            )),
      ],
    );
  }

  Widgetrevies(String ratin, String comment, String user) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(user)
            .snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(40, 0, 0, 0),
                    blurRadius: 4,
                    offset: Offset(4, 8), // Shadow position
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: CachedNetworkImage(
                        imageUrl: snapshot.data!.get('photoUrl'),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                              radius: 35,
                              backgroundImage: imageProvider,
                            )),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width / 2.2,
                            padding: const EdgeInsets.all(10),
                            child: Text(snapshot.data!.get('name'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Alexandria')),
                          ),
                          RatingBar.builder(
                            itemSize: 20,
                            ignoreGestures: true,
                            initialRating: double.parse(ratin),
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        padding: const EdgeInsets.only(right: 7),
                        child: Text(comment,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontFamily: 'Alexandria')),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        }));
  }

  Reviwes(String id) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Ratings")
          .where("servid", isEqualTo: id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("لاتوجد اي تقيمات");
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 9,
              );
            },
            itemCount: snapshot.data!.docs.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Widgetrevies(
                snapshot.data!.docs[index].get("Rating"),
                snapshot.data!.docs[index].get("comment"),
                snapshot.data!.docs[index].get("userreviews"),
              );
            },
          );
        }
      },
    );
  }

  gridmenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          child: Text(
            "حول",
            style: TextStyle(
              fontSize: 17,
              color: C1 ? Colors.blue[900] : Colors.black87,
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            C1 = true;
            C2 = false;
            C3 = false;
            index = 0;
            setState(() {});
          },
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton(
          child: Text(
            "الأعمال",
            style: TextStyle(
              fontSize: 17,
              color: C2 ? Colors.blue[900] : Colors.black87,
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            C2 = true;
            C1 = false;
            C3 = false;
            index = 1;

            setState(() {});
          },
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton(
          child: Text(
            "التقيمات",
            style: TextStyle(
              fontSize: 17,
              color: C3 ? Colors.blue[900] : Colors.black87,
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            C2 = false;
            C1 = false;
            C3 = true;
            index = 2;
            setState(() {});
          },
        ),
      ],
    );
  }

  Screans() {
    switch (index) {
      case 1:
        return Services();
      case 0:
        return About();
      case 2:
        for (int i = 0; i < listservic.length;) {
          return Reviwes(listservic[i]);
        }
    }
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(top: 13, right: 20),
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  buttonfedback(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 13, left: 20),
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.feedback_outlined,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  headProfile() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            scale: 0.1,
            image: NetworkImage(globals.userAvatr),
            opacity: 200,
            alignment: Alignment.topCenter),
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(globals.iduserProfile)
            .snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            bio = snapshot.data!.get('bio');
            return Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 30, right: 30),
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(70, 255, 255, 255),
                            radius: 50,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(globals.userAvatr),
                              radius: 47,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 50, right: 1),
                          child: Text(
                            snapshot.data!.get('name'),
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Alexandria',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "الأغواط-قصر الحيران",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "تسجيلات الإعجاب",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontFamily: 'Alexandria',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      '200',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      LineIcons.heartAlt,
                                      size: 15,
                                      color: Colors.white,
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                const Text(
                                  " التقيم",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontFamily: 'Alexandria',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      '4',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      LineIcons.starAlt,
                                      size: 15,
                                      color: Colors.white,
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                const Text(
                                  " الأعمال المنجزة",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontFamily: 'Alexandria',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      '45',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            );
          }
        }),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.8,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(globals.iduserProfile)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 5,
                                      width: 35,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                              ),
                              gridmenu(),
                              Screans()
                            ])),
                  );
                }
              }));
        });
  }

  @override
  Widget build(BuildContext context) {
    getallthereviwes();
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        headProfile(),
        scroll(),
        buttonArrow(context),
        buttonfedback(context)
      ],
    )));
  }
}
