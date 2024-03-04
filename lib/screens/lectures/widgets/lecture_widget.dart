import 'package:faenonibeqwa/utils/base/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/lectures_model.dart';
import '../../../utils/base/app_helper.dart';
import '../../home/payment/subscription_screen.dart';
import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/small_text.dart';
import '../view_lecture_screen.dart';

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
          if (await _checkSubscribtionState(context, ref)) {
            if (!lecture.audienceUid
                    .contains(ref.watch(authControllerProvider).userInfo.uid) &&
                context.mounted) {
              await ref
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return ViewLectureScreen(
                          title: lecture.name,
                          id: lecture.id,
                          videoPath: lecture.lectureUrl,
                          audienceNo: lecture.audienceUid.length.toString());
                    },
                  ),
                );
              }
            }
          }
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

  Future<bool> _checkSubscribtionState(
      BuildContext context, WidgetRef ref) async {
    
    if (!await ref.read(paymentControllerProvider).subscriptionEnded) {
      return true;
    } else {
      await ref.read(paymentControllerProvider).changePlanAfterEndDate;
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
