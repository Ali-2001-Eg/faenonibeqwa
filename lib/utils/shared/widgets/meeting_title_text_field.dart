import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onTap;
  final String hint;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.onTap,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onTap,
      controller: controller,
      style: context.theme.textTheme.displayMedium!.copyWith(
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.theme.cardColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.theme.canvasColor,
            ),
          )),
    );
  }
}
