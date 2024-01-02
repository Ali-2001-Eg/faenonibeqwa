// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/question_details.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/controllers/exam_controller.dart';
import 'package:faenonibeqwa/repositories/exam_repo.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/display_answers_widget.dart';

import '../../../models/exam_model.dart';
import '../../../utils/shared/widgets/big_text.dart';
import '../../../utils/shared/widgets/custom_indicator.dart';
import 'widgets/exam_footer_widget.dart';
import 'widgets/quiz_appbar.dart';

class SoluteExamScreen extends ConsumerWidget {
  final ExamModel exam;
  const SoluteExamScreen({
    Key? key,
    required this.exam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff004840),
        // appBar: CustomAppBar(title: exam.examTitle),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              QuizAppBar(
                timeMinutes: exam.timeMinutes,
                ref: ref,
                examId: exam.id,
                totalGrade: exam.totalGrade,
                examTitle: exam.examTitle,
              ),
              40.hSpace,
              Consumer(builder: (context, ref, child) {
                return FutureBuilder<List<Question>>(
                  future: ref
                      .read(examControllerProvider)
                      .questions(exam.id, exam.timeMinutes),
                  builder: (_, AsyncSnapshot<List<Question>> snap) {
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
                      _storeExamData(ref, snap, exam.id);
                      //initial
                      late Question question;
                      question = snap.data![ref.watch(currentIndex)];

                      return Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              30.hSpace,

                              QuestionDetails(
                                questionBody: question.body,
                                questionImage: question.questionImage,
                                ref: ref,
                              ),
                              30.hSpace,
                              DisplayAnswersWidget(
                                  examId: exam.id, question: question),
                              30.hSpace,

                              //footer
                              ExamFooterWidget(
                                ref: ref,
                                snap: snap,
                                examId: exam.id,
                                totalGrade: exam.totalGrade,
                              ),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _storeExamData(
      WidgetRef ref, AsyncSnapshot<List<Question>> snap, String examId) async {
    if (!await ref
        .read(examControllerProvider)
        .checkUserHasTakenExam(examId: examId)) {
      ref.read(examControllerProvider).storeExamHistory(
            examId: exam.id,
            title: exam.examTitle,
            description: exam.examDescription,
            imageUrl: exam.examImageUrl,
            questions: snap.data!,
          );
    }
  }
}
