import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';

import '../../../utils/shared/widgets/custom_text_field.dart';
import '../../../utils/shared/widgets/small_text.dart';
import 'widgets/page_view_widget.dart';
import 'package:timeago/timeago.dart' as timago;

class ExamInfoScreen extends StatefulWidget {
  final void Function(int pageNo) onNextPressed;
  final VoidCallback pickExamImage;
  final Function(BuildContext context) selectDeadline;
  final TextEditingController titleController,
      descriptionController,
      totalGradeController,
      timeMinutesController;
  File? examImage;
  DateTime deadlineTime;
  ExamInfoScreen({
    Key? key,
    required this.onNextPressed,
    required this.pickExamImage,
    this.examImage,
    required this.titleController,
    required this.descriptionController,
    required this.totalGradeController,
    required this.deadlineTime,
    required this.timeMinutesController,
    required this.selectDeadline,
  }) : super(key: key);

  @override
  State<ExamInfoScreen> createState() => _ExamInfoScreenState();
}

class _ExamInfoScreenState extends State<ExamInfoScreen> {
  @override
  Widget build(BuildContext context) {
    print('date is ${widget.deadlineTime.day}');
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
                const SmallText(
                  text: "الدرجه الكليه",
                ),
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
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SmallText(
                                  text: 'موعد الامتحان', maxLines: 2),
                              SmallText(
                                  maxLines: 2,
                                  text: widget.deadlineTime.day.toString()),
                              InkWell(
                                onTap: () {
                                  widget.selectDeadline(context);
                                },
                                child: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
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
