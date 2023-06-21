import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyNotify extends StatefulWidget {
  const MyNotify({super.key});
  @override
  State<MyNotify> createState() => _MyNotifyState();
}

class _MyNotifyState extends State<MyNotify> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  deleatnotify(String notid) async {
    await FirebaseFirestore.instance
        .collection('Notification')
        .doc(notid)
        .delete();
  }

  ServItem(String Notid) {
    return InkWell(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Notification")
              .doc(Notid)
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
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(snapshot.data!.get('titel'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Alexandria')),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          padding: const EdgeInsets.only(right: 7),
                          child: Text(snapshot.data!.get('body'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Alexandria')),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          deleatnotify(Notid);
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete))
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
          "الإشعارات",
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
                      .collection('Notification')
                      .where("userId", isEqualTo: _auth.currentUser!.uid)
                      .orderBy("date", descending: false)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            "قائمة الإشعارات فارغة",
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
                                snapshot.data!.docs[index]["notifyId"]);
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
