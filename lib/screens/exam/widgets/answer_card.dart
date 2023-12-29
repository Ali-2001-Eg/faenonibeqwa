// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../models/exam_model.dart';
import '../../../utils/shared/widgets/big_text.dart';

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    Key? key,
    required this.answer,
    required this.color,
  }) : super(key: key);

  final Answers answer;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      margin: EdgeInsets.all(10.w),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: BigText(
        text: answer.answer,
        textAlign: TextAlign.center,
      ),
    );
  }
}
