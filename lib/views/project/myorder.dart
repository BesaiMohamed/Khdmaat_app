import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newprojectflutter/resources/favorite.dart';
import 'package:newprojectflutter/resources/bookmark.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;
import 'package:newprojectflutter/views/project/service_details.dart';

import '../../resources/order.dart';

class myOrder extends StatefulWidget {
  const myOrder({super.key});
  @override
  State<myOrder> createState() => _myOrderState();
}

class _myOrderState extends State<myOrder> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool verfpage = true;
  String state = '';
  String newState = '';
  updatestate(String servId, String state) async {
    await OrderAuth().updatestate(servId, state);
  }

  showAlertDialog(BuildContext context, String servId) {
    Widget update = TextButton(
      child: Row(
        children: [
          Icon(
            Icons.save,
            color: Colors.blue[900],
          ),
          Text(
            "حفظ",
            style: TextStyle(
              fontSize: 17,
              color: Colors.blue[900],
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      onPressed: () {
        updatestate(servId, state);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Container(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey, width: 1), //border of dropdown button
            borderRadius:
                BorderRadius.circular(50), //border raiuds of dropdown button
          ),
          child: Container(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: DropdownButton<String>(
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 30,
              ),
              underline: Container(),
              isExpanded: true,
              onChanged: (String? newState3) {
                setState(() {
                  state = newState3!;
                });
              },
              value: state,
              items: <String>['جاري التنفيذ', 'متوقفة', 'منتهية']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Alexandria"),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      actions: [update],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  verfiheart(String uid) async {
    await favorite().verfieheart(uid);
  }

  verfibookmark(String uid) async {
    await bookmark().verfibookmark(uid);
  }

  verfiestate(String idServ) async {
    if (state == '') {
      state = await OrderAuth().stateorder(idServ);
      newState = state;
    }
  }

  stateserv() {
    if (state == 'جاري التنفيذ') {
      return Flexible(
          child: Column(
        children: const [
          Text(
            "جاري ",
            style: TextStyle(
                color: Colors.amber, fontSize: 14, fontFamily: 'Alexandria'),
          ),
          Text(
            " التنفيذ",
            style: TextStyle(
                color: Colors.amber, fontSize: 14, fontFamily: 'Alexandria'),
          )
        ],
      ));
    } else {
      if (state == "متوقفة") {
        return const Flexible(
            child: Text(
          "متوقفة",
          style: TextStyle(
              color: Colors.red, fontSize: 14, fontFamily: 'Alexandria'),
        ));
      } else {
        return const Flexible(
            child: Text(
          "منتهية",
          style: TextStyle(
              color: Colors.green, fontSize: 14, fontFamily: 'Alexandria'),
        ));
      }
    }
  }

  ServItem(String Servid) {
    verfiestate(Servid);
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
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        IconButton(
                            onPressed: () {
                              showAlertDialog(context, Servid);
                            },
                            icon: const Icon(Icons.edit)),
                        stateserv(),
                      ],
                    )
                  ],
                ),
              );
            }
          })),
    );
  }

  listpage() {
    if (verfpage == true) {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const PageScrollPhysics(),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Order')
                      .where("idworker", isEqualTo: _auth.currentUser!.uid)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            "قائمة الطلبات المستلمة فارغة",
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
                            return ServItem(
                                snapshot.data!.docs[index].get("servicId"));
                          });
                    }
                  }),
                )
              ],
            ),
          ));
    } else {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const PageScrollPhysics(),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Order')
                      .where("idClient", isEqualTo: _auth.currentUser!.uid)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            "قائمة الطلبات المرسلة فارغة",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Alexandria",
                                color: Colors.blue[900]),
                          ),
                        ],
                      );
                    } else {
                      if (snapshot.data!.docs.isEmpty) {
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
                                  snapshot.data!.docs[index].get("servicId"));
                            });
                      } else {
                        return Column(
                          children: [
                            Text(
                              "قائمة الطلبات المرسلة فارغة",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Alexandria",
                                  color: Colors.blue[900]),
                            ),
                          ],
                        );
                      }
                    }
                  }),
                )
              ],
            ),
          ));
    }
  }

  itemOfPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    verfpage = true;
                  });
                },
                child: Text(
                  "المستقبلة",
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alexandria'),
                )),
            Container(
              child: verfpage
                  ? Container(
                      height: 2,
                      width: 100,
                      decoration:
                          BoxDecoration(color: Colors.blue.withOpacity(0.4)),
                    )
                  : Container(),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    verfpage = false;
                  });
                },
                child: Text(
                  "المرسلة",
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alexandria'),
                )),
            Container(
              child: verfpage
                  ? Container()
                  : Container(
                      height: 2,
                      width: 100,
                      decoration:
                          BoxDecoration(color: Colors.blue.withOpacity(0.4)),
                    ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "الطلبات",
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
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  itemOfPage(),
                  const SizedBox(
                    height: 15,
                  ),
                  listpage()
                ],
              ),
            )));
  }
}
