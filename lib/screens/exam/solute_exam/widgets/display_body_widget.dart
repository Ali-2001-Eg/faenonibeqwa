import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/exam_model.dart';
import '../../../../utils/shared/widgets/big_text.dart';

class DisplayQuestionBodyWidget extends StatelessWidget {
  const DisplayQuestionBodyWidget({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: BigText(
        text: question.body,
        fontSize: 30,
        color: Colors.white,
      ),
    );
  }
}
