// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:faenonibeqwa/controllers/exam_controller.dart';
import 'package:faenonibeqwa/repositories/exam_repo.dart';
import 'package:faenonibeqwa/screens/exam/widgets/display_answers_widget.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/exam_model.dart';
import '../../../utils/shared/widgets/big_text.dart';
import '../../../utils/shared/widgets/custom_indicator.dart';
import '../widgets/answer_card.dart';

class SoluteExamScreen extends StatelessWidget {
  final ExamModel exam;
  const SoluteExamScreen({
    Key? key,
    required this.exam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: exam.examTitle),
      body: Consumer(builder: (context, ref, child) {
        return FutureBuilder<List<Question>>(
          future: ref.read(examControllerProvider).quesions(exam.id),
          builder: (_, snap) {
            if (snap.hasError) {
              return Center(
                  child: BigText(
                text: snap.error.toString(),
                textAlign: TextAlign.center,
                color: Colors.red,
              ));
            }
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CustomIndicator());
            }
            if (snap.hasData && snap.data!.isNotEmpty) {
              var question = ref.watch(allQuestions).length != snap.data!.length
                  ? snap.data![ref.watch(currentIndex)]
                  : ref.watch(allQuestions)[ref.watch(currentIndex)];

              return Expanded(
                child: Container(
                  // height: context.screenHeight,
                  width: context.screenWidth - 50,
                  margin: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Colors.redAccent,
                      Colors.blueAccent,
                      Colors.greenAccent,
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BigText(
                          text: (ref.read(currentIndex.state).state + 1)
                              .toString()),
                      if (question.questionImage != null)
                        Center(
                            child: DisplayQuestionImageWidget(
                                imageUrl: question.questionImage!)),
                      DisplayQuestionBodyWidget(question: question),
                      //answers
                      StreamBuilder<List<String>>(
                        stream: ref
                            .read(examControllerProvider)
                            .questionIds(exam.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: BigText(
                              text: snapshot.error.toString(),
                              textAlign: TextAlign.center,
                              color: Colors.red,
                            ));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CustomIndicator());
                          }
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return FutureBuilder<List<Answers>>(
                              future: ref.read(examControllerProvider).answers(
                                  exam.id,
                                  snapshot.data![ref.watch(currentIndex)]),
                              builder: (_, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      separatorBuilder: (_, i) =>
                                          Padding(padding: EdgeInsets.all(5.w)),
                                      itemBuilder: (_, i) {
                                        var answer = snapshot.data![i];
                                        return Consumer(
                                            builder: (context, ref, child) {
                                          List<String> selectedAnswer = ref
                                              .watch(selectedAnswers.state)
                                              .state;

                                          return InkWell(
                                            onTap: () {
                                              // Make sure to use the correct context to read the provider

                                              // Update the selected answer identifier
                                              if (selectedAnswer.isNotEmpty &&
                                                  ref.watch(currentIndex) <
                                                      selectedAnswer.length) {
                                                // if user update the answer identifier
                                                selectedAnswer.removeAt(
                                                    ref.watch(currentIndex));
                                                ref.read(allQuestions).removeAt(
                                                    ref.watch(currentIndex));
                                              }
                                              ref.read(allQuestions).insert(
                                                  ref.read(currentIndex),
                                                  question);
                                              selectedAnswer.insert(
                                                  ref.watch(currentIndex),
                                                  answer.identifier);

                                              // Update the selected answer identifier in the question object
                                              setState(() {
                                                question.selectedAnswerIdentifier =
                                                    answer.identifier;
                                              });
                                              print(question
                                                  .selectedAnswerIdentifier);
                                              print(
                                                  'test ${question.selectedAnswerIdentifier}');
                                            },
                                            child: AnswerCard(
                                              answer: answer,
                                              color:
                                                  question.selectedAnswerIdentifier ==
                                                          answer.identifier
                                                      ? Colors.red
                                                      : null,
                                            ),
                                          );
                                        });
                                      },
                                    );
                                  });
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                              width: 100,
                              onTap: () {
                                if (ref.read(currentIndex.state).state <
                                    snap.data!.length - 1) {
                                  if (kDebugMode) {
                                    print(ref.read(currentIndex.state).state);
                                  }
                                  ref.read(currentIndex.state).state++;
                                } else {
                                  AppHelper.customSnackbar(
                                      context: context, text: 'آخر سؤال');
                                }
                              },
                              text: 'التالي'),
                          CustomButton(
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
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: BigText(
                text: 'لا يوجد اسئله',
                fontSize: 28,
              ),
            );
          },
        );
      }),
    );
  }
}

class DisplayQuestionBodyWidget extends StatelessWidget {
  const DisplayQuestionBodyWidget({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: BigText(
        text: question.body,
        fontSize: 30,
        color: Colors.white,
      ),
    );
  }
}

class DisplayQuestionImageWidget extends StatelessWidget {
  const DisplayQuestionImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      height: context.screenWidth * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(imageUrl, fit: BoxFit.fill),
        ),
      ),
    );
  }
}

List i = [1];
//index = 1