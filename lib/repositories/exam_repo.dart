// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use

import 'dart:async';
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
      totalGrade: totalGrade.toInt(),
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

  Future<List<Question>> questions(String examId, int timeMinutes) async {
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
  Future<void> storeExamDataToUser(
    String examId,
    String title,
    String description,
    String imageUrl,
    List<Question> questions,
  ) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('examsHistory')
        .doc(examId)
        .set(
            {'title': title, 'description': description, 'imageUrl': imageUrl});
    for (var element in questions) {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('examsHistory')
          .doc(examId)
          .collection('questions')
          .doc(element.body)
          .set({
        'body': element.body,
        'correctAnswer': element.correctAnswerIdentifier,
        'imageUrl': element.questionImage ?? '',
        'selectedAnswer': '',
      });
    }
  }

  Future<void> selectAnswer(
      String examId, String questionId, String selectedAnswer) async {
    // print('tapped2');
    return await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('examsHistory')
        .doc(examId)
        .collection('questions')
        .doc(questionId)
        .update({'selectedAnswer': selectedAnswer});
  }

//to make check on the answer
  Stream<String> getAnswerIdentifier(String examId, String questionId) =>
      firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('examsHistory')
          .doc(examId)
          .collection('questions')
          .doc(questionId)
          .snapshots()
          .map((query) {
        String selectedAnswer = '';
        if (query.data()!.isNotEmpty) {
          selectedAnswer = query.data()!['selectedAnswer'];
        }
        // print('selectedAnswer');
        return selectedAnswer;
      });
  Future<bool> checkUserHasTakenExam(String examId) async {
    var documentData = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('examsHistory')
        .doc(examId)
        .get();
    return documentData.exists;
  }

  Future<void> submitExam({
    required String examId,
    required int examGrade,
  }) async {
    List<bool> correctAnswers = [];
    String correctAnswer = '';
    String selectedAnswer = '';
    double totalGrade = 0;
    int correctAnswersCount = 0;
    var docData = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('examsHistory')
        .doc(examId)
        .collection('questions')
        .get();
    for (var element in docData.docs) {
      if (docData.docs.isNotEmpty) {
        correctAnswer = element['correctAnswer'];
        selectedAnswer = element['selectedAnswer'];
        correctAnswers.add(correctAnswer == selectedAnswer);
        // print('check correct answer $correctAnswers');
        //[true,false,false]
        correctAnswersCount =
            correctAnswers.where((element) => element == true).length;
        // print('corrct answer count $correctAnswersCount');
      }
    }
    totalGrade = (correctAnswersCount / correctAnswers.length) * examGrade;
    // print('total grade $totalGrade');
    //push to firebase
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('examsHistory')
        .doc(examId)
        .update({
      'studentGrade': '$totalGrade/$examGrade',
    });
  }
}

final examRepoProvider = Provider((ref) => ExamRepo(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref));

final currentIndex = StateProvider<int>((ref) => 0);
