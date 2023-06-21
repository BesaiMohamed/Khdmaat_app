import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../resources/auth_res.dart';
import '../../widgets/custom_loader.dart';

class ScuriteCompet extends StatefulWidget {
  const ScuriteCompet({super.key});
  @override
  State<ScuriteCompet> createState() => _ScuriteCompet();
}

class _ScuriteCompet extends State<ScuriteCompet> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();
  final TextEditingController _pass3 = TextEditingController();
  String pass = '';
  String email = '';
  bool change = false;
  bool changepas = false;
  bool icon1 = true, icon2 = true;
  final CustomLoader _loader = CustomLoader();

  changepassword() {
    if (changepas == false) {
      return Container();
    } else {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: TextFormField(
              controller: _pass1,
              obscureText: icon1,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    icon1 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      icon1 = !icon1;
                    });
                  },
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black, width: 32.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                labelText: "كلمة السر القديمة",
                labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(97, 61, 60, 60),
                    fontFamily: "Alexandria"),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: TextFormField(
              obscureText: icon2,
              controller: _pass2,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    icon2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      icon2 = !icon2;
                    });
                  },
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black, width: 32.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                labelText: "كلمة السر الجديدة",
                labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(97, 61, 60, 60),
                    fontFamily: "Alexandria"),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: TextFormField(
              obscureText: icon2,
              controller: _pass3,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    icon2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      icon2 = !icon2;
                    });
                  },
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black, width: 32.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                labelText: "أعد إدخال كلمة السر",
                labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(97, 61, 60, 60),
                    fontFamily: "Alexandria"),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    _loader.showLoader(context);
                    veerfi();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[900]),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                  ),
                  child: const Text(
                    "حفظ",
                    style: TextStyle(
                        fontSize: 23,
                        fontFamily: 'Alexandria',
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      changepas = !changepas;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                  ),
                  child: const Text(
                    "إلغاء",
                    style: TextStyle(
                        fontSize: 23,
                        fontFamily: 'Alexandria',
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          )
        ],
      );
    }
  }

  savedemail() {
    if (change == true) {
      return Row(
        children: [
          SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: () async {
                _loader.showLoader(context);
                veerfiemail();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
              ),
              child: const Text(
                "حفظ",
                style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Alexandria',
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                change = !change;
              });
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.redAccent)))),
            child: const Text(
              "إلغاء",
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Alexandria',
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  veerfi() async {
    String res;
    if (_pass2.text == '' || _pass3.text == '') {
      res = "أحد الحقول فارغة";
    } else {
      if (_pass2.text.length < 4 && _pass3.text.length < 4) {
        res = "كلمة السر قصيرة ";
      } else {
        if (_pass2.text != _pass3.text) {
          res = "كلمات السر غير متطابقة";
        } else {
          if (_pass1.text != pass) {
            res = "كلمة السر القديمة غير صحيحة";
          } else {
            res = await AuthRes().changepassword(_pass2.text, pass);
          }
        }
      }
    }
    if (res == "نجحت العملية") {
      _loader.hideLoader();
      Navigator.pop(context);

      Fluttertoast.showToast(
        msg: res,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
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

  veerfiemail() async {
    String res;
    if (_email.text == '') {
      res = "الحقل فارغ";
    } else {
      if (!_email.text.contains("@")) {
        res = "البريد الإلكتروني خاطئ";
      } else {
        if (_email.text == email) {
          res = "نفس البريد الإلكتروني";
        } else {
          res = await AuthRes().updateemail(_email.text, pass);
        }
      }
    }
    if (res == "نجحت العملية") {
      _loader.hideLoader();
      Navigator.pop(context);

      Fluttertoast.showToast(
        msg: res,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "أمن الحساب",
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
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            email = _auth.currentUser!.email.toString();
            pass = snapshot.data!.get("password");
            _email.text = snapshot.data!.get("email");
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    enabled: change,
                    controller: _email,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.mail_sharp),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 32.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: "البريد الإلكتروني ",
                      labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(97, 61, 60, 60),
                          fontFamily: "Alexandria"),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: TextButton(
                      onPressed: () {
                        if (change == false) {
                          setState(() {
                            change = !change;
                          });
                        }
                      },
                      child: Text(
                        "تغير البريد الإلكتروني ؟",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                            fontFamily: "Alexandria"),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: savedemail(),
                  )
                ]),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: TextButton(
                    onPressed: () {
                      if (changepas == false) {
                        setState(() {
                          changepas = !changepas;
                        });
                      }
                    },
                    child: Text(
                      "تغير كلمة السر ؟",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                          fontFamily: "Alexandria"),
                    ),
                  ),
                ),
                changepassword()
              ],
            );
          }
        },
      )),
    ));
  }
}
