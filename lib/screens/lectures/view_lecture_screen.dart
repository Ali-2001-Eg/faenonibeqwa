// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/screens/home/add_document_screen.dart';
import 'package:faenonibeqwa/screens/home/widgets/paper_widget.dart';
import 'package:faenonibeqwa/utils/shared/widgets/admin_floating_action_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/screens/lectures/widgets/video_player_widget.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/shared/widgets/small_text.dart';

class ViewLectureScreen extends StatelessWidget {
  const ViewLectureScreen({
    Key? key,
    required this.title,
    required this.videoPath,
    required this.audienceNo,
    required this.id,
  }) : super(key: key);
  final String title;
  final String videoPath;
  final String audienceNo;
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child:
                    VideoPlayerWidget(videoPath: videoPath, fromNetwotk: true),
              ),
            ),
            10.hSpace,
            SmallText(
                text: 'عدد المشاهدات : $audienceNo',
                fontWeight: FontWeight.w700),
            30.hSpace,
            const BigText(text: 'الملازم و الكتب'),
            50.hSpace,
            PapersWidget(lectureId: id),
          ],
        ),
      ),
      floatingActionButton: AdminFloatingActionButton(
        icon: Icons.picture_as_pdf_rounded,
        routeName: AddDocumentScreen.routeName,
        heroTag: 'add-document',
        arguments: id,
      ),
    );
  }
}
