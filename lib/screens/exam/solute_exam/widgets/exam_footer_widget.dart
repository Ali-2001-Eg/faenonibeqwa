// ignore_for_file: deprecated_member_use

import 'package:faenonibeqwa/controllers/exam_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/exam_model.dart';
import '../../../../repositories/exam_repo.dart';
import '../../../../utils/base/app_helper.dart';
import '../../../../utils/shared/widgets/custom_button.dart';

class ExamFooterWidget extends StatelessWidget {
  final WidgetRef ref;
  final AsyncSnapshot<List<Question>> snap;
  final String examId;
  final int totalGrade;
  const ExamFooterWidget({
    Key? key,
    required this.ref,
    required this.snap,
    required this.examId, required this.totalGrade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButton(
            width: 100,
            onTap: () {
              if (ref.read(currentIndex.state).state < snap.data!.length - 1) {
                if (kDebugMode) {
                  print(ref.read(currentIndex.state).state);
                }
                ref.read(currentIndex.state).state++;
              } else {
                //submit exam
                ref.read(examControllerProvider).correctQuestionCount(
                    questionId: snap.data![ref.read(currentIndex)].body,
                    examId: examId,
                    totalGrade: totalGrade,);
              }
            },
            text: ref.read(currentIndex.state).state < snap.data!.length - 1
                ? 'التالي'
                : 'إنهاء الاختبار'),
        ref.read(currentIndex.state).state > 0
            ? CustomButton(
                width: 100,
                onTap: () {
                  if (ref.read(currentIndex.state).state > 0) {
                    if (kDebugMode) {
                      print(ref.read(currentIndex.state).state);
                    }
                    ref.read(currentIndex.state).state--;
                  } else {
                    AppHelper.customSnackbar(
                        context: context, text: 'أول سؤال');
                  }
                },
                text: 'السابق')
            : const SizedBox.shrink(),
      ],
    );
  }
}
