// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:faenonibeqwa/screens/exam/widgets/question_content_widget.dart';
import 'package:flutter/material.dart';

import '../../../utils/base/question_z.dart';
import '../../../utils/shared/widgets/custom_button.dart';
import '../widgets/page_view_widget.dart';

class AddQuestionScreen extends StatefulWidget {
  final void Function(int pageNo) onNextPressed;
  final List<QuestionZ> questions;

  const AddQuestionScreen({
    Key? key,
    required this.onNextPressed,
    required this.questions,
  }) : super(key: key);

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //first question so index is 0
            QuestionContentWidget(
              questions: widget.questions,
              questionIndex: 0,
              pickQuestionImage: () async =>
                  await widget.questions[0].pickQuestionImage(context),
            ),
            if (widget.questions.length == 1)
              Center(child: _addNewQuestionButton),
            //added widget.questions
            if (widget.questions.length > 1) ...[
              ListView.builder(
                  itemCount: widget.questions.length - 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return QuestionContentWidget(
                      questions: widget.questions,
                      questionIndex: index + 1,
                      pickQuestionImage: () async {
                        await widget.questions[index + 1]
                            .pickQuestionImage(context);
                      },
                    );
                  }),
              Center(child: _addNewQuestionButton),
            ],
          ],
        ),
      ),
      onPreviousPressed: () {
        widget.onNextPressed(0);
      },
      onSubmitted: () {
        widget.onNextPressed(2);
      },
    );
  }

  CustomButton get _addNewQuestionButton {
    return CustomButton(
        onTap: () {
          setState(() {
            widget.questions.add(QuestionZ());
          });
        },
        text: 'إضافه سؤال');
  }
}
