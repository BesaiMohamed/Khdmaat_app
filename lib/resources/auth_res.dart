import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:newprojectflutter/resources/storage_res.dart';

class AuthRes {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createAccount(
    String name,
    String photoUrl,
    String email,
    String password,
  ) async {
    String res = 'خطأ..حاول مرة أخرى';
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      if (!email.contains('@')) {
        res = "البريد الإلكتروني خاطئ";
      } else {
        try {
          var query = await _firestore.collection("Users").doc(email).get();
          if (!query.exists) {
            await _auth.createUserWithEmailAndPassword(
                email: email, password: password);
            await _firestore
                .collection('Users')
                .doc(_auth.currentUser!.uid)
                .set({
              'name': name,
              'email': email,
              'password': password,
              'photoUrl': photoUrl,
              'uid': _auth.currentUser!.uid,
              'phone': 'غير محدد',
              'bio': 'لاتوجد سيرة ذاتية',
              'dateBirth': 'غير محدد',
              'sex': 'غير محدد',
              'DateToJoin': DateTime.now(),
              'Addrasse': 'غير محدد',
              "geopoint": const GeoPoint(0, 0)
            });
            res = 'success';
          } else {
            res = "الايميل موجود مسبقا";
          }
        } catch (error) {
          res = "الايميل موجود مسبقا  ";
        }
      }
    } else {
      res = 'حدث مشكل ،حاول مرة أخرى';
    }
    return res;
  }

  Future<String> login(
    String email,
    String password,
  ) async {
    String res = 'خطاء حاول مرة أخرى';
    if (email.isEmpty) {
      res = 'يرجي إدخال الإيميل ';
    } else if (password.isEmpty) {
      res = 'يرجى إدخال كلمة المرور';
    } else if (!email.contains('@')) {
      res = "البريد الإلكتروني خاطئ";
    } else {
      try {
        var query = await _firestore
            .collection("Users")
            .where("email", isEqualTo: email)
            .get();
        if (query.docs.isNotEmpty) {
          await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          res = 'success';
        } else {
          res = "لا يوجد هذا الحساب";
        }
      } catch (error) {
        res = 'خطاء حاول مرة أخرى';
      }
    }
    return res;
  }

  Future<String> resetPassword(String email) async {
    String res = 'Some error occured';
    if (email.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        res = 'success';
      } catch (error) {
        res = 'User not found';
      }
    } else {
      res = 'enter email';
    }
    return res;
  }

  Future<String> updateinfo(
      String name,
      Uint8List photo,
      String avtar,
      String phone,
      String bio,
      String sex,
      String date,
      String addreass,
      double lat,
      double lang) async {
    String res = 'هناك خطأ';
    if (name.isNotEmpty) {
      if (photo == null) {
        try {
          await _firestore
              .collection('Users')
              .doc(_auth.currentUser!.uid)
              .update({
            'name': name,
            'phone': phone,
            'bio': bio,
            'dateBirth': date,
            'sex': sex,
            'photoUrl': avtar,
            "Addrasse": addreass,
            "geopoint": GeoPoint(lat, lang)
          });
          res = 'success';
        } catch (error) {
          res = "خطاء ";
        }
      } else {
        try {
          String imgUrl = await StorageRes().uploadImageToStorage(
            photo,
          );
          await _firestore
              .collection('Users')
              .doc(_auth.currentUser!.uid)
              .update({
            'name': name,
            'phone': phone,
            'bio': bio,
            'dateBirth': date,
            'sex': sex,
            'photoUrl': imgUrl,
          });
          res = 'success';
        } catch (error) {
          res = "خطأ حاول مرد أخرى";
        }
      }
    } else {
      res = 'حدث مشكل ،حاول مرة أخرى';
    }
    return res;
  }

  Future<String> updateinfowithoutphoto(
      String name,
      String avtar,
      String phone,
      String bio,
      String sex,
      String date,
      String addreass,
      double lat,
      double lang) async {
    String res = 'هناك خطأ';
    if (name.isNotEmpty) {
      try {
        await _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .update({
          'name': name,
          'phone': phone,
          'bio': bio,
          'dateBirth': date,
          'sex': sex,
          'photoUrl': avtar,
          "Addrasse": addreass,
          "geopoint": GeoPoint(lat, lang)
        });
        res = 'success';
      } catch (error) {
        res = "خطأ حاول مرد أخرى";
      }
    } else {
      res = 'حدث مشكل ،حاول مرة أخرى';
    }
    return res;
  }

  Future<String> changepassword(String newpassword, String oldpassword) async {
    var message = "خطاء";
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .update({'password': newpassword});
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _auth.currentUser!.email.toString(),
              password: oldpassword);
      final user = userCredential.user;
      await user
          ?.updatePassword(newpassword)
          .then((value) => message = "نجحت العملية");
    } catch (e) {}
    return message;
  }

  Future<String> updateemail(String email, String password) async {
    var message = "خطاء";
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .update({'email': email});
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _auth.currentUser!.email.toString(), password: password);
      final user = userCredential.user;
      await user?.updateEmail(email).then((value) => message = "نجحت العملية");
    } catch (e) {}
    return message;
  }

  Future<void> signOut() async {
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .update({"isLogin": false});
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> islogine(String id) async {
    bool islogin = true;
    try {
      await _firestore
          .collection('Users')
          .doc(id)
          .get()
          .then((value) => islogin = value.get("isLogin"));
      print(islogin);
    } catch (e) {
      return islogin = false;
    }
    return islogin;
  }

  isloginestart() async {
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .update({"isLogin": true, "lastActivite": DateTime.now()});
    } catch (e) {}
  }

  reviwsverfi(String servId) async {
    try {
      var requet = await _firestore
          .collection("Order")
          .where("idClient ", isEqualTo: _auth.currentUser!.uid)
          .where("servicId", isEqualTo: servId)
          .where("State", isEqualTo: "منتهية")
          .get();
      if (requet.docs.first.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {}
  }

  Future<String> addraiting(
      String idserv, String comment, String reaiting) async {
    String raitin = '';
    try {
      var query = await _firestore
          .collection("Order")
          .where("idClient", isEqualTo: _auth.currentUser!.uid)
          .where('servicId', isEqualTo: idserv)
          .where('State', isEqualTo: 'منتهية')
          .get();
      var query2 = await _firestore
          .collection("Ratings")
          .where("userreviews", isEqualTo: _auth.currentUser!.uid)
          .where('servid', isEqualTo: idserv)
          .get();
      var query3 = await _firestore
          .collection("Order")
          .where("idClient", isEqualTo: _auth.currentUser!.uid)
          .where('servicId', isEqualTo: idserv)
          .get();

      if (query3.docs.isEmpty) {
        raitin = "لم تطلب الخدمة";
      } else {
        if (query.docs.isEmpty) {
          raitin = ' الخدمة لم تنتهي بعد أو متوقفة';
        } else {
          if (query2.docs.isNotEmpty) {
            raitin = 'لقد قمت بتقيم هذه الخدمة';
          } else {
            await _firestore.collection("Ratings").doc().set({
              'userreviews': _auth.currentUser!.uid,
              'servid': idserv,
              'comment': comment,
              'Rating': reaiting
            });
            raitin = 'success';
          }
        }
      }
    } catch (e) {}
    return raitin;
  }

  Future<List<String>> getallthereviwes(String uid) async {
    List<String> listservices = [];
    try {
      await _firestore
          .collection("Services")
          .where("user", isEqualTo: uid)
          .get()
          .then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            listservices.add(docSnapshot.id);
          }
        },
      );
      for (int i = 0; i < listservices.length; i++) {
        print(listservices[i]);
      }
    } catch (e) {}
    return listservices;
  }
}
