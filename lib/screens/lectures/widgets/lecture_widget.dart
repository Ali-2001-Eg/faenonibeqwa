// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/models/lectures_model.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/display_image_widget.dart';
import 'package:faenonibeqwa/screens/lectures/view_lecture_screen.dart';
import 'package:faenonibeqwa/screens/lectures/widgets/video_player_widget.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/shared/widgets/big_text.dart';

class LectureWidget extends StatelessWidget {
  final LecturesModel lecture;
  const LectureWidget({
    Key? key,
    required this.lecture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(text: lecture.name),
          10.hSpace,
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: context.screenHeight / 3,
              // minHeight: context.screenHeight / 4,
              minWidth: context.screenWidth,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: context.screenHeight / 4,
                    maxHeight: context.screenHeight / 3,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Consumer(builder: (context, ref, child) {
                      return InkWell(
                        onTap: () {
                          print('ali');
                          if (!lecture.audienceUid.contains(
                              ref.watch(userDataProvider).value!.uid)) {
                            ref
                                .watch(lecturesControllerProvider)
                                .addUserToVideoAudience(lecture.id);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return ViewLectureScreen(
                                  title: lecture.name,
                                  videoPath: lecture.lectureUrl,
                                  audienceNo:
                                      lecture.audienceUid.length.toString());
                            }));
                          } else {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return ViewLectureScreen(
                                  title: lecture.name,
                                  videoPath: lecture.lectureUrl,
                                  audienceNo:
                                      lecture.audienceUid.length.toString());
                            }));
                          }
                        },
                        child: CachedNetworkImage(
                          imageUrl: lecture.lectureThumbnail,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          placeholder: (_, url) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                  // height: 120.h,
                                  width: context.screenWidth,
                                  margin: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15))),
                            );
                          },
                        ),
                      );
                    }),
                    // VideoPlayerWidget(videoPath: lecturepath, fromNetwotk: true),
                  ),
                ),
                const CircleAvatar(
                  child: Icon(Icons.play_arrow),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
