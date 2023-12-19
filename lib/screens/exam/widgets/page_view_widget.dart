// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageWidget extends StatelessWidget {
  final Widget body;
  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;

  const PageWidget({
    Key? key,
    required this.body,
    required this.onNextPressed,
    required this.onPreviousPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: body),
          // 20.hSpace,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                    onTap: onPreviousPressed,
                    text: 'الرجوع',
                    width: context.screenWidth * 0.3,
                    backgroundColor: const Color.fromARGB(255, 201, 73, 64)),
                CustomButton(
                  onTap: onNextPressed,
                  text: 'تأكيد',
                  width: context.screenWidth * 0.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
