// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../controllers/exam_controller.dart';
import '../../../../models/exam_model.dart';
import '../../../../utils/shared/widgets/big_text.dart';

class AnswerCard extends ConsumerWidget {
  const AnswerCard({
    Key? key,
    required this.answer,
    required this.examId,
    required this.questionBody,
  }) : super(key: key);

  final Answers answer;
  final String examId;
  final String questionBody;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<String>(
        stream: ref
            .read(examControllerProvider)
            .getAnswerIdentifier(examId: examId, questionId: questionBody),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return BigText(text: snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return Container(
            padding: EdgeInsets.all(15.w),
            margin: EdgeInsets.all(10.w),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
              color: snapshot.data! == answer.identifier
                  ? Colors.red
                  : Colors.white,
            ),
            child: BigText(
              text: answer.answer,
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
