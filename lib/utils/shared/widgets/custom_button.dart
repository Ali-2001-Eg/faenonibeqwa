import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String svgPath;
  final String text;
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.svgPath,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.8,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ElevatedButton(
            onPressed: onTap,
            style: context.theme.elevatedButtonTheme.style!.copyWith(),
            child: Row(
              children: [
                SvgPicture.asset(
                  svgPath,
                  height: 30.h,
                  width: 30.w,
                  fit: BoxFit.cover,
                ),
                30.horizontalSpace,
                Expanded(
                  child: SmallText(
                    text: text,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
