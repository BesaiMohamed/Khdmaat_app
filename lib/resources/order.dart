import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  creatorder(String idClient, String idWorker, String idServ) async {
    String state = "معلق";
    try {
      var query1 = await _firestore
          .collection("Massegs")
          .where("idusersender", isEqualTo: idWorker)
          .where("idUser", isEqualTo: idClient)
          .get();
      var query2 = await _firestore
          .collection("Massegs")
          .where("idusersender", isEqualTo: idClient)
          .where("idUser", isEqualTo: idWorker)
          .get();
      var query3 = await _firestore
          .collection("Cheat")
          .where("idUser", isEqualTo: _auth.currentUser!.uid)
          .where('idusersender', isEqualTo: idWorker)
          .get();
      var query4 = await _firestore
          .collection("Order")
          .where("idClient", isEqualTo: _auth.currentUser!.uid)
          .where('idworker', isEqualTo: idWorker)
          .where('servicId ', isEqualTo: idServ)
          .get();
      if (query3.docs.isNotEmpty || query4.docs.isEmpty) {
        DocumentReference ref = _firestore.collection("Order").doc();
        await ref.set({
          "id": ref.id,
          "State": state,
          "idClient": idClient,
          "idworker": idWorker,
          "servicId": idServ
        });
      } else {
        if (query1.docs.isEmpty && query2.docs.isEmpty ||
            query3.docs.isEmpty ||
            query4.docs.isEmpty) {
          DocumentReference ref = _firestore.collection("Order").doc();
          await ref.set({
            "id": ref.id,
            "State": state,
            "idClient": idClient,
            "idworker": idWorker,
            "servicId": idServ
          });
          DocumentReference ref2 = _firestore.collection("cheat").doc();

          await _firestore.collection("Cheat").doc().set(
              {"id": ref2.id, "idUser": idClient, "idusersender": idWorker});
        }
      }
    } catch (e) {}
  }

  Future<String> stateorder(String servId) async {
    String res = '';
    try {
      var requet = await _firestore
          .collection("Order")
          .where("idworker", isEqualTo: _auth.currentUser!.uid)
          .where("servicId", isEqualTo: servId)
          .get();
      res = requet.docs.first.get("State");
    } catch (e) {}
    return res;
  }

  updatestate(String servId, String state) async {
    try {
      var requet = await _firestore
          .collection("Order")
          .where("idworker", isEqualTo: _auth.currentUser!.uid)
          .where("servicId", isEqualTo: servId)
          .get();
      String snapshot = requet.docs.first.get("id");
      print(snapshot);
      await _firestore
          .collection("Order")
          .doc(snapshot)
          .update({"State": state});
    } catch (e) {}
  }
}
