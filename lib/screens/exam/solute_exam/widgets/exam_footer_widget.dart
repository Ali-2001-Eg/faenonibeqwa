import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/exam_model.dart';
import '../../../../utils/base/app_helper.dart';
import '../../../../utils/providers/app_providers.dart';
import '../../../../utils/shared/widgets/custom_button.dart';

class ExamFooterWidget extends StatelessWidget {
  final WidgetRef ref;
  final List<Question> snap;
  final String examId;
  final int totalGrade;
  const ExamFooterWidget({
    Key? key,
    required this.ref,
    required this.snap,
    required this.examId,
    required this.totalGrade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: ref.watch(currentIndex.notifier).state > 0
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.center,
      children: [
        CustomButton(
            width: 100,
            onTap: () {
              if (ref.watch(currentIndex.notifier).state <
                  snap.length - 1) {
                if (kDebugMode) {
                  print(ref.watch(currentIndex.notifier).state);
                }
                ref.watch(currentIndex.notifier).state++;
              } else {
                //submit exam
                ref
                    .watch(examControllerProvider)
                    .submitExam(
                      examId: examId,
                      totalGrade: totalGrade,
                    )
                    .then((value) => Navigator.pushNamedAndRemoveUntil(
                        context, MainScreen.routeName, (route) => false))
                    .catchError((err) {
                  AppHelper.customSnackbar(
                      context: context, title: err.toString());
                  return err;
                });
              }
            },
            text: ref.watch(currentIndex.notifier).state < snap.length - 1
                ? 'التالي'
                : 'إنهاء الاختبار'),
        ref.watch(currentIndex.notifier).state > 0
            ? CustomButton(
                width: 100,
                onTap: () {
                  if (ref.watch(currentIndex.notifier).state > 0) {
                    if (kDebugMode) {
                      print(ref.watch(currentIndex.notifier).state);
                    }
                    ref.watch(currentIndex.notifier).state--;
                  } else {
                    AppHelper.customSnackbar(
                        context: context, title: 'أول سؤال');
                  }
                },
                text: 'السابق')
            : const SizedBox.shrink(),
      ],
    );
  }
}
