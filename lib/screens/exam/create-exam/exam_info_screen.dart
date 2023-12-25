// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';

import '../../../utils/shared/widgets/custom_text_field.dart';
import '../../../utils/shared/widgets/small_text.dart';
import '../widgets/page_view_widget.dart';

// ignore: must_be_immutable
class ExamInfoScreen extends StatefulWidget {
  final void Function(int pageNo) onNextPressed;
  final VoidCallback pickExamImage;
  final TextEditingController titleController,
      descriptionController,
      totalGradeController,
      deadlineTimeController,
      timeMinutesController;
  File? examImage;

  ExamInfoScreen({
    Key? key,
    required this.onNextPressed,
    required this.pickExamImage,
    this.examImage,
    required this.titleController,
    required this.descriptionController,
    required this.totalGradeController,
    required this.deadlineTimeController,
    required this.timeMinutesController,
  }) : super(key: key);

  @override
  State<ExamInfoScreen> createState() => _ExamInfoScreenState();
}

class _ExamInfoScreenState extends State<ExamInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.screenHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: context.screenWidth * 0.5,
                          height: context.screenHeight * 0.2,
                          color: Colors.grey,
                          child: widget.examImage == null
                              ? Icon(
                                  Icons.image_outlined,
                                  size: context.screenHeight * 0.1,
                                )
                              : Image.file(widget.examImage!, fit: BoxFit.fill),
                        ),
                      ),
                      IconButton(
                          onPressed: widget.pickExamImage,
                          icon: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                  color: context.theme.iconTheme.color,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.edit)))
                    ],
                  ),
                ),
                30.hSpace,
                const SmallText(text: "عنوان الاختبار"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: widget.titleController,
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
                    controller: widget.descriptionController,
                    hintText: 'الوصف',
                  ),
                ),
                20.hSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: widget.totalGradeController,
                          hintText: 'الدرجه الكليه',
                          keyBoardType: TextInputType.number,
                          suffixIcon: Icons.grade_outlined,
                        ),
                      ),
                      10.wSpace,
                      Expanded(
                        child: CustomTextField(
                            controller: widget.deadlineTimeController,
                            hintText: 'موعد الامتحان',
                            keyBoardType: TextInputType.datetime,
                            suffixIcon: Icons.calendar_today),
                      )
                    ],
                  ),
                ),
                20.hSpace,
                Center(
                    child: SizedBox(
                  width: context.screenWidth * 0.6,
                  child: CustomTextField(
                    controller: widget.timeMinutesController,
                    hintText: "مده الامتحان بالدقائق",
                    suffixIcon: Icons.alarm,
                    keyBoardType: TextInputType.number,
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
      onSubmitted: () {
        widget.onNextPressed(1);
      },
    );
  }
}
