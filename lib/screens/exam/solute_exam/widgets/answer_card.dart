// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:faenonibeqwa/utils/typedefs/app_typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/exam_model.dart';
import '../../../../utils/providers/app_providers.dart';
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
    return ref
        .watch(answerCardStream(AnswersParameters(examId, questionBody)))
        .when(data: (data) {
          print('ali');
      return AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              width: data == answer.identifier ? 1.5 : 0.5,
              color: data == answer.identifier ? Colors.green : Colors.black),
        ),
        child: Row(
          children: [
            BigText(
              text: answer.answer,
              fontSize: 18,
            ),
            const Spacer(),
            if (data == answer.identifier)
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  size: 25,
                  color: Colors.white,
                ),
              )
            else
              const SizedBox.shrink()
          ],
        ),
      );
    }, error: (error, _) {
      return BigText(
        text: error.toString(),
        color: Colors.red,
        textAlign: TextAlign.center,
      );
    }, loading: () {
      return Container();
    });
  }
}
