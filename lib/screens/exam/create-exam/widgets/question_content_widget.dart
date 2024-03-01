// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';

import '../../../../utils/base/question_z.dart';
import '../../../../utils/shared/widgets/big_text.dart';
import '../../../../utils/shared/widgets/custom_button.dart';
import '../../../../utils/shared/widgets/custom_text_field.dart';
import '../../../../utils/shared/widgets/small_text.dart';

class QuestionContentWidget extends StatefulWidget {
  final List<QuestionZ> questions;
  final int questionIndex;
  final Future<void> Function() pickQuestionImage;
  const QuestionContentWidget({
    Key? key,
    required this.questions,
    required this.questionIndex,
    required this.pickQuestionImage,
  }) : super(key: key);

  @override
  State<QuestionContentWidget> createState() => _QuestionContentWidgetState();
}

class _QuestionContentWidgetState extends State<QuestionContentWidget> {
  int? _selectedOption;
  int _selectedAnswer = -1;
  @override
  void initState() {
    if (mounted) {
      setState(() {
        _selectedOption = null;
        _selectedAnswer = -1;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BigText(text: 'اختر نوع السؤال'),
          //radio buttons
          Row(
            children: [
              Radio(
                value: 0,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value as int;
                  });
                },
              ),
              const BigText(text: 'سؤال مقالي'),
            ],
          ),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value as int;
                  });
                },
              ),
              const BigText(text: 'الحق صوره للسؤال'),
            ],
          ),
          20.hSpace,
          //actions
          _selectedOption == 0
              ? CustomTextField(
                  controller: widget
                      .questions[widget.questionIndex].questionBodyController,
                  keyBoardType: TextInputType.multiline,
                )
              : widget.questions[widget.questionIndex].questionImage == null
                  ? Center(
                      child: CustomButton(
                        onTap: () {
                          widget
                              .pickQuestionImage()
                              .then((value) => setState(() {}));
                        },
                        text: 'اختر صوره',
                      ),
                    )
                  : Column(
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 30.h,
                              maxHeight: 100.h,
                            ),
                            child: Image.file(File(widget
                                .questions[widget.questionIndex]
                                .questionImage!
                                .path))),
                        10.hSpace,
                        CustomTextField(
                          controller: widget.questions[widget.questionIndex]
                              .questionBodyController,
                          hintText: 'السؤال',
                        )
                      ],
                    ),
          20.hSpace,
          const BigText(text: "الاجابات"),
          10.hSpace,
          //answers
          DropdownButton<int>(
            value: null,
            hint: const SmallText(text: 'يرجي اختيار رمز الاجابه الصحيحه'),
            onChanged: (value) {
              setState(() {
                widget.questions[widget.questionIndex].correctAnswerIndex =
                    value!;
                _selectedAnswer =
                    widget.questions[widget.questionIndex].correctAnswerIndex;
              });
            },
            elevation: 0,
            dropdownColor: Colors.white,
            focusColor: Colors.grey,
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            items: [0, 1, 2, 3]
                .map((index) => DropdownMenuItem<int>(
                      value: index,
                      child: Text(index == 0
                          ? 'أ'
                          : index == 1
                              ? 'ب'
                              : index == 2
                                  ? 'ج'
                                  : "د"),
                    ))
                .toList(),
          ),
          ListView.separated(
            itemCount: 4,
            shrinkWrap: true,
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, i) =>
                Padding(padding: EdgeInsets.all(10.w), child: Container()),
            itemBuilder: (context, i) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 30, width: 30,
                    // padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                        color: _selectedAnswer == i
                            ? context.theme.appBarTheme.backgroundColor
                            : null,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 0.5)),
                    child: Center(
                      child: SmallText(
                          text: i == 0
                              ? 'أ'
                              : i == 1
                                  ? 'ب'
                                  : i == 2
                                      ? 'ج'
                                      : "د"),
                    ),
                  ),
                  5.wSpace,
                  Expanded(
                    child: Container(
                        constraints: BoxConstraints(
                          minWidth: 30,
                          maxWidth: context.screenWidth * 0.7,
                          maxHeight: 200,
                          minHeight: 50,
                        ),
                        child: CustomTextField(
                          filled: _selectedAnswer == i,
                          filledColor:
                              context.theme.appBarTheme.backgroundColor,
                          controller: widget.questions[widget.questionIndex]
                              .answerControllers[i],
                          hintText: i == 0
                              ? 'أ ادخل إجابه السؤال'
                              : i == 1
                                  ? ' ادخل إجابه السؤال ب'
                                  : i == 2
                                      ? 'ادخل إجابه السؤال ج'
                                      : 'ادخل إجابه السؤال د',
                        )),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
