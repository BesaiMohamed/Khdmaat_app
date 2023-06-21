import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newprojectflutter/resources/messages/inf_massegs_M.dart';
import 'package:newprojectflutter/views/auth/chat_message.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Auth {
  DocumentReference? rsponce;
  final FirebaseAuth FirebaseA = FirebaseAuth.instance;
  var Instencefirbsefirstor = FirebaseFirestore.instance;

  @override
  Future addMassge(Massegs massegs) async {
    try {
      DocumentReference Masseg =
          Instencefirbsefirstor.collection("Massegs").doc();
      //  DocumentReference  chat=  Instencefirbsefirstor.collection("chat").doc();
      //مزالي كيفاه ينشاء محادثة
      ////نديرها كي يدير طلب تتنشاء محادثة
      ////حليا نديرها مانيال
      massegs.id = Masseg.id;

      await Masseg.set(massegs.tojson());
    } catch (e) {}
  }

  @override
  deletMassge(String? idmasseg) async {
    bool isdelete = false;
    try {
      var delet = Instencefirbsefirstor.collection("Massegs").doc(idmasseg);
      if (delet != null) {
        await delet.delete();
        isdelete = true;
      }
    } catch (e) {}
    return isdelete;
  }

  @override
  Future deleteimagrinfirestore(String? pathe) async {
    try {
      await FirebaseStorage.instance
          .refFromURL(pathe!)
          .delete()
          .catchError((error) => print("+++++++++++++$error"));
      // ignore: empty_catches
    } catch (e) {
      print("non delete imge");
    }
  }
}
