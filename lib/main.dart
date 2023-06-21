import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newprojectflutter/resources/auth_res.dart';
import 'package:newprojectflutter/views/Onboarding/First.dart';
import 'package:firebase_auth/firebase_auth.dart';
//هذا الباكج تاع الكتابة باالعربي
import 'package:flutter_localizations/flutter_localizations.dart';
import 'API/firebas_Api.dart';
import 'views/auth/Login.dart';
import 'views/auth/Sing.dart';
import 'Swit.dart';

bool? islogin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  isloginstart() async {
    await AuthRes().isloginestart();
  }

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    islogin = true;
    isloginstart();
    print("truekkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    await FirebaseApi().initnotfications();
  } else {
    print("falseeeeeeeeeeeeeeeeeeeee");
    islogin = false;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //كلاس الكتابة بالعربية
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
      ],
      //نهاية الكلاس

      debugShowCheckedModeBanner: false,

      initialRoute: islogin == false ? '/' : '/Swit',
      routes: {
        '/': (context) => const First(),
        '/LogIn': (context) => const LogIn(),
        '/Sing': (context) => const Sing(),
        '/Swit': (context) => const bottom_bar(),
      },
    );
  }
}
