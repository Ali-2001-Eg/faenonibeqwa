import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageRepo {
  final FirebaseStorage storage;

  FirebaseStorageRepo(this.storage);

  Future<String> storeFileToFirebaseStorage(String childName, File file) async {
    var fileId = const Uuid().v4();
    Reference ref = storage.ref().child('$childName/$fileId.png');
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
