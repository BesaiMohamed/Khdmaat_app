import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newprojectflutter/resources/favorite.dart';
import 'package:newprojectflutter/resources/bookmark.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;
import 'package:newprojectflutter/views/project/service_details.dart';

class Trending extends StatefulWidget {
  const Trending({super.key});
  @override
  State<Trending> createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  verfiheart(String uid) async {
    await favorite().verfieheart(uid);
  }

  verfibookmark(String uid) async {
    await bookmark().verfibookmark(uid);
  }

  ServItem(String Servid, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          globals.uidServ = Servid;
          verfiheart(globals.uidServ);
          verfibookmark(globals.uidServ);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const servdetail(),
          ),
        );
      },
      child: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Services")
                .doc(Servid)
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
                        offset: Offset(4, 8),
                      ),
                    ],
                  ),
                  height: 155,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: snapshot.data!.get('imgUrl'),
                        imageBuilder: (context, imageProvider) => Container(
                          width: MediaQuery.of(context).size.width / 3,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover)),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: 60,
                            padding: const EdgeInsets.all(10),
                            child: Text(snapshot.data!.get('title'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Alexandria')),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            padding: const EdgeInsets.only(right: 7),
                            child: Text(snapshot.data!.get('description'),
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
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                );
              }
            })),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (globals.titelpageService == '') {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            "الشائعة",
            style: TextStyle(
                color: Colors.blue[900],
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Alexandria'),
          ),
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.blue[900],
          ),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Services')
                        .orderBy("Count", descending: true)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return Column(
                          children: [
                            Text(
                              "لا توجد أعمال",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Alexandria",
                                  color: Colors.blue[900]),
                            ),
                          ],
                        );
                      } else {
                        return ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 9);
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            primary: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ServItem(
                                  snapshot.data!.docs[index].id, index);
                            });
                      }
                    }),
                  )
                ],
              ),
            )),
      ));
    } else {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            globals.categoWhere,
            style: TextStyle(
                color: Colors.blue[900],
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Alexandria'),
          ),
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.blue[900],
          ),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Services')
                        .where("catogry", isEqualTo: globals.titelpageService)
                        .orderBy("Count", descending: true)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return Column(
                          children: [
                            Text(
                              "لا توجد أعمال",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Alexandria",
                                  color: Colors.blue[900]),
                            ),
                          ],
                        );
                      } else {
                        globals.titelpageService = '';
                        return ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 9);
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            primary: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ServItem(
                                  snapshot.data!.docs[index].id, index);
                            });
                      }
                    }),
                  )
                ],
              ),
            )),
      ));
    }
  }
}
