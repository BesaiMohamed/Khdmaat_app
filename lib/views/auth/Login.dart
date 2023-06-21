import 'package:flutter/material.dart';
import 'package:newprojectflutter/views/page/Home.dart';
import 'package:newprojectflutter/widgets/custom_loader.dart';
import 'package:newprojectflutter/resources/auth_res.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newprojectflutter/views/auth/rest_password.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final CustomLoader _loader = CustomLoader();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool? isChecked = false;
  bool _passwordVisible = false;
// هذه تقوم بالتحلص من المتغيرات من الذاكرة لكي لا تبقى تستهلك في الموارد
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _passwordVisible = false;
  }

  login() async {
    String email = _email.text.toString().trim();
    String password = _password.text.toString().trim();
    String res = await AuthRes().login(email, password);

    if (res == 'success') {
      _loader.hideLoader();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => const Home()),
        ),
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 229, 243, 253),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 250),
                  child: const Text(
                    "خِدمات",
                    style: TextStyle(
                      fontSize: 90,
                      fontFamily: 'Alnaseeb',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 7, 36, 72),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: 350,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xF4f4f4f4),
                  ),
                  // Email
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
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.w100,
                          color: Color.fromARGB(97, 61, 60, 60)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 350,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xF4f4f4f4),
                  ),
                  //Password
                  child: TextFormField(
                    obscureText: !_passwordVisible,
                    controller: _password,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 17),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: "كلمة السر ",
                        hintStyle: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w100,
                            color: Color.fromARGB(97, 61, 60, 60)),
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
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 40),
                      child: TextButton(
                        child: const Text(
                          "هل نسيت كلمة السر؟",
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Alexandria',
                              color: Color.fromARGB(255, 0, 158, 250),
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResetPassword(),
                              ));
                        },
                      ),
                    ),
                    const SizedBox(width: 50),
                    Container(
                      margin: const EdgeInsets.only(left: 45),
                    ),
                    const Text(
                      "تذكرني",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Alexandria',
                          color: Color.fromARGB(255, 0, 158, 250),
                          fontWeight: FontWeight.w600),
                    ),
                    Checkbox(
                        value: isChecked,
                        activeColor: const Color.fromARGB(255, 0, 158, 250),
                        onChanged: (newBool) {
                          setState(() {
                            isChecked = newBool;
                          });
                        }),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _loader.showLoader(context);
                    login();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 7, 36, 72)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                  ),
                  child: const Text(
                    "سجل الدخول",
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 85,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ليس لديك حساب؟",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 7, 36, 72),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Alexandria'),
                    ),
                    SizedBox(
                      height: 40,
                      child: TextButton(
                        child: const Text(
                          "أنشى حساب",
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/Sing');
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
