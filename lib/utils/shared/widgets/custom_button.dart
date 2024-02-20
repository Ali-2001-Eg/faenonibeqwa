// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? textColor;
  final Color? backgroundColor;
  final String text;
  final double fontSize;
  final double? width;
  const CustomButton({
    Key? key,
    required this.onTap,
    this.textColor,
    this.backgroundColor,
    this.width,
    required this.text,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: context.theme.elevatedButtonTheme.style!.copyWith(
        minimumSize: MaterialStatePropertyAll<Size?>(Size(width ?? 60.w, 40.h)),
        textStyle: MaterialStatePropertyAll<TextStyle>(
          TextStyle(color: textColor, fontSize: 15.sp),
        ),
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
      ),
      child: SmallText(
        text: text,
        color: Colors.white,
        fontSize: fontSize,
      ),
    );
  }
}
