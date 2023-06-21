import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> handelBackmessaging(RemoteMessage message) async {
  print("titel :${message.notification!.title}");
  print("body :${message.notification!.body}");
  print("paylod :${message.data}");

  var ref = FirebaseFirestore.instance.collection('Notification').doc();
  await ref.set({
    "userId": FirebaseAuth.instance.currentUser!.uid,
    "titel": message.notification!.title,
    "body": message.notification!.body,
    "paylod": message.data.toString(),
    "notifyId": ref.id
  });
}

class FirebaseApi {
  final firebsaeMessaging = FirebaseMessaging.instance;
  Future<void> initnotfications() async {
    await firebsaeMessaging.requestPermission();
    final fcmnotifctions = await firebsaeMessaging.getToken();

    var query = await FirebaseFirestore.instance
        .collection("Token")
        .where("idUser", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (query.docs.isEmpty) {
      await FirebaseFirestore.instance.collection("Token").doc().set({
        'token': fcmnotifctions,
        "idUser": FirebaseAuth.instance.currentUser!.uid
      });

      var ref = FirebaseFirestore.instance.collection('Notification').doc();
      await ref.set({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "titel": "مرحباُ 👋",
        "body":
            "مرحبا بك ،يسعدنا إنضمامك لنا ..لاتنسى تحديث معلوماتك لكي تنشر أعمالك",
        "notifyId": ref.id,
        "state": "غير مقروء",
        "date": DateTime.now()
      });
    }

    print("token :$fcmnotifctions");
    FirebaseMessaging.onBackgroundMessage(handelBackmessaging);
  }
}
