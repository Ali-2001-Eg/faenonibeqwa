import 'package:flutter/material.dart';

import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';

class AddNewQuestionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const AddNewQuestionButtonWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: onPressed,
      text: 'إضافه سؤال',
    );
  }
}
