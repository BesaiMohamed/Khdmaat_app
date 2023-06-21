import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_icons/line_icons.dart';
import 'package:newprojectflutter/views/project/Project_personel/add_project.dart';
import 'package:newprojectflutter/views/project/Project_personel/myServices.dart';

import '../../resources/auth_res.dart';
import '../Onboarding/First.dart';
import '../auth/SceuriteCompet.dart';
import '../auth/myInfo.dart';
import '../project/Project_personel/mybookmark.dart';
import '../project/Project_personel/myfavorite.dart';
import '../project/myorder.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signout() async {
    await AuthRes().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(_auth.currentUser!.uid)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(25)),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CachedNetworkImage(
                            imageUrl: snapshot.data!.get('photoUrl'),
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  const Color.fromARGB(50, 235, 230, 230),
                              child: CircleAvatar(
                                radius: 47,
                                backgroundImage: imageProvider,
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(snapshot.data!.get('name'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontFamily: 'Alexandria',
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    );
                  }
                }),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Text("حسابي",
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 20,
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(children: [
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.blue[900],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const addProject()));
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.add_box,
                                size: 30,
                                color: Color.fromARGB(255, 75, 68, 83),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "إضافة خدمة",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 75, 68, 83),
                                    fontSize: 17,
                                    fontFamily: 'Alexandria'),
                              )
                            ],
                          )),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.blue[900],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const myServices()));
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.home_repair_service_rounded,
                                size: 30,
                                color: Color.fromARGB(255, 75, 68, 83),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "خدماتي ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 75, 68, 83),
                                    fontSize: 17,
                                    fontFamily: 'Alexandria'),
                              )
                            ],
                          )),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.blue[900],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const myOrder()));
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.pageview,
                                size: 30,
                                color: Color.fromARGB(255, 75, 68, 83),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "الطلبات ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 75, 68, 83),
                                    fontSize: 17,
                                    fontFamily: 'Alexandria'),
                              )
                            ],
                          )),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.blue[900],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const myfavorite()));
                          },
                          child: Row(
                            children: const [
                              Icon(
                                LineIcons.heartAlt,
                                size: 30,
                                color: Color.fromARGB(255, 75, 68, 83),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "المفضلات  ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 75, 68, 83),
                                    fontSize: 17,
                                    fontFamily: 'Alexandria'),
                              ),
                            ],
                          )),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.blue[900],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyBookMark()));
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.bookmark,
                                size: 30,
                                color: Color.fromARGB(255, 75, 68, 83),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "المحفوظات ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 75, 68, 83),
                                    fontSize: 17,
                                    fontFamily: 'Alexandria'),
                              )
                            ],
                          )),
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Text("الإعدادات",
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 20,
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(children: [
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white, // Background color
                            onPrimary: Colors
                                .blue[900], // Text Color (Foreground color)
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyInfo()));
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.person_pin_rounded,
                                size: 30,
                                color: Color.fromARGB(255, 75, 68, 83),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "معلوماتي الشخصية",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 75, 68, 83),
                                    fontSize: 17,
                                    fontFamily: 'Alexandria'),
                              )
                            ],
                          )),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.blue[900],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScuriteCompet()));
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.lock_person,
                                size: 30,
                                color: Color.fromARGB(255, 75, 68, 83),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "أمن الحساب ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 75, 68, 83),
                                    fontSize: 17,
                                    fontFamily: 'Alexandria'),
                              )
                            ],
                          )),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.blue[900],
                          ),
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Icon(
                                Icons.help,
                                size: 30,
                                color: Color.fromARGB(255, 75, 68, 83),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "مساعدة",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 75, 68, 83),
                                    fontSize: 17,
                                    fontFamily: 'Alexandria'),
                              )
                            ],
                          )),
                      TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.blue[900],
                          ),
                          onPressed: () {
                            signout();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const First()));
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.logout_outlined,
                                size: 30,
                                color: Color.fromARGB(255, 75, 68, 83),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "تسجيل الخروج",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 75, 68, 83),
                                    fontSize: 17,
                                    fontFamily: 'Alexandria'),
                              )
                            ],
                          )),
                    ]),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
