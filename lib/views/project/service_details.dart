import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newprojectflutter/resources/favorite.dart';
import 'package:newprojectflutter/resources/bookmark.dart';
import 'package:newprojectflutter/resources/proj_res.dart';
import 'package:newprojectflutter/views/auth/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newprojectflutter/resources/order.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../resources/auth_res.dart';
import '../../widgets/custom_loader.dart';
import '../page/Mas.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class servdetail extends StatefulWidget {
  const servdetail({super.key});
  @override
  State<servdetail> createState() => _servdetailState();
}

class _servdetailState extends State<servdetail> {
  int count = 0;
  String _iduserInserv = '';
  String avtarUrl = '';
  String servurlimg = "https://i.ytimg.com/vi/LcoviG-v9pI/maxresdefault.jpg";
  bool hasCallSupport = false;
  String rating2 = '1';
  final TextEditingController _reviwes = TextEditingController();
  final CustomLoader _loader = CustomLoader();

  addraiting() async {
    String reviwes = _reviwes.text.toString().trim();
    String res = await AuthRes().addraiting(globals.uidServ, reviwes, rating2);

    if (res == 'success') {
      _loader.hideLoader();
      Fluttertoast.showToast(
        msg: " شكرا..لقد تم إضافة تقيمك",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 0, 138, 196),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      _loader.hideLoader();
      Fluttertoast.showToast(
        msg: res,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 0, 138, 196),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  showAlertDialog(BuildContext context) {
    Widget message = TextButton(
      child: Row(
        children: [
          Icon(
            Icons.message,
            color: Colors.amber[900],
          ),
          Text(
            "رسالة ",
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
        creatOrder();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Mas(),
          ),
        );
      },
    );
    Widget call = TextButton(
      child: Row(
        children: [
          Icon(
            Icons.call,
            color: Colors.green[500],
          ),
          Text(
            "هاتف ",
            style: TextStyle(
              fontSize: 17,
              color: Colors.blue[900],
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      onPressed: () async {
        PermissionStatus p = await Permission.camera.request();
        if (p == PermissionStatus.granted) {
          FlutterPhoneDirectCaller.callNumber(globals.phoneWorker);
        } else {
          Fluttertoast.showToast(
              msg: "تحتاج سماح على الأذونات",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromARGB(255, 0, 138, 196),
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "كيف تريد الإتصال بالعامل؟",
        style: TextStyle(
          fontSize: 17,
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        "بمجرد ظغط يتم إنشاء طلب",
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Alexandria',
        ),
      ),
      actions: [
        Row(
          children: [message, call],
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

  creatOrder() async {
    await OrderAuth().creatorder(globals.myid, _iduserInserv, globals.uidServ);
  }

  reaiting() {
    return Container(
      padding: const EdgeInsets.all(7),
      child: Column(
        children: [
          TextFormField(
            maxLines: null,
            controller: _reviwes,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.reviews),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 32.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              labelText: "الوصف",
              labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(97, 61, 60, 60),
                  fontFamily: "Alexandria"),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              rating2 = rating.toString();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              addraiting();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.yellow[700]),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 45, vertical: 15)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
            ),
            child: Text(
              "تقديم",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Alexandria',
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    servurlimg;
    avtarUrl;
  }

  avatar(String iduserInserv) async {
    await ProjectRes().getAvatr(iduserInserv);
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
                            initialRating: 1,
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

  addhear() async {
    await favorite().addheart();
  }

  addbookmark() async {
    await bookmark().addbookmark();
  }

  delatehear() async {
    await favorite().delateheart();
  }

  delatebookmark() async {
    await bookmark().delatebookmark();
  }

  heartsContdes(int count) async {
    await favorite().heartContdes(count);
  }

  heartsContaes(int count) async {
    await favorite().heartContaes(count);
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Services')
                .doc(globals.uidServ)
                .snapshots(),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                count = snapshot.data!.get('Count');
                servurlimg = snapshot.data!.get('imgUrl');
                _iduserInserv = snapshot.data!.get('user');
                avatar(_iduserInserv);
                avtarUrl = globals.userAvatr;
                initState();
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
                          padding: const EdgeInsets.only(top: 10, bottom: 25),
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
                        Text(
                          "${snapshot.data!.get('title')}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alexandria'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${snapshot.data!.get('catogry')} ",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Alexandria'),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      count.toString(),
                                      style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14,
                                          fontFamily: 'Alexandria'),
                                    ),
                                    const Icon(
                                      (LineIcons.heartAlt),
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      globals.raitinserv.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Alexandria'),
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 27,
                                    )
                                  ]),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(
                            height: 4,
                          ),
                        ),
                        Text(
                          "${snapshot.data!.get('description')}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Alexandria'),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(
                            height: 4,
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const profileuser(),
                                    ));
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(70, 10, 25, 135),
                                radius: 29,
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundImage:
                                      NetworkImage(globals.userAvatr),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              globals.userName,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Alexandria'),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(
                            height: 4,
                          ),
                        ),
                        /////////hjhjhjhjhj////////
                        const Text(
                          "قيم هذه الخدمة",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alexandria'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        reaiting(),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(
                            height: 4,
                          ),
                        ),
                        const Text(
                          "التقيمات",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alexandria'),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Ratings')
                                    .where("servid", isEqualTo: globals.uidServ)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text("لا تقيمات",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'Alexandria'));
                                  } else {
                                    if (snapshot.data!.docs.isEmpty) {
                                      return const Text("لا تقيمات",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Alexandria'));
                                    } else {
                                      return ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            Widgetrevies(
                                          snapshot.data!.docs[index]
                                              .get("Rating"),
                                          snapshot.data!.docs[index]
                                              .get("comment"),
                                          snapshot.data!.docs[index]
                                              .get("userreviews"),
                                        ),
                                      );
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }),
          );
        });
  }

