// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';

import '../../../models/exam_model.dart';
import '../../../utils/shared/widgets/big_text.dart';

import 'widgets/page_view_widget.dart';
import 'widgets/sammary_exam_component_widget.dart';
import 'widgets/summary_image_widget.dart';

class ExamSammaryScreen extends StatelessWidget {
  final VoidCallback? onPreviousPressed;
  final VoidCallback onSubmitted;
  final ExamModel exam;
  const ExamSammaryScreen({
    Key? key,
   this.onPreviousPressed,
    required this.onSubmitted,
    required this.exam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.hSpace,
            const Center(child: BigText(text: 'ملخص الاختبار')),
            30.hSpace,
            // SammaryImageWidget(imageUrl: exam.examImageUrl, fromNetwork: false),
            30.hSpace,
            SummaryExamComponentWidget(
              data: exam.examTitle,
              headTitle: "عنوان الاختبار",
            ),
            30.hSpace,
            SummaryExamComponentWidget(
              data: exam.examDescription,
              headTitle: "وصف الاختبار",
            ),
            30.hSpace,
            SummaryExamComponentWidget(
              data: exam.totalGrade.toString(),
              headTitle: "الدرجه النهائيه",
            ),
            // 30.hSpace,
            // SummaryExamComponentWidget(
            //   data: timeago.format(exam.deadlineTime),
            //   headTitle: "الموعد النهائي",
            // ),
            30.hSpace,
            SummaryExamComponentWidget(
              data: exam.timeMinutes.toString(),
              headTitle: "مده الاختبار",
            ),
            30.hSpace,
            ListView.separated(
              itemCount: exam.questions.length,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, i) => Padding(
                padding: EdgeInsets.all(10.w),
                child: const Divider(),
              ),
              shrinkWrap: true,
              itemBuilder: (_, i) {
                var question = exam.questions[i];
                return Column(
                  children: [
                    SummaryExamComponentWidget(
                      headTitle: 'عنوان السؤال ${i + 1}',
                      data: question.body,
                    ),
                    20.hSpace,
                    if (question.questionImage != null)
                      SammaryImageWidget(
                          imageUrl: question.questionImage!, fromNetwork: true),
                    if (question.questionImage == null)
                      const Align(
                        alignment: Alignment.topRight,
                        child: SmallText(
                          text: 'لا يوجد صوره مرفقه بالسؤال',
                        ),
                      ),
                    10.hSpace,
                    ListView.separated(
                      itemCount: question.answers.length,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, i) => Padding(
                        padding: EdgeInsets.all(5.w),
                        child: Container(),
                      ),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        var answer = question.answers[index];
                        return SummaryExamComponentWidget(
                            headTitle: answer.identifier,
                            data: answer.answer,
                            isCorrectAnswer: question.correctAnswerIdentifier ==
                                (index + 1).toString());
                      },
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
      onPreviousPressed: onPreviousPressed,
      onSubmitted: onSubmitted,
    );
  }
}
