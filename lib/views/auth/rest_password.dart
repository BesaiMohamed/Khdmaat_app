import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/resources/auth_res.dart';
import '/widgets/custom_loader.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _email = TextEditingController();
  final CustomLoader _loader = CustomLoader();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  resetPass() async {
    String email = _email.text.trim().toString();
    String res = await AuthRes().resetPassword(email);
    if (res == 'success') {
      _loader.hideLoader();
      Fluttertoast.showToast(
        msg: 'تم إرسال رابط إستعادة كلمة السر إلى البريد الإلكتروني',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 229, 243, 253),
        ),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'نسيت كلمة السر ',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Alexandria",
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 138, 196),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'قم بإدخال إيميلك لإستعادة كلمة السر',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Alexandria",
                    color: Color.fromARGB(2200, 61, 60, 60),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xF4f4f4f4),
                  ),
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.mail),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 32.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: "البريد الإلكتروني",
                      hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(97, 61, 60, 60),
                          fontFamily: "Alexandria"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _loader.showLoader(context);
                    resetPass();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 0, 158, 250)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                  ),
                  child: const Text(
                    "إستعادة كلمة السر",
                    style: TextStyle(
                        fontSize: 23,
                        fontFamily: 'Alexandria',
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
