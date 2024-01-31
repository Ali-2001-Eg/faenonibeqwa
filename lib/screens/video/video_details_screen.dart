import 'package:faenonibeqwa/screens/video/video_view_widget.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoDetailsScreen extends StatelessWidget {
  const VideoDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          const BigText(text: 'الدرس الاول / شرح الكيماء العضوية'),
          Divider(
            endIndent: 30.0.w,
            color: Colors.green,
            indent: 30.0.w,
          ),
          const SizedBox(height: 10),
          const VideoViewWidget()
        ],
      ),
    );
  }
}
