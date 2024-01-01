import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/shared/widgets/small_text.dart';

class SummaryExamComponentWidget extends StatelessWidget {
  const SummaryExamComponentWidget({
    Key? key,
    required this.headTitle,
    required this.data,
    this.isCorrectAnswer = false,
  }) : super(key: key);
  final String headTitle;
  final String data;
  final bool isCorrectAnswer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SmallText(text: headTitle, fontSize: 18.sp),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: isCorrectAnswer ? Colors.green : null,
              border:
                  Border.all(color: context.theme.appBarTheme.backgroundColor!),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SmallText(
              text: data,
              color: !isCorrectAnswer ? Colors.black : Colors.white,
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}
