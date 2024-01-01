// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/repositories/exam_repo.dart';

import '../models/exam_model.dart';

class ExamController {
  final ProviderRef ref;
  final ExamRepo examRepo;
  ExamController({
    required this.ref,
    required this.examRepo,
  });
  Future<void> addExamInfoToFirebase({
    required num totalGrade,
    required DateTime deadlineTime,
    required int timeMinutes,
    required File image,
    required String examTitle,
    required String examDescription,
    required List<Question> question,
    required BuildContext context,
  }) async {
    ref
        .read(userDataProvider)
        .whenData((value) => examRepo.addExamInfoToFirebase(
              totalGrade: totalGrade,
              deadlineTime: deadlineTime,
              timeMinutes: timeMinutes,
              image: image,
              context: context,
              examTitle: examTitle,
              examDescription: examDescription,
              question: question,
            ));
  }

  Stream<List<String>> questionIds(String examId) =>
      examRepo.questionIds(examId);

  Stream<List<ExamModel>> get exams => examRepo.exams;
  Future<List<Question>> questions(String examId, int timeMinutes) =>
      examRepo.questions(examId, timeMinutes);
  Future<List<Answers>> answers(String examId, String questionId) =>
      examRepo.answers(examId, questionId);
  Future<void> storeExamHistory({
    required String examId,
    required String title,
    required String description,
    required String imageUrl,
    required List<Question> questions,
  }) =>
      examRepo.storeExamDataToUser(
        examId,
        title,
        description,
        imageUrl,
        questions,
      );
  Future<void> selectAnswer({
    required String examId,
    required String questionId,
    required String selectedAnswer,
  }) async =>
      examRepo.selectAnswer(
        examId,
        questionId,
        selectedAnswer,
      );
  Stream<String> getAnswerIdentifier(
          {required String examId, required String questionId}) =>
      examRepo.getAnswerIdentifier(examId, questionId);

  Future<bool> checkUserHasTakenExam({required String examId}) =>
      examRepo.checkUserHasTakenExam(examId);

  Future<void> correctQuestionCount({
    required String questionId,
    required String examId,
    required int totalGrade,
  }) =>
      examRepo.submitExam(
        questionId: questionId,
        examId: examId,
        examGrade: totalGrade,
      );
}

final examControllerProvider = Provider((ref) {
  final examRepo = ref.read(examRepoProvider);
  return ExamController(ref: ref, examRepo: examRepo);
});
