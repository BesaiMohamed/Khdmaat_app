import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newprojectflutter/resources/messages/inf_chat_M.dart';
import 'package:newprojectflutter/resources/messages/inf_User_M.dart';
import 'package:newprojectflutter/views/auth/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../resources/auth_res.dart';
import '../../resources/messages/message_res.dart';

class Mas extends StatefulWidget {
  const Mas({super.key});

  @override
  State<Mas> createState() => _MasState();
}

class _MasState extends State<Mas> {
  final FirebaseFirestore constent = FirebaseFirestore.instance;
  final FirebaseAuth currentUser = FirebaseAuth.instance;
  String message = "", lastTime = "";
  int counter = 0;
  bool verfilogin = true;
  countmessage(String idReciver) async {
    counter = await MessageRes().ifread(idReciver);
    return counter;
  }

  readmessage(String idReciver) async {
    counter = await MessageRes().readmessage(idReciver);
    return counter;
  }

  islogin(String id) async {
    verfilogin = await AuthRes().islogine(id);
  }

  @override
  void initState() {
    counter;
  }

  String readTimestamp(DateTime timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var diff = now.difference(timestamp);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(timestamp);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = "منذ يوم";
      } else {
        time = " منذ " + diff.inDays.toString() + ' يوم ';
      }
    } else {
      if (diff.inDays == 7) {
        time = "منذ أسبوع ";
      } else {
        time = " منذ " + (diff.inDays / 7).floor().toString() + ' أسبوع ';
      }
    }

    return time;
  }

  showAlertDialog(BuildContext context) {
    Widget message = TextButton(
      child: Row(
        children: const [
          Text(
            "حذف ",
            style: TextStyle(
              fontSize: 17,
              color: Colors.redAccent,
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      onPressed: () {
        setState(() {});
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "هل أنت متاكد من حذف الرسالة",
        style: TextStyle(
          fontSize: 17,
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.bold,
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

  Widget returnmessage(String id) {
    countmessage(id);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Massegs")
          .where("idusersender", isEqualTo: currentUser.currentUser!.uid)
          .where("idUser", isEqualTo: id)
          .orderBy("datnow", descending: true)
          .limit(1)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Massegs")
                .where("idusersender", isEqualTo: currentUser.currentUser!.uid)
                .where("idUser", isEqualTo: id)
                .orderBy("datnow", descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot2) {
              if (!snapshot2.hasData) {
                return Container();
              } else {
                var doucment = snapshot2.data!.docs.first;
                message = doucment.get("masseg");
                return Text("${doucment.get("masseg")}");
              }
            },
          );
        } else {
          return Row(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              String message1 = data['masseg'];
              Timestamp time1 = data['datnow'];
              lastTime = readTimestamp(time1.toDate());
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Massegs")
                    .where("idUser", isEqualTo: currentUser.currentUser!.uid)
                    .where("idusersender", isEqualTo: id)
                    .orderBy("datnow", descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot2) {
                  if (!snapshot2.hasData) {
                    message = message1;
                    return Text(message1);
                  } else {
                    return Row(
                      children:
                          snapshot2.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String message2 = data['masseg'];
                        Timestamp time2 = data['datnow'];
                        if (time1.compareTo(time2) > 0) {
                          message = message1;
                          lastTime = readTimestamp(time1.toDate());
                        } else {
                          message = message2;
                          lastTime = readTimestamp(time2.toDate());
                        }

                        return Row(
                          children: [
                            Text(
                              message,
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Alexandria',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              lastTime,
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'Alexandria',
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              );
            }).toList(),
          );
        }
      },
    );
  }

  delateChat(String idcaht) async {
    await MessageRes().delateChat(idcaht);
  }

  counterofmessage() {
    if (counter == 0) {
      return RefreshIndicator(
        child: Container(),
        onRefresh: () async {
          Future(() {
            setState(() {});
          });
        },
      );
    } else {
      return CircleAvatar(
        radius: 15,
        backgroundColor: Colors.orange,
        child: Text(
          counter.toString(),
          style: const TextStyle(
              fontSize: 17,
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      );
    }
  }

  Widget body(chat chat) {
    // ignore: non_constant_identifier_names
    Users ListUses = Users();
    return StreamBuilder(
        stream: constent.collection("Users").doc(chat.idusersender).snapshots(),
        builder: (context, snapshot) {
          islogin(chat.idusersender.toString());
          initState();
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.data!.exists) {
            return Container();
          }
          ListUses = Users.fromjson(snapshot.data!.data());
          return InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0 * 0.75),
                child: Row(
                  children: [
                    Stack(children: [
                      CachedNetworkImage(
                        imageUrl: ListUses.imgeurl.toString(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        placeholder: (context, url) =>
                            const Icon(Icons.person, color: Colors.blue),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 25,
                          backgroundImage: imageProvider,
                        ),
                      ),

                      ///يجي الشرط نتاع اذا كان المستحدم نشط اولا
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                color: verfilogin
                                    ? const Color(0xFF00BF6D)
                                    : Colors.redAccent,
                                shape: BoxShape.circle),
                          ))
                    ]),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${ListUses.name}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Alexandria',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Opacity(
                                    opacity: 0.65,
                                    child:
                                        returnmessage(ListUses.uid.toString())),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    counterofmessage(),
                  ],
                ),
              ),
              onTap: () {
                readmessage(ListUses.uid.toString());
                //تمري القم
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => masseg(
                              User: ListUses,
                              massg: chat,
                            )));
              },
              onLongPress: () {
                showAlertDialog(context);
              });
        });
  }

//يالبشير كنت قادر تدي id تاع شات برك وتخدم بيه نتا ضرب تحويطة في الفايربيس خليتيني ندؤي id تاع المستخدمين في زوج باه نخدم
//ياخي ياخي اخدم بذكاء+
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'المراسلات',
            style: TextStyle(
              fontSize: 26,
              color: Colors.orange,
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 248, 237, 222),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 35,
                      color: Colors.orange,
                    ))
              ],
            )
          ],
        ),
        body: StreamBuilder(
            stream: constent
                .collection("Cheat")
                .where("idUser", isEqualTo: currentUser.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              // ignore: non_constant_identifier_names
              List<chat> ListChat = [];
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              for (var element in snapshot.data!.docs) {
                ListChat.add(chat.fromjson(element.data()));
              }
              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: ListChat.length,
                    itemBuilder: (context, index) {
                      return ListChat.isEmpty
                          ? Center(
                              child: Text("لاتوجد رسائل",
                                  style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 17,
                                      fontFamily: 'Alexandria',
                                      fontWeight: FontWeight.bold)),
                            )
                          : body(ListChat[index]);
                    },
                  ))
                ],
              );
            }));
  }
}
