import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  const SmallText({
    super.key,
    required this.text,
     this.fontSize = 14,
     this.color,
     this.fontWeight = FontWeight.w500,
     this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.theme.textTheme.displayMedium!.copyWith(
        color: context.theme.textTheme.displayMedium!.color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
      textAlign: textAlign,
    );
  }
}
