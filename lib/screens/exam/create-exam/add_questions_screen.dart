// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/screens/exam/widgets/page_view_widget.dart';

import '../widgets/question_content_widget.dart';

class AddQuestionsScreen extends StatefulWidget {
  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;

  const AddQuestionsScreen({
    Key? key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  }) : super(key: key);

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  List<Widget> generatedWidgets = [];

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QuestionContentWidget(),
            if (generatedWidgets.isEmpty) Center(child: _addNewQuestionButton),
            //added questions
            Column(
              children: [
                ...generatedWidgets,
                if (generatedWidgets.isNotEmpty) _addNewQuestionButton,
              ],
            )
          ],
        ),
      ),
      onNextPressed: widget.onNextPressed,
      onPreviousPressed: widget.onPreviousPressed,
    );
  }

  CustomButton get _addNewQuestionButton {
    return CustomButton(
        onTap: () {
          // Generate a new widget and add it to the list
          Widget newWidget = const QuestionContentWidget();
          setState(() {
            generatedWidgets.add(newWidget);
          });
        },
        text: 'إضافه سؤال');
  }
}
