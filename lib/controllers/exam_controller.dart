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

  
}

final examControllerProvider = Provider((ref) {
  final examRepo = ref.read(examRepoProvider);
  return ExamController(ref: ref, examRepo: examRepo);
});
