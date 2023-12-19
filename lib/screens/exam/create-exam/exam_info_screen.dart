// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/screens/exam/widgets/page_view_widget.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';

class ExamInfoScreen extends StatefulWidget {
  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;

  const ExamInfoScreen({
    Key? key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  }) : super(key: key);

  @override
  State<ExamInfoScreen> createState() => _ExamInfoScreenState();
}

class _ExamInfoScreenState extends State<ExamInfoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SmallText(text: "عنوان الاختبار"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: _titleController,
                hintText: 'العنوان',
              ),
            ),
            15.hSpace,
            const SmallText(
              text: "وصف الاختبار",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: _descriptionController,
                hintText: 'الوصف',
              ),
            ),
          ],
        ),
      ),
      onNextPressed: widget.onNextPressed,
      onPreviousPressed: widget.onPreviousPressed,
    );
  }
}
