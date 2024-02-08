
import 'package:flutter/material.dart';

import 'custom_button.dart';
import 'small_text.dart';

class PlanWidget extends StatelessWidget {
  final String title;
  final String btnText;
  final VoidCallback onTap;
  const PlanWidget({
    super.key,
    required this.title,
    required this.btnText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SmallText(text: title),
      trailing: CustomButton(onTap: onTap, text: btnText),
    );
  }
}
