// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageWidget extends StatefulWidget {
  final Widget body;
  final VoidCallback? onNextPressed;
  final VoidCallback? onPreviousPressed;
  final VoidCallback onSubmitted;

  const PageWidget({
    Key? key,
    required this.body,
    this.onNextPressed,
    this.onPreviousPressed,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: widget.body),
          // 20.hSpace,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.onPreviousPressed != null)
                  CustomButton(
                      onTap: widget.onPreviousPressed!,
                      text: 'الرجوع',
                      width: context.screenWidth * 0.3,
                      backgroundColor: const Color.fromARGB(255, 201, 73, 64)),
                CustomButton(
                  onTap: widget.onSubmitted,
                  text: 'تأكيد',
                  width: context.screenWidth * 0.3,
                  backgroundColor: Colors.blueAccent,
                ),
                if (widget.onNextPressed != null)
                  CustomButton(
                    onTap: widget.onNextPressed!,
                    text: 'التالي',
                    width: context.screenWidth * 0.3,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
