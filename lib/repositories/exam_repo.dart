// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use

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
    String? answerId;
    String imageUrl = await ref
        .read(firebaseStorageRepoProvider)
        .storeFileToFirebaseStorage('examImageUrl', examId, image);
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
        answerId = const Uuid().v4();

        await firestore
            .collection('exams')
            .doc(examId)
            .collection('questions')
            .doc(questionId)
            .collection('answers')
            .doc(answerId)
            .set(element.answers[i].toMap());
      }
    }
  }

  Stream<List<ExamModel>> get exams {
    return firestore.collection('exams').snapshots().map((snapshot) {
      List<ExamModel> examList = [];
      examList.clear();
      for (var item in snapshot.docs) {
        examList.add(ExamModel.fromMap(item.data()));
      }
      return examList;
    });
  }

  Future<List<Question>> questions(String examId) async {
    var quesionData = await firestore
        .collection('exams')
        .doc(examId)
        .collection('questions')
        .get();
    List<Question> questionList = [];
    for (var element in quesionData.docs) {
      if (quesionData.docs.isNotEmpty) {
        questionList.add(Question.fromMap(element.data()));
      }
    }
    return questionList;
  }

  Future<List<Answers>> answers(String examId, String questionId) async {
    var quesionData = await firestore
        .collection('exams')
        .doc(examId)
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .get();
    List<Answers> answersList = [];
    for (var element in quesionData.docs) {
      if (quesionData.docs.isNotEmpty) {
        answersList.add(Answers.fromMap(element.data()));
      }
    }
    return answersList;
  }

  //to pass it to question doc
  Stream<List<String>> questionIds(String examId) => firestore
          .collection('exams')
          .doc(examId)
          .collection('questions')
          .snapshots()
          .map((query) {
        List<String> questionIds = <String>[];
        for (var element in query.docs) {
          if (query.docs.isNotEmpty) {
            questionIds.add(element.id);
          }
        }
        return questionIds;
      });
      
}

final examRepoProvider = Provider((ref) => ExamRepo(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref));



final currentIndex = StateProvider<int>((ref) => 0);

final selectedAnswers= StateProvider<List<String>>((ref) => <String>[]);

final allQuestions = StateProvider<List<Question>>((ref) => <Question>[]);
