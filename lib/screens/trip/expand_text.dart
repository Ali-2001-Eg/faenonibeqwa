// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../utils/shared/widgets/small_text.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;
  bool hiddenText = true;
  //emit state
  double textHeight = 100;
  @override
  void initState() {
    super.initState();

    //split text into two sections
    if (widget.text.length > textHeight) {
      //split from beginning until text reaches container height
      firstHalf = widget.text.substring(0, textHeight.toInt());
      //split from text height +1 to end of text
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      //we must initialize because it's late variable
      //even if text is too short
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: secondHalf.isEmpty
          ? SmallText(
              height: 1.8,
              // color: AppColors.paraColor,
              // size: Dimensions.fontSize16,
              textAlign: TextAlign.start,
              text: firstHalf)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SmallText(
                  height: 1.8,
                  // color: AppColors.paraColor,
                  // size: Dimensions.fontSize16,
                  textAlign: TextAlign.start,

                  text: hiddenText
                      ? ('$firstHalf...')
                      : (firstHalf + secondHalf),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      hiddenText
                          ? const SmallText(
                              text: 'show more',
                              textAlign: TextAlign.start,

                              // color: AppColors.mainColor,
                              // size: Dimensions.fontSize16,
                            )
                          : const SmallText(
                              text: 'show less',
                              textAlign: TextAlign.start,

                              // color: AppColors.mainColor,
                              // size: Dimensions.fontSize16,
                            ),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        // color: AppColors.mainColor,
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
