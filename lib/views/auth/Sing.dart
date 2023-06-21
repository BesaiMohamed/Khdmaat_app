// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:newprojectflutter/widgets/custom_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newprojectflutter/resources/auth_res.dart';

import 'dart:math';

class Sing extends StatefulWidget {
  const Sing({super.key});
  @override
  State<Sing> createState() => _SingState();
}

class _SingState extends State<Sing> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repassword = TextEditingController();

  final CustomLoader _loader = CustomLoader();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  var avatars = [
    'https://firebasestorage.googleapis.com/v0/b/bmarket-b690b.appspot.com/o/1b96ad1f07feee81fa83c877a1e350ce.webp?alt=media&token=c7bc5790-c3cd-409c-b574-1ac020cba0fe',
    'https://firebasestorage.googleapis.com/v0/b/bmarket-b690b.appspot.com/o/unnamed.jpg?alt=media&token=e74c23d8-fd23-4b1d-ae92-6a379e086381',
  ];

  createAccount() async {
    var avatarList = avatars[Random().nextInt(avatars.length)];
    String name = _name.text.toString().trim();
    String email = _email.text.toString().trim();
    String password = _password.text.toString().trim();

    String res = await AuthRes().createAccount(
      name,
      avatarList,
      email,
      password,
    );

    if (res == 'success') {
      _loader.hideLoader();
      Navigator.pop(context);
    } else {
      _loader.hideLoader();
      Fluttertoast.showToast(
        msg: res,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 0, 138, 196),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  ////
  //final GlobalKey<FormState> _glonlfey = GlobalKey<FormState>();
  TextEditingController datecontrler = TextEditingController();
  @override
  void initState() {
    super.initState();
    datecontrler.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 229, 243, 253),
        ),
        child: SingleChildScrollView(
          ///يا الطاهر هذي هيا الودجت لي قتلك عليها
          child: Form(
            // هذا المفتاح هو لي نفاليدي بيه الحقول كاملين
            //  key: _glonlfey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 25, top: 80),
                  child: Text(
                    "إنشاء حساب",
                    style: TextStyle(
                        color: Color.fromARGB(255, 7, 36, 72),
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Alnaseeb"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  height: 50,

                  /// الاسم full name
                  ///
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 32.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: "الإسم الكامل",
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(97, 61, 60, 60),
                          fontFamily: "Alexandria"),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xF4f4f4f4),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 350,
                  height: 50,
                  //العنوان
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.mail),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 32.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: "الإيميل",
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(97, 61, 60, 60),
                          fontFamily: "Alexandria"),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xF4f4f4f4),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 350,
                  height: 50,
                  //phone number رقم الهاتف
                  child: TextFormField(
                    controller: _password,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 17),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: "كلمة السر",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(97, 61, 60, 60),
                            fontFamily: "Alexandria"),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                            size: 25.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xF4f4f4f4),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 350,
                  height: 50,
                  //phone number رقم الهاتف
                  child: TextFormField(
                    controller: _repassword,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 17),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: "أعد كلمة السر",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(97, 61, 60, 60),
                            fontFamily: "Alexandria"),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                            size: 25.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xF4f4f4f4),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 60),
                  child: ElevatedButton(
                    //الطاهر هنا لازم المستخدم كي يدخل للالصفحة الرئسية لازم ديرلوا انوا ما يقدرش يرج للور باBrake
                    onPressed: () async {
                      if (_password.text != _repassword.text) {
                        Fluttertoast.showToast(
                          msg: 'كلمة السر غير متطابقة',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromARGB(255, 0, 138, 196),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        _loader.showLoader(context);
                        createAccount();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 7, 36, 72)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 60, vertical: 15)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                    ),
                    child: Text(
                      "سجل",
                      style: TextStyle(
                          fontSize: 23,
                          fontFamily: 'Alexandria',
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Text(
                  "بالتسجيل ،فأنت توافق على ",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alexandria',
                      color: Color.fromARGB(255, 7, 36, 72)),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "شروط الخصوصية",
                  style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 158, 250),
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
