
import 'package:faenonibeqwa/utils/typedefs/app_typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/repositories/exam_repo.dart';

import '../models/exam_history.dart';
import '../models/exam_model.dart';
import '../utils/providers/app_providers.dart';

class ExamController {
  final ProviderRef ref;
  final ExamRepo examRepo;
  ExamController({
    required this.ref,
    required this.examRepo,
  });

  get totalExams => null;
  Future<void> addExamInfoToFirebase({
    required num totalGrade,
    // required DateTime deadlineTime,
    required int timeMinutes,
    // required File image,
    required String examTitle,
    required String examDescription,
    required List<Question> question,
    required BuildContext context,
  }) async {
     examRepo.addExamInfoToFirebase(
              totalGrade: totalGrade,
              // deadlineTime: deadlineTime,
              timeMinutes: timeMinutes,
              // image: image,
              context: context,
              examTitle: examTitle,
              examDescription: examDescription,
              question: question,
            );
  }

  Stream<List<String>> questionIds(String examId) async* {
    yield* examRepo.questionIds(examId);
  }

  Stream<List<ExamModel>> get exams => examRepo.exams;
//questionParameters is tuple
  Future<List<Question>> questions(String examId) =>
      examRepo.questions(examId);

  Future<List<Answers>> answers(AnswersParameters answersParameters) =>
      examRepo.answers(answersParameters.item1, answersParameters.item2);
  Future<void> storeExamDataToUser({
    required String examId,
    required String title,
    required String description,
    // required String imageUrl,
  }) =>
      examRepo.storeExamDataToUser(
        examId,
        title,
        description,
        // imageUrl,
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
  Stream<String> getAnswerIdentifier(AnswersIdentiferParameters parameters) =>
      examRepo.getAnswerIdentifier(parameters.item1, parameters.item2);

  Future<bool> checkUserHasTakenExam({required String examId}) =>
      examRepo.checkUserHasTakenExam(examId);

  Future<void> submitExam({
    required String examId,
    required int totalGrade,
  }) =>
      examRepo.submitExam(
        examId: examId,
        examGrade: totalGrade,
      );
  Stream<List<ExamHistoryModel>> get examsHistory => examRepo.examsHistory;
}
