import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;

class bookmark {
  Future<void> addbookmark() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("BookMark")
          .doc(globals.uidServ)
          .get();
      if (userheart.exists == false) {
        await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection("BookMark")
            .doc(globals.uidServ)
            .set({'servid': globals.uidServ});
      }
    } catch (e) {}
  }

  Future<void> addbookmarkfrommylist(String Servid) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("BookMark")
          .doc(Servid)
          .get();
      if (userheart.exists == false) {
        await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection("BookMark")
            .doc(Servid)
            .set({'servid': globals.uidServ});
      }
    } catch (e) {}
  }

  Future<void> delatebookmark() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("BookMark")
          .doc(globals.uidServ)
          .get();
      if (userheart.exists == true) {
        await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection("BookMark")
            .doc(globals.uidServ)
            .delete();
      }
    } catch (e) {}
  }

  Future<void> delatebookmarkfrommylist(String Servid) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("BookMark")
          .doc(Servid)
          .get();
      if (userheart.exists == true) {
        await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection("BookMark")
            .doc(Servid)
            .delete();
      }
    } catch (e) {}
  }

  verfibookmark(String uid) async {
    bool ifexist = false;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentSnapshot userheart;
    try {
      userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("BookMark")
          .doc(uid)
          .get();
      ifexist = userheart.exists;
    } catch (e) {}
    globals.verfiebookmark = ifexist;
  }
}
