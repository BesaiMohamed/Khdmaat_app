import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newprojectflutter/resources/favorite.dart';
import 'package:newprojectflutter/resources/bookmark.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;
import 'package:newprojectflutter/views/project/Project_personel/updateinfoServ.dart';
import 'package:newprojectflutter/views/project/service_details.dart';

import '../../../resources/proj_res.dart';

class myServices extends StatefulWidget {
  const myServices({super.key});

  @override
  State<myServices> createState() => _myServicesState();
}

class _myServicesState extends State<myServices> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  showAlertDialog(BuildContext context, String servid) {
    Widget message = TextButton(
      child: Row(
        children: [
          const Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
          Text(
            "حذف ",
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
        deleteservice(servid);
        Fluttertoast.showToast(
          msg: "تم حذف الخدمة",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "هل أنت متأكد ؟",
        style: TextStyle(
          fontSize: 17,
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        "بمجرد الضغط سيتم حذف الخدمة",
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Alexandria',
        ),
      ),
      actions: [
        Row(
          children: [message],
        )
      ],
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

  deleteservice(String idserv) async {
    await ProjectRes().deleteservic(idserv);
  }

  verfibookmark(String uid) async {
    await bookmark().verfibookmark(uid);
  }

  ItemServ(String Image, String title, String desc, String uidserv) {
    return InkWell(
      onTap: () {
        setState(() {
          globals.uidServ = uidserv;
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
        height: 155,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => updateProject(servid: uidserv),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue[900],
                    )),
                IconButton(
                    onPressed: () {
                      showAlertDialog(context, uidserv);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "خدماتي",
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
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Services')
                            .where('user', isEqualTo: _auth.currentUser!.uid)
                            .snapshots(),
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
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
                                  return ItemServ(
                                      snapshot.data!.docs[index]['imgUrl'],
                                      snapshot.data!.docs[index]['title'],
                                      snapshot.data!.docs[index]['description'],
                                      snapshot.data!.docs[index]['serviceuid']);
                                });
                          }
                        }),
                      ),
                    ],
                  ),
                ))));
  }
}
