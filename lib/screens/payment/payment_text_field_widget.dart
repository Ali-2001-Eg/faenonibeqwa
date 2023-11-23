// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PaymentTextFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  const PaymentTextFormFieldWidget({
    Key? key,
    this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 50,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          // suffixIcon: const Icon(Icons.filter_list),
          // prefixIcon: const Icon(Icons.search),
          enabledBorder: outlineBorder(),
          focusedBorder: outlineBorder(),
          border: outlineBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
    );
  }
}
