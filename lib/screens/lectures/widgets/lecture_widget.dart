import 'package:faenonibeqwa/utils/base/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/lectures_model.dart';
import '../../../utils/shared/widgets/small_text.dart';

class LectureWidget extends ConsumerWidget {
  final LecturesModel lecture;

  const LectureWidget({
    Key? key,
    required this.lecture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 4, right: 8, left: 8),
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            // blurRadius: 50,
            spreadRadius: 10,
            color: Colors.white,
            offset: Offset(0, -3),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        onTap: () async {
          // if (await _checkSubscribtionState(context, ref)) {
          //   if (!lecture.audienceUid
          //           .contains(ref.watch(authControllerProvider).userInfo.uid) &&
          //       context.mounted) {
          //     await ref
          //         .watch(lecturesControllerProvider)
          //         .addUserToVideoAudience(lecture.id);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (ctx) {
          //           return ViewLectureScreen(
          //               title: lecture.name,
          //               videoPath: lecture.lectureUrl,
          //               id: lecture.id,
          //               audienceNo: lecture.audienceUid.length.toString());
          //         },
          //       ),
          //     );
          //   } else {
          //     if (context.mounted) {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (ctx) {
          //             return ViewLectureScreen(
          //                 title: lecture.name,
          //                 id: lecture.id,
          //                 videoPath: lecture.lectureUrl,
          //                 audienceNo: lecture.audienceUid.length.toString());
          //           },
          //         ),
          //       );
          //     }
          //   }
          // }
        },
        title: SmallText(
          text: lecture.name,
          fontSize: 15,
        ),
        trailing: const Icon(
          Icons.video_collection_outlined,
          color: indicatorColor,
        ),
      ),
    );
  }
}
