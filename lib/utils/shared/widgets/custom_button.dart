import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? textColor;
  final String text;
  final double fontSize;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.textColor,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.6,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ElevatedButton(
          onPressed: onTap,
          style: context.theme.elevatedButtonTheme.style!.copyWith(
            textStyle: MaterialStatePropertyAll<TextStyle>(
              TextStyle(color: textColor, fontSize: 15.sp),
            ),
          ),
          child: SmallText(
            text: text,
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
