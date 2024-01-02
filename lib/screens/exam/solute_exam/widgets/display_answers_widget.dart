// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../controllers/exam_controller.dart';
import '../../../../models/exam_model.dart';
import '../../../../repositories/exam_repo.dart';
import '../../../../utils/shared/widgets/big_text.dart';
import '../../../../utils/shared/widgets/custom_indicator.dart';
import 'answer_card.dart';

import 'shimmer_widget.dart';

class DisplayAnswersWidget extends ConsumerWidget {
  final Question question;
  final String examId;
  const DisplayAnswersWidget({
    super.key,
    required this.question,
    required this.examId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<String>>(
      stream: ref.read(examControllerProvider).questionIds(examId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: BigText(
            text: snapshot.error.toString(),
            textAlign: TextAlign.center,
            color: Colors.red,
          ));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomIndicator());
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return FutureBuilder<List<Answers>>(
            future: ref
                .read(examControllerProvider)
                .answers(examId, snapshot.data![ref.watch(currentIndex)]),
            builder: (_, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return StatefulBuilder(builder: (context, setState) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (_, i) =>
                        Padding(padding: EdgeInsets.all(5.w)),
                    itemBuilder: (_, i) {
                      var answer = snapshot.data![i];
                      return Consumer(builder: (context, ref, child) {
                        return InkWell(
                          onTap: () {
                            ref.read(examControllerProvider).selectAnswer(
                                examId: examId,
                                questionId: question.body,
                                selectedAnswer: answer.identifier);
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
                });
              }
              //shimmer effect
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerWidget();
              }

              return Center(
                child: Container(),
              );
            },
          );
        }
        return const Center(
          child: BigText(
            text: 'لا يوجد اجابات',
            fontSize: 28,
          ),
        );
      },
    );
  }
}

