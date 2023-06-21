import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class StorageRes {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  //باه نطلع الفوطو في الفاير ستور

  Future<String> uploadImageToStorage(
    Uint8List imagefile,
  ) async {
    // حجز مكان في الفاير ستور
    final String imageName = const Uuid().v1();

    Reference ref =
        _firebaseStorage.ref().child('projects thumb').child(imageName);

    UploadTask uploadTask = ref.putData(imagefile);

    TaskSnapshot snapshot = await uploadTask;
    //رابط الصورة
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