  appbarback(BuildContext context) {
    initState();
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [
                0.1,
                0.9,
              ],
              colors: [
                Colors.black.withOpacity(.3),
                Colors.black.withOpacity(.8),
              ]),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        ),
      ),
    );
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
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  buttonheart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        //ماتصدقش الونتاب هنا
        onTap: () {},
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 5, left: 13),
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: showwidgetheart(),
          ),
        ),
      ),
    );
  }

  showwidgetheart() {
    if (globals.verfieheart == true) {
      return IconButton(
          onPressed: () async {
            delatehear();
            heartsContdes(count);
            setState(() {
              globals.verfieheart = false;
            });
          },
          icon: const Icon(LineIcons.heartAlt, size: 30, color: Colors.white));
    } else {
      return IconButton(
          onPressed: () async {
            addhear();
            heartsContaes(count);
            setState(() {
              globals.verfieheart = true;
            });
          },
          icon: const Icon(LineIcons.heart, size: 30, color: Colors.white));
    }
  }

  buttonbookmark(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 55),
      child: InkWell(
        onTap: () {},
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 5, left: 5),
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: showwidgetBookMark()),
        ),
      ),
    );
  }

  showwidgetBookMark() {
    if (globals.verfiebookmark == true) {
      return IconButton(
          onPressed: () async {
            delatebookmark();
            setState(() {
              globals.verfiebookmark = false;
            });
          },
          icon: const Icon(Icons.bookmark, size: 30, color: Colors.white));
    } else {
      return IconButton(
          onPressed: () async {
            addbookmark();
            setState(() {
              globals.verfiebookmark = true;
            });
          },
          icon: const Icon(LineIcons.bookmark, size: 30, color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            /*  appBar: AppBar(
        title: Text("معلومات الخدمة"),
      ),
      */
            body: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Services')
                        .doc(globals.uidServ)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return SizedBox(
                            child: CachedNetworkImage(
                          imageUrl: snapshot.data!.get('imgUrl'),
                          imageBuilder: (context, imageProvider) => SizedBox(
                            child: Image(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                height: 400),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ));
                      }
                    }),
                  ),
                ),
                appbarback(context),
                buttonheart(context),
                buttonbookmark(context),
                buttonArrow(context),
                scroll(),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                showAlertDialog(context);
              },
              label: const Text('طلب الخدمة',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Alexandria')),
              icon: const Icon(
                Icons.assignment_return_rounded,
                color: Colors.black,
              ),
              backgroundColor: Colors.amber,
            )));
  }
}
