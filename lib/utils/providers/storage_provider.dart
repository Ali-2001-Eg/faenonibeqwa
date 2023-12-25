import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: unused_import
import 'package:uuid/uuid.dart';

class FirebaseStorageRepo {
  final FirebaseStorage storage;

  FirebaseStorageRepo(this.storage);

  Future<String> storeFileToFirebaseStorage(
    String childName,
    String fileName,
    File file,
  ) async {
    Reference ref = storage.ref().child('$childName/$fileName');
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
