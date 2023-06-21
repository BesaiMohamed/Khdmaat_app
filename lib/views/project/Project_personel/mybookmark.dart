import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:newprojectflutter/resources/favorite.dart';
import 'package:newprojectflutter/resources/bookmark.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;
import 'package:newprojectflutter/views/project/service_details.dart';

class MyBookMark extends StatefulWidget {
  const MyBookMark({super.key});
  @override
  State<MyBookMark> createState() => _MyBookMarkState();
}

class _MyBookMarkState extends State<MyBookMark> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool heatVerfi = true;
  int _selectedIndex = 0;
  List<int> listindex = [];

  AddBookMark(String Servid) async {
    await bookmark().addbookmarkfrommylist(Servid);
  }

  DeleateBookMark(String Servid) async {
    await bookmark().delatebookmarkfrommylist(Servid);
  }

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
                      offset: Offset(4, 8), // Shadow position
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
                    IconButton(
                      icon: Icon(
                        heatVerfi && listindex.contains(index)
                            ? Icons.bookmark
                            : LineIcons.bookmarkAlt,
                        color: Colors.blue[900],
                        size: 30,
                      ),
                      onPressed: () {
                        if (listindex.contains(index)) {
                          listindex.remove(index);
                          DeleateBookMark(Servid);
                        } else {
                          listindex.add(index);
                          AddBookMark(Servid);
                        }
                        setState(() {});
                      },
                    )
                  ],
                ),
              );
            }
          })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "المحفوظات",
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
                      .collection('Users')
                      .doc(_auth.currentUser!.uid)
                      .collection("BookMark")
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            "قائمة المفضالات فارغة",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Alexandria",
                                color: Colors.blue[900]),
                          ),
                        ],
                      );
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
                            if (!listindex.contains(index) &&
                                _selectedIndex != snapshot.data!.docs.length) {
                              listindex = listindex + [index];
                              _selectedIndex++;
                            }
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
