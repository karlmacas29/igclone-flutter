import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //add image

  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file,
    bool isPost,
  ) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadURL = await snap.ref.getDownloadURL();

    return downloadURL;
  }

  Future<String> updateImageToStorage(
    String childName,
    String oldUrl,
    Uint8List? file,
    bool isPost,
  ) async {
    //delete the old image first
    await deleteImageFromStorage(oldUrl);

    //upload the new image
    return await uploadImageToStorage(childName, file!, isPost);
  }

  //delete image

  Future<void> deleteImageFromStorage(String url) async {
    //get the reference of the image from the url
    Reference ref = _storage.refFromURL(url);

    //delete the image
    await ref.delete();
  }
}
