// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:faenonibeqwa/screens/exam/widgets/page_view_widget.dart';

import '../widgets/question_type_radio_widget.dart';

class AddQuestionsScreen extends StatelessWidget {
  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;

  const AddQuestionsScreen({
    Key? key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      body: SingleChildScrollView(
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionTypeRadioWidget(),
          ],
        ),
      ),
      onNextPressed: onNextPressed,
      onPreviousPressed: onPreviousPressed,
    );
  }
}
