// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/screens/exam/widgets/page_view_widget.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
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

class _ExamInfoScreenState extends State<ExamInfoScreen>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageWidget(
      body: SingleChildScrollView(
        child: Padding(
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
      ),
      onNextPressed: widget.onNextPressed,
      onPreviousPressed: widget.onPreviousPressed,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
