// ignore_for_file: non_constant_identifier_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newprojectflutter/resources/messages/inf_massegs_M.dart';
import 'package:newprojectflutter/resources/messages/inf_chat_M.dart';
import 'package:newprojectflutter/resources/messages/inf_User_M.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newprojectflutter/resources/messages/user_serviceFirbase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newprojectflutter/widgets/Widgemethoudmassegs.dart';

import '../../resources/messages/message_res.dart';

// حمد currentUser راه هو الاميل لر نني خادم بيه
// ونتاراك داير id   ملا بدلوا
class masseg extends StatefulWidget {
  chat? massg;
  Users? User;
  masseg({this.massg, super.key, this.User}) {}
  @override
  State<masseg> createState() => _massegState();
}

class _massegState extends State<masseg> {
  Massegs Addmasseg = Massegs();
  final String currentUser = FirebaseAuth.instance.currentUser!.uid.toString();
//خدمت بشير بالتصرف خخخخ
  ///بدلوا بالايدي

  final GlobalKey<FormState> _glonlfey = GlobalKey<FormState>();
  final constent = FirebaseFirestore.instance;
  final controler = TextEditingController();
  bool isEmpty = false;
  String acitvity = "";
  @override
  void initState() {
    setState(() {
      isEmpty = controler.text.isEmpty;
    });
    super.initState();
  }

  actitvity(String id) async {
    acitvity = await MessageRes().activity(id);
  }

  Widget Chatinputfiled() {
    ImagePicker uploudimage = ImagePicker();
    XFile? image;
    // String? pthimage;
    return StreamBuilder(
        //ا الستريم درتوا يجيب  المحادثة لي بعثها المستخدم  لي  لبززت عليها ويجيبلي المحدثة لبعثها الملبوز عليه  لل مستخدم لي داير تسجيل الدخول
        stream: constent
            .collection("Massegs")
            .where("idusersender", isEqualTo: currentUser)
            .where("idUser", isEqualTo: widget.User!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          List<Massegs> massegs = [];
          if (snapshot.hasData) {
            for (var element in snapshot.data!.docs) {
              massegs.add(Massegs.fromjson(element.data()));
            }
          }

          actitvity(widget.User!.uid.toString());
          return StreamBuilder(
              // وهذ الستريم عكس لاخر وكل البينات يتم تجمعها في ليست واحدة
              stream: constent
                  .collection("Massegs")
                  .where("idusersender", isEqualTo: widget.User!.uid)
                  .where("idUser", isEqualTo: currentUser)
                  .snapshots(),
              // where("idUser", isEqualTo:widget.User!.uid ).where("idusersender",isEqualTo: currentUser)
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                for (var element in snapshot.data!.docs) {
                  massegs.add(Massegs.fromjson(element.data()));
                }
                //  مسح التكرار
                for (int i = 0; i < massegs.length; i++) {
                  for (int j = i + 1; j < massegs.length; j++) {
                    if (massegs[i].id == massegs[j].id) {
                      massegs.removeAt(j);
                    }
                  }
                }
                massegs.reversed;
                //ترتيب ليست حسب التاريخ
                massegs.sort((a, b) => a.datnow!.compareTo(b.datnow!));
                return Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      // reverse: true,
                      itemCount: massegs.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment:
                              widget.User!.uid == massegs[index].idUser
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                          children: [
                            //هذا الكنتينر يحتوي على الرسائل سواء كانت صورة اونص
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20 * 0.75, vertical: 5),
                                // width: 250,
                                // height: 250,
                                decoration: BoxDecoration(
                                    color: massegs[index].idUser ==
                                                widget.User!.uid &&
                                            massegs[index].Taype == "Text"
                                        ? Colors.blue[900]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                                child:
                                    //  massegsWidge(Addmasseg: Addmasseg)
                                    massegsWidge(Addmasseg: Addmasseg)
                                        .shwoData(massegs[index], this.context),
                              ),
                            )
                          ],
                        );
                      },
                    )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(40, 0, 0, 0),
                            blurRadius: 15,
                            offset: Offset(20, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: SafeArea(
                          child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 255, 255, 255),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(children: [
                              Expanded(
                                child: Form(
                                  key: _glonlfey,
                                  child: TextFormField(
                                    controller: controler,
                                    decoration: const InputDecoration(
                                      hintText: "نص الرسالة هنا",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              // icon send Message to  user
                              Visibility(
                                  // visible: !isEmpty,
                                  child: IconButton(
                                color: Colors.blue[900],
                                onPressed: () {
                                  if (_glonlfey.currentState!.validate()) {
                                    setState(() {
                                      _glonlfey.currentState!.save();
                                      Addmasseg.masseg = controler.text;
                                      Addmasseg.datnow = DateTime.now();
                                      Addmasseg.Taype = "Text";
                                      Addmasseg.idusersender = currentUser;
                                      Addmasseg.idUser = widget.User!.uid;
                                      Addmasseg.state = "غير مقروء";
                                      Auth().addMassge(Addmasseg);
                                    });
                                    controler.clear();
                                  }
                                },
                                icon: const Icon(Icons.send),
                              )),
                              //icon uploude to image in galore or camira
                              IconButton(
                                  color: Colors.blue[900],
                                  onPressed: () async {
                                    image = await uploudimage.pickImage(
                                        source: ImageSource.camera);
                                    if (image != null) {
                                      //  pthimage=image!.path;
                                      //    Addmasseg.masseg=pthimage;
                                      massegsWidge(Addmasseg: Addmasseg)
                                          .showimge(image!, this.context);
                                    }
                                  },
                                  icon: const Icon(Icons.camera_alt_outlined)),
                              IconButton(
                                  color: Colors.blue[900],
                                  onPressed: () async {
                                    image = await uploudimage.pickImage(
                                        source: ImageSource.gallery);
                                    if (image != null) {
                                      massegsWidge(Addmasseg: Addmasseg)
                                          .showimge(image!, this.context);
                                    }
                                  },
                                  icon: const Icon(Icons.wallpaper))
                            ]),
                          ))
                        ],
                      )),
                    ),
                  ],
                );
              });
        });
  }

//يالبشير خدمتك دايما مكعورة
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        toolbarHeight: 75,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackButton(),
            CachedNetworkImage(
              imageUrl: "${widget.User!.imgeurl}",
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 20,
                backgroundImage: imageProvider,
              ),
            ),
            const SizedBox(
              width: 20 * 0.75,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.User!.name}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  acitvity,
                  style: const TextStyle(fontSize: 10),
                )
              ],
            )
          ],
        ),
      ),
      body: Chatinputfiled(),
    );
  }
}
