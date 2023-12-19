// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/screens/exam/widgets/page_view_widget.dart';

class SubmitExamScreen extends StatelessWidget {
  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;

  const SubmitExamScreen({
    Key? key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      body: Container(),
      onNextPressed: onNextPressed,
      onPreviousPressed: onPreviousPressed,
    );
  }
}
