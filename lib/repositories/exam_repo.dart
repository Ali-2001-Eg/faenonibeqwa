// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/utils/providers/storage_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:faenonibeqwa/models/exam_model.dart';

class ExamRepo {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  ExamRepo({
    required this.auth,
    required this.firestore,
    required this.ref,
  });

  Future<void> addExamInfoToFirebase({
    required num totalGrade,
    required DateTime deadlineTime,
    required int timeMinutes,
    required File image,
    required BuildContext context,
    required String examTitle,
    required String examDescription,
    required List<Question> question,
  }) async {
    var examId = const Uuid().v1();
    String? questionId;
    String imageUrl = await ref
        .read(firebaseStorageRepoProvider)
        .storeFileToFirebaseStorage(
            'examImageUrl',examId, image);
    ExamModel model = ExamModel(
      id: examId,
      totalGrade: totalGrade.toDouble(),
      deadlineTime: deadlineTime,
      timeMinutes: timeMinutes,
      examImageUrl: imageUrl,
      examTitle: examTitle,
      examDescription: examDescription,
      questions: const [],
    );

    await firestore.collection('exams').doc(examId).set(model.toMap());
    for (var element in question) {
      questionId = const Uuid().v1();
      await firestore
          .collection('exams')
          .doc(examId)
          .collection('questions')
          .doc(questionId)
          .set(element.toMap());

      for (var i = 0; i <= 3; i++) {
        await firestore
            .collection('exams')
            .doc(examId)
            .collection('questions')
            .doc(questionId)
            .collection('asnwers')
            .add(element.answers[i].toMap());
      }
    }
  }
}

var examData = StateProvider<ExamModel?>((ref) => null);
final examRepoProvider = Provider((ref) => ExamRepo(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref));
