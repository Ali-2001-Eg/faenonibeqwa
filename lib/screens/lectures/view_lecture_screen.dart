// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/screens/lectures/widgets/video_player_widget.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';

import '../../utils/shared/widgets/small_text.dart';

class ViewLectureScreen extends StatelessWidget {
  const ViewLectureScreen({
    Key? key,
    required this.title,
    required this.videoPath,
    required this.audienceNo,
  }) : super(key: key);
  final String title;
  final String videoPath;
  final String audienceNo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: VideoPlayerWidget(videoPath: videoPath, fromNetwotk: true),
          ),
          10.hSpace,
          SmallText(text: 'عدد المشاهدات $audienceNo'),
          10.hSpace,
        ],
      ),
    );
  }
}
