import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/lectures_model.dart';
import '../../../utils/base/app_helper.dart';
import '../../../utils/base/subscription_screen.dart';
import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/small_text.dart';
import '../view_lecture_screen.dart';

class LectureWidget extends StatelessWidget {
  final LecturesModel lecture;

  const LectureWidget({
    Key? key,
    required this.lecture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 50,
              spreadRadius: 10,
              color: Colors.white,
              offset: Offset(0, -3),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Consumer(
          builder: (context, ref, child) {
            return ListTile(
              onTap: () async {
                if (await _checkSubscribtionState(context, ref)) {
                  if (!lecture.audienceUid
                          .contains(ref.watch(userDataProvider).value!.uid) &&
                      context.mounted) {
                    ref
                        .watch(lecturesControllerProvider)
                        .addUserToVideoAudience(lecture.id);
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return ViewLectureScreen(
                          title: lecture.name,
                          videoPath: lecture.lectureUrl,
                          id: lecture.id,
                          audienceNo: lecture.audienceUid.length.toString());
                    }));
                  } else {
                    if (context.mounted) {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return ViewLectureScreen(
                            title: lecture.name,
                            id: lecture.id,
                            videoPath: lecture.lectureUrl,
                            audienceNo: lecture.audienceUid.length.toString());
                      }));
                    }
                  }
                }
              },
              leading: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(lecture.lectureThumbnail),
              ),
              // isThreeLine: true,
              // dense: false,
              title: BigText(text: lecture.name),
              subtitle: SmallText(
                  text: 'عدد المشاهدات:  ${lecture.audienceUid.length}'),
              trailing: const Icon(Icons.video_collection_outlined),
            );
          },
        ));
  }

  Future<bool> _checkSubscribtionState(
      BuildContext context, WidgetRef ref) async {
    if (ref.read(paymentControllerProvider).subscriptionEnded) {
      ref.read(paymentControllerProvider).changePlanAfterEndDate;
    }
    if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      return true;
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('premium');
      if (context.mounted) {
        AppHelper.customSnackbar(
          context: context,
          title: 'يجب تفعيل الاشتراك لتتمكن من مشاهده المحاضره',
        );
            Navigator.of(context).pushNamed(SubscriptionScreen.routeName);
      }

      return false;
    }
  }
}



// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:faenonibeqwa/utils/providers/app_providers.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

// import 'package:faenonibeqwa/models/lectures_model.dart';
// import 'package:faenonibeqwa/screens/lectures/view_lecture_screen.dart';
// import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
// import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../../utils/base/app_helper.dart';
// import '../../../utils/base/subscription_dialoge.dart';
// import '../../../utils/shared/widgets/big_text.dart';

// class LectureWidget extends StatelessWidget {
//   final LecturesModel lecture;
//   const LectureWidget({
//     Key? key,
//     required this.lecture,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(8.0),
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration:  BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.withOpacity(0.5)),
//         boxShadow: const [
//           BoxShadow(
//             blurRadius: 50,
//             spreadRadius: 10,
//             color: Colors.white,
//             offset: Offset(0, -3),
//           ),
//         ]
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           BigText(text: lecture.name),
//           10.hSpace,

//           ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight: context.screenHeight / 3,
//               // minHeight: context.screenHeight / 4,
//               // minWidth: context.screenWidth,
//             ),
//             child: Container(
//               constraints: BoxConstraints(
//                 minHeight: context.screenHeight / 4,
//                 maxHeight: context.screenHeight / 3,
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Consumer(builder: (context, ref, child) {
//                   return InkWell(
//                     onTap: () async {
//                       if (await _checkSubscribtionState(context, ref)) {
//                         if (!lecture.audienceUid.contains(
//                                 ref.watch(userDataProvider).value!.uid) &&
//                             context.mounted) {
//                           ref
//                               .watch(lecturesControllerProvider)
//                               .addUserToVideoAudience(lecture.id);
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (ctx) {
//                             return ViewLectureScreen(
//                                 title: lecture.name,
//                                 videoPath: lecture.lectureUrl,
//                                 id: lecture.id,
//                                 audienceNo:
//                                     lecture.audienceUid.length.toString());
//                           }));
//                         } else {
//                           if (context.mounted) {
//                             Navigator.push(context,
//                                 MaterialPageRoute(builder: (ctx) {
//                               return ViewLectureScreen(
//                                   title: lecture.name,
//                                   id: lecture.id,
//                                   videoPath: lecture.lectureUrl,
//                                   audienceNo:
//                                       lecture.audienceUid.length.toString());
//                             }));
//                           }
//                         }
//                       }
//                     },
//                     child: CachedNetworkImage(
//                       imageUrl: lecture.lectureThumbnail,
//                       fit: BoxFit.fill,
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                       placeholder: (_, url) {
//                         return Shimmer.fromColors(
//                           baseColor: Colors.grey,
//                           highlightColor: Colors.grey[100]!,
//                           child: Container(
//                               // height: 120.h,
//                               width: context.screenWidth,
//                               margin: const EdgeInsets.all(15),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(15))),
//                         );
//                       },
//                     ),
//                   );
//                 }),
//                 // VideoPlayerWidget(videoPath: lecturepath, fromNetwotk: true),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

// }
