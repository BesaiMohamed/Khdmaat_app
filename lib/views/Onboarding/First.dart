import 'package:flutter/material.dart';

class First extends StatefulWidget {
  const First({super.key});
  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 255, 255, 255)
                  ],
                ),
                image: DecorationImage(
                  alignment: Alignment(1, -0.5),
                  image: AssetImage('assets/img3.jpg'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 450),
                      height: 80,
                      width: double.infinity,
                      child: const Center(
                        child: Text(
                          'ساهم في تطوير نفسك',
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Alexandria',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 158, 250)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'ساعد العملاء بالعثور عليك',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(9.0, 9.0),
                                  blurRadius: 13.0,
                                  color: Color.fromARGB(30, 65, 5, 230),
                                ),
                              ],
                              fontWeight: FontWeight.w100,
                              fontFamily: 'Alexandria',
                              color: Color.fromARGB(255, 0, 158, 250),
                              fontSize: 19),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255)
                    ],
                  ),
                  image: DecorationImage(
                    alignment: Alignment(1, -0.5),
                    image: AssetImage('assets/img2.jpg'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 450),
                        height: 80,
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            'تحتاج عامل',
                            style: TextStyle(
                                fontSize: 28,
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 158, 250)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'قم بالبحث عن أقرب واحد إليك',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(9.0, 9.0),
                                    blurRadius: 10.0,
                                    color: Color.fromARGB(30, 65, 5, 230),
                                  ),
                                ],
                                fontWeight: FontWeight.w100,
                                color: Color.fromARGB(255, 0, 158, 250),
                                fontFamily: 'Alexandria',
                                fontSize: 19),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                          height: 70,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/LogIn');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    elevation: 0,
                                    minimumSize: const Size(120, 50),
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 158, 250),
                                  ),
                                  child: const Text(
                                    'دخول',
                                    style: TextStyle(
                                        fontFamily: 'Alexandria',
                                        fontSize: 23,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/Sing');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    elevation: 0,
                                    minimumSize: const Size(120, 50),
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 158, 250),
                                  ),
                                  child: const Text(
                                    'تسجيل',
                                    style: TextStyle(
                                        fontFamily: 'Alexandria',
                                        fontSize: 23,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
