import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseStorageRepo {
  final FirebaseStorage storage;

  FirebaseStorageRepo(this.storage);

  Future<String> storeFileToFirebaseStorage(
      String childName, File file, String uid) async {
    Reference ref = storage.ref().child(childName).child(uid);
    UploadTask uploadTask = ref.putFile(
      file,
    );
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

final firebaseStorageRepoProvider = Provider(
  (ref) => FirebaseStorageRepo(FirebaseStorage.instance),
);
