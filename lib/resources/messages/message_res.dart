import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MessageRes {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> readLastMessage(String id) async {
    String res = 'لا رسائل';
    try {
      var data = await firestore
          .collection("Massegs")
          .where("idusersender", isEqualTo: auth.currentUser!.uid)
          .where("idUser", isEqualTo: id)
          .orderBy("datnow", descending: true)
          .limit(1)
          .get();
      var snapshot = data.docs.first;
      res = snapshot.get("masseg");
    } catch (e) {}
    return res;
  }

  Future<String> delateChat(String idchat) async {
    String res = "فشلت العملية";
    try {
      await firestore.collection("Cheat").doc(idchat).delete();
      res = "تم الحذف";
    } catch (e) {}
    return res;
  }

  Future<int> ifread(String idreciver) async {
    int count = 0;
    try {
      await firestore
          .collection("Massegs")
          .where("idusersender", isEqualTo: idreciver)
          .where("idUser", isEqualTo: auth.currentUser!.uid)
          .where("state", isEqualTo: "غير مقروء")
          .count()
          .get()
          .then(
            (res) => count = res.count,
            onError: (e) => count = 0,
          );
      return count;
    } catch (e) {
      return count;
    }
  }

  Future<int> readmessage(String idreciver) async {
    int count = 0;
    try {
      await firestore
          .collection("Massegs")
          .where("idusersender", isEqualTo: idreciver)
          .where("idUser", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((response) => {
                response.docs.forEach((doc) => {
                      firestore
                          .collection("Massegs")
                          .doc(doc.id)
                          .update({'state': "مقروء"})
                    })
              });
    } catch (e) {}
    return count;
  }

  Future<String> activity(String id) async {
    String res = "";
    try {
      var ref = await firestore.collection("Users").doc(id).get();
      bool snapshot = ref.get("isLogin");

      if (snapshot == true) {
        res = "نشط الأن";
      } else {
        Timestamp time = ref.get("lastActivite");
        DateTime time2 = time.toDate();
        res = readTimestamp(time2);
      }
    } catch (e) {}
    return res;
  }

  String readTimestamp(DateTime timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var diff = now.difference(timestamp);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(timestamp).toString() + "أخر نشاط كان ";
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = "منذ يوم";
      } else {
        time = " منذ " + diff.inDays.toString() + ' يوم ';
      }
    } else {
      if (diff.inDays == 7) {
        time = "منذ أسبوع ";
      } else {
        time = " منذ " + (diff.inDays / 7).floor().toString() + ' أسبوع ';
      }
    }

    return time;
  }
}
