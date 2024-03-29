import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final Color? colorIcon;
  final Widget? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyBoardType;
  final double? width;
  final double? hight;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool? filled;
  final Color? filledColor;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final bool? readOnly;
  final Function(String)? onChange;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.onSubmitted,
    this.onTap,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.colorIcon,
    this.prefixIcon,
    this.suffixIcon,
    this.keyBoardType,
    this.width,
    this.hight,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textInputAction,
    this.validator,
    this.obscureText,
    this.readOnly,
    this.onChange,
    this.inputFormatters,
    this.filled,
    this.filledColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      minLines: minLines,
      keyboardType: keyBoardType,
      onFieldSubmitted: onSubmitted,
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        decorationThickness: 0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          suffixIcon: Icon(suffixIcon),
          hintText: hintText,
          hintStyle: const TextStyle(
            decorationThickness: 0,
            color: Colors.grey,
            fontFamily: 'Cairo',
            fontSize: 18,
          ),
          filled: filled,
          fillColor: filledColor,
          border: outlineInputBorder(),
          focusedBorder: outlineInputBorder(),
          enabledBorder: outlineInputBorder()),
    );
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.5),
        // color: context.theme.cardColor,
      ),
    );
  }
}
