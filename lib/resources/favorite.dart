import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;

class favorite {
  Future<void> addheart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("favoritehearts")
          .doc(globals.uidServ)
          .get();
      if (userheart.exists == false) {
        await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection("favoritehearts")
            .doc(globals.uidServ)
            .set({'servid': globals.uidServ});
      }
    } catch (e) {}
  }

  Future<void> addheartfrommylist(String Servid) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("favoritehearts")
          .doc(Servid)
          .get();
      if (userheart.exists == false) {
        await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection("favoritehearts")
            .doc(globals.uidServ)
            .set({'servid': Servid});
      }
    } catch (e) {}
  }

  Future<void> delateheart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("favoritehearts")
          .doc(globals.uidServ)
          .get();
      if (userheart.exists == true) {
        await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection("favoritehearts")
            .doc(globals.uidServ)
            .delete();
      }
    } catch (e) {}
  }

  Future<void> delateheartfrommylist(String Servid) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("favoritehearts")
          .doc(Servid)
          .get();
      if (userheart.exists == true) {
        await _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .collection("favoritehearts")
            .doc(Servid)
            .delete();
      }
    } catch (e) {}
  }

  verfieheart(String uid) async {
    bool ifexist = false;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentSnapshot userheart;
    try {
      userheart = await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("favoritehearts")
          .doc(uid)
          .get();
      ifexist = userheart.exists;
    } catch (e) {}
    globals.verfieheart = ifexist;
  }

  heartContdes(int Count) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore
          .collection("Services")
          .doc(globals.uidServ)
          .update({"Count": Count - 1});
    } catch (e) {}
  }

  heartContaes(int Count) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore
          .collection("Services")
          .doc(globals.uidServ)
          .update({"Count": Count + 1});
    } catch (e) {}
  }
}
