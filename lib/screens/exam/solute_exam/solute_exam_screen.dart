// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/question_details.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/typedefs/app_typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/display_answers_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/exam_model.dart';
import '../../../utils/base/app_helper.dart';
import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/big_text.dart';
import '../../home/main_sceen.dart';
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
        body: WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const BigText(
                        text:
                            'بعد مغادرتك للاختبار لن تتمكن من الدخول مره اخري'),
                    actions: [
                      CustomButton(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          backgroundColor: Colors.green,
                          text: 'الاستكمال'),
                      CustomButton(
                          onTap: () async {
                            Navigator.of(context).pop();
                            await ref
                                .watch(examControllerProvider)
                                .submitExam(
                                  examId: exam.id,
                                  totalGrade: exam.totalGrade,
                                )
                                .then((value) {
                              return Navigator.pushNamedAndRemoveUntil(context,
                                  MainScreen.routeName, (route) => false);
                            }).catchError((err) {
                              AppHelper.customSnackbar(
                                  context: context, title: err.toString());
                              return err;
                            });
                          },
                          backgroundColor: Colors.red,
                          text: 'تأكيد الخروج'),
                    ],
                  );
                });
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuizAppBar(
                    timeMinutes: exam.timeMinutes,
                    ref: ref,
                    examId: exam.id,
                    totalGrade: exam.totalGrade,
                    examTitle: exam.examTitle,
                  ),
                  40.hSpace,
                  ref
                      .watch(questionsProvider(
                          QuestionParameters(exam.id, exam.timeMinutes)))
                      .when(data: (data) {
                    _storeExamData(ref, data, exam.id);
                    //initial
                    late Question question;
                    question = data[ref.watch(currentIndex)];

                    return SingleChildScrollView(
                      child: Container(
                        height: context.screenHeight * 0.84,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // 30.hSpace,

                            QuestionDetails(
                              questionBody: question.body,
                              questionImage: question.questionImage,
                              ref: ref,
                            ),
                            30.hSpace,
                            Expanded(
                              child: DisplayAnswersWidget(
                                examId: exam.id,
                                examDesc: exam.examDescription,
                                examImageUrl: exam.examImageUrl,
                                examTitle: exam.examTitle,
                                question: question,
                                questions: data,
                              ),
                            ),
                            // 30.hSpace,

                            //footer
                            ExamFooterWidget(
                              ref: ref,
                              snap: data,
                              examId: exam.id,
                              totalGrade: exam.totalGrade,
                            ),
                            // const BannerWidget(),
                          ],
                        ),
                      ),
                    );
                  }, error: (err, stackTrace) {
                    AppHelper.customSnackbar(
                        context: context, title: err.toString());
                    return Container();
                  }, loading: () {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            6,
                            (index) => Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(15),
                              width: context.screenWidth,
                              height: 50.0.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          )),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _storeExamData(
      WidgetRef ref, List<Question> snap, String examId) async {
    if (await ref
        .read(examControllerProvider)
        .checkUserHasTakenExam(examId: examId)) print('user has taken it ');
    if (!await ref
        .read(examControllerProvider)
        .checkUserHasTakenExam(examId: examId)) {
      ref.read(examControllerProvider).storeExamDataToUser(
            examId: examId,
            title: exam.examTitle,
            description: exam.examDescription,
            imageUrl: exam.examImageUrl,
            questions: snap,
          );
    }
  }
}
