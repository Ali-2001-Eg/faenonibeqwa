// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';

class SmallText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final double? height;
  final TextOverflow? overflow;
  final int? maxLines;

  const SmallText({
    Key? key,
    required this.text,
    this.fontSize = 14,
    this.color,
    this.fontWeight = FontWeight.w500,
    this.textAlign,
    this.height,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      style: context.theme.textTheme.displayMedium!.copyWith(
        color: color ?? context.theme.textTheme.displayMedium!.color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        height: height,
      ),
      textAlign: textAlign,
    );
  }
}
