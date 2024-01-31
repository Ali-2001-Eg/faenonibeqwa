import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/models/paper_model.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaperRepo {
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  PaperRepo({required this.firestore, required this.ref});
  //upload files
  Future<void> uploadPaper(String title, String filePath) async {
    final int fileNameIndex = filePath.lastIndexOf('/') + 1;
    final String fileName = filePath.substring(fileNameIndex);
    final String fileUrl = await ref
        .read(firebaseStorageRepoProvider)
        .storeFileToFirebaseStorage('papers', fileName, File(filePath));
    PaperModel paper = PaperModel(title: title, filePath: fileUrl);
    await firestore.collection('papers').doc(title).set(paper.toMap());
  }

  //get file
  Stream<List<PaperModel>> get papers =>
      firestore.collection('papers').snapshots().map((query) {
        final List<PaperModel> papers = [];
        for (var paper in query.docs) {
          if (paper.data().isNotEmpty) {
            papers.add(PaperModel.fromMap(paper.data()));
          }
        }
        return papers;
      });
}
