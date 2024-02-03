// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/screens/lectures/widgets/video_player_widget.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';

import '../../../utils/shared/widgets/big_text.dart';

class LectureWidget extends StatelessWidget {
  final String lecturepath;
  final String title;
  final String audienceNo;
  const LectureWidget({
    Key? key,
    required this.lecturepath,
    required this.title,
    required this.audienceNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(text: title),
          SmallText(text: 'عدد المشاهدات $audienceNo'),
          10.hSpace,
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: context.screenHeight / 3,
              // minHeight: context.screenHeight / 4,
              minWidth: context.screenWidth,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child:
                  VideoPlayerWidget(videoPath: lecturepath, fromNetwotk: true),
            ),
          )
        ],
      ),
    );

    //  ListTile(
    //   onTap: () {},
    //   leading: AspectRatio(
    //     aspectRatio: 16 / 9,
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(15),
    //       child: VideoPlayerWidget(
    //         videoPath: lecturepath,
    //         fromNetwotk: true,
    //       ),
    //     ),
    //   ),
    //   title: BigText(text: title),
    //   subtitle: SmallText(text: audienceNo),
    // );
  }
}
