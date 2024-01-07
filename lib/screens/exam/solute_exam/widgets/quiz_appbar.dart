import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/count_down_widget.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/exam_controller.dart';
import '../../../../utils/base/app_helper.dart';
import '../../../../utils/shared/widgets/big_text.dart';

class QuizAppBar extends StatelessWidget {
  final int timeMinutes;
  final WidgetRef ref;
  final String examId;
  final int totalGrade;
  final String examTitle;
  const QuizAppBar({
    super.key,
    required this.timeMinutes,
    required this.ref,
    required this.examId,
    required this.totalGrade,
    required this.examTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14, left: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CountdownWidget(
                    timeMinutes: timeMinutes,
                    ref: ref,
                    examId: examId,
                    totalGrade: totalGrade),
                const SizedBox(width: 4),
                const Icon(
                  Icons.watch_later_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          BigText(
            text: examTitle,
            color: Colors.white,
          ),
          GestureDetector(
            onTap: () {
              ref
                  .read(examControllerProvider)
                  .submitExam(
                    examId: examId,
                    totalGrade: totalGrade,
                  )
                  .then((value) => Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.routeName, (route) => false))
                  .catchError((err) => AppHelper.customSnackbar(
                      context: context, text: err.toString()));
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.deepOrange,
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
