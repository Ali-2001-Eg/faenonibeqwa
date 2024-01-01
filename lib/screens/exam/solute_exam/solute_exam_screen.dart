// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/count_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:faenonibeqwa/controllers/exam_controller.dart';
import 'package:faenonibeqwa/repositories/exam_repo.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/display_answers_widget.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';

import '../../../models/exam_model.dart';
import '../../../utils/shared/widgets/big_text.dart';
import '../../../utils/shared/widgets/custom_indicator.dart';
import 'widgets/display_body_widget.dart';
import 'widgets/display_image_widget.dart';
import 'widgets/exam_footer_widget.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: CountdownWidget(
                  timeMinutes: exam.timeMinutes,
                )),
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

                    return Container(
                      // height: context.screenHeight,
                      width: context.screenWidth - 50,
                      margin: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Colors.redAccent,
                              Colors.blueAccent,
                              Colors.greenAccent,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BigText(
                              text: (ref.read(currentIndex.state).state + 1)
                                  .toString()),

                          question.questionImage != null
                              ? Center(
                                  child: DisplayQuestionImageWidget(
                                      imageUrl: question.questionImage!))
                              : const SizedBox.shrink(),
                          DisplayQuestionBodyWidget(question: question),
                          //answers
                          DisplayAnswersWidget(
                              question: question, examId: exam.id),
                          ExamFooterWidget(
                            snap: snap,
                            ref: ref,
                            examId: exam.id,
                            totalGrade: exam.totalGrade,
                          )
                        ],
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
