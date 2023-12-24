// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/screens/exam/widgets/page_view_widget.dart';

class SubmitExamScreen extends StatelessWidget {
  final VoidCallback onPreviousPressed;
  final VoidCallback onSubmitted;
  final Widget body;
  const SubmitExamScreen({
    Key? key,
    required this.onPreviousPressed,
    required this.onSubmitted,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      body: body,
      onPreviousPressed: onPreviousPressed,
      onSubmitted: onSubmitted,
    );
  }
}
