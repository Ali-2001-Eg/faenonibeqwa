// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/typedefs/app_typedefs.dart';

import '../../../../models/exam_model.dart';
import '../../../../utils/providers/app_providers.dart';
import '../../../../utils/shared/widgets/big_text.dart';
import 'answer_card.dart';
import 'shimmer_widget.dart';

class DisplayAnswersWidget extends ConsumerWidget {
  final Question question;
  final List<Question> questions;
  final String examId;
  final String examTitle;
  final String examImageUrl;
  final String examDesc;
  const DisplayAnswersWidget({
    required this.question,
    required this.questions,
    required this.examId,
    required this.examTitle,
    required this.examImageUrl,
    required this.examDesc,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('examId is $examId');
    //stream provider
    return ref.watch(questionIdsStream(examId)).when(data: (data) {
      print("================");
      print(data);
      print("================");

      if (data.isEmpty) {
        return const Center(
          child: BigText(
            text: 'لا يوجد اجابات',
            fontSize: 28,
          ),
        );
      }
      return ref
          .watch(answersProvider(
              AnswersParameters(examId, data[ref.watch(currentIndex)])))
          .when(data: (data) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: data.length,
          separatorBuilder: (_, i) => Padding(padding: EdgeInsets.all(5.w)),
          itemBuilder: (_, i) {
            var answer = data[i];
            print(answer.answer);
            return Consumer(builder: (context, ref, child) {
              return InkWell(
                onTap: () {
                  _storeExamData(ref, questions, examId).then((value) {
                    ref.watch(examControllerProvider).selectAnswer(
                        examId: examId,
                        questionId: question.body,
                        selectedAnswer: answer.identifier);
                  });
                },
                child: AnswerCard(
                  answer: answer,
                  examId: examId,
                  questionBody: question.body,
                ),
              );
            });
          },
        );
      }, error: (error, _) {
        AppHelper.customSnackbar(context: context, title: error.toString());
        return BigText(text: error.toString());
      }, loading: () {
        return const ShimmerWidget();
      });
    }, error: (error, _) {
      return Center(
          child: BigText(
        text: error.toString(),
        textAlign: TextAlign.center,
        color: Colors.red,
      ));
    }, loading: () {
      return const ShimmerWidget();
    });
  }

  Future<void> _storeExamData(
      WidgetRef ref, List<Question> snap, String examId) async {
    if (!await ref
        .read(examControllerProvider)
        .checkUserHasTakenExam(examId: examId)) {
      ref.read(examControllerProvider).storeExamHistory(
            examId: examId,
            title: examTitle,
            description: examDesc,
            imageUrl: examImageUrl,
            questions: snap,
          );
    }
  }
}
