import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/resources/storage_res.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;

class ProjectRes {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var Instencefirbsefirstor = FirebaseFirestore.instance;
  DocumentReference? rsponce;
  Future<String> AddProject(
    String title,
    String description,
    String type,
    Uint8List imagefile,
    String useruid,
  ) async {
    String res = 'حدث مشكل،حاول مرة أخرى';
    try {
      if (title.isEmpty || description.isEmpty || type.isEmpty) {
        res = "معلومات الخدمة غير كافية ";
      } else {
        var query = await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .get();
        if (query.data()!['Addrasse'] != "" &&
            query.data()!['typeOfservies'] != "" &&
            query.data()!['phone'] != "") {
          String imgUrl = await StorageRes().uploadImageToStorage(
            imagefile,
          );

          rsponce = FirebaseFirestore.instance.collection('Services').doc();
          rsponce!.set({
            'serviceuid': rsponce!.id,
            'title': title,
            'description': description,
            'createDate': DateTime.now(),
            'imgUrl': imgUrl,
            'Raitin': 0,
            'Count': 0,
            'catogry': type,
            'user': useruid,
          });
          res = 'success';
        } else {
          res = 'يرجي إكمال معلومات ملفك شخصي أولاً';
        }
      }
    } catch (e) {}
    return res;
  }

  calcuelStars(String servId) async {
    double raitin = 0;
    try {
      var query = await FirebaseFirestore.instance
          .collection('Ratings')
          .where("servid", isEqualTo: servId)
          .get();
      if (query.docs.isNotEmpty) {
        for (int i = 0; i < query.docs.length; i++) {
          raitin = double.parse(query.docs[i].get("Rating"));
        }
        globals.raitinserv = raitin / query.docs.length;
      } else {
        globals.raitinserv = 0.0;
      }
    } catch (e) {}
  }

  getAvatr(String iduserInserv) async {
    DocumentSnapshot data;
    try {
      data = await _firestore.collection("Users").doc(iduserInserv).get();
      globals.userAvatr = data.get('photoUrl');
      globals.userName = data.get('name');
      globals.phoneWorker = data.get('phone');
      globals.iduserProfile = iduserInserv;
    } catch (e) {}
  }

  getInformation(String uidServ) async {
    DocumentSnapshot data, data2;
    try {
      data = await _firestore.collection("Services").doc(uidServ).get();
      getAvatr(data.get('user'));
    } catch (e) {}
  }

  deleteservic(String servid) async {
    await _firestore.collection("Services").doc(servid).delete();
  }

  Future<String> updateProject(
    String idServ,
    String title,
    String description,
    String type,
    Uint8List imagefile,
  ) async {
    String res = 'حدث مشكل،حاول مرة أخرى';
    try {
      if (title.isEmpty || description.isEmpty || type.isEmpty) {
        res = "معلومات الخدمة غير كافية ";
      } else {
        var query = await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .get();
        if (query.data()!['Addrasse'] != "" &&
            query.data()!['typeOfservies'] != "" &&
            query.data()!['phone'] != "") {
          String imgUrl = await StorageRes().uploadImageToStorage(
            imagefile,
          );

          rsponce =
              FirebaseFirestore.instance.collection('Services').doc(idServ);
          rsponce!.update({
            'title': title,
            'description': description,
            'imgUrl': imgUrl,
            'catogry': type,
          });
          res = 'success';
        } else {
          res = 'يرجي إكمال معلومات ملفك شخصي أولاً';
        }
      }
    } catch (e) {}
    return res;
  }

  Future<String> updateProjectwithoutimg(
    String idServ,
    String title,
    String description,
    String type,
  ) async {
    String res = 'حدث مشكل،حاول مرة أخرى';
    try {
      if (title.isEmpty || description.isEmpty || type.isEmpty) {
        res = "معلومات الخدمة غير كافية ";
      } else {
        var query = await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .get();
        if (query.data()!['Addrasse'] != "" &&
            query.data()!['typeOfservies'] != "" &&
            query.data()!['phone'] != "") {
          rsponce =
              FirebaseFirestore.instance.collection('Services').doc(idServ);
          rsponce!.update({
            'title': title,
            'description': description,
            'catogry': type,
          });
          res = 'success';
        } else {
          res = 'يرجي إكمال معلومات ملفك شخصي أولاً';
        }
      }
    } catch (e) {}
    return res;
  }
}
