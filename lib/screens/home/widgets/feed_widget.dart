// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/base/app_images.dart';
import 'package:faenonibeqwa/utils/shared/widgets/shimmer_widget.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';

import '../../../models/meeting_model.dart';
import '../../../utils/base/app_helper.dart';
import '../../../utils/base/colors.dart';
import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/big_text.dart';
import '../payment/subscription_screen.dart';

class FeedWidget extends ConsumerWidget {
  const FeedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(feedsStream).when(data: (data) {
      if (data.isEmpty) {
        return const Expanded(
          child: Center(
            child: BigText(
              text: 'لايوجد مكالمات',
              fontSize: 28,
            ),
          ),
        );
      }
      return ListView.separated(
          itemCount: data.length,
          separatorBuilder: (context, index) => Container(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            MeetingModel meetingItem = data[index];
            return MeetingWidget(
                meeting: meetingItem,
                onJoin: () => _joinMeeting(ref, meetingItem, context));
          });
    }, error: (error, stackTrace) {
      return BigText(text: error.toString());
    }, loading: () {
      return const SingleChildScrollView(
          child: ShimmerWidget(
        cardsNumber: 4,
        heigth: 60,
      ));
    });
  }

  Future<void> _joinMeeting(
      WidgetRef ref, MeetingModel feed, BuildContext context) async {
    if (await _checkSubscribtionState(context, ref,feed)) {
      ref
          .read(meetingControllerProvider)
          .joinMeeting(feed.channelId)
          .then((value) => Navigator.pushNamed(
                context,
                MeetingScreen.routeName,
                arguments: {
                  'channelId': feed.channelId,
                  'userID': ref.watch(authControllerProvider).userInfo.uid,
                  'isBroadcaster': false,
                  'title': feed.title,
                },
              ));
    } else {
      
    }
  }

  Future<bool> _checkSubscribtionState(
      BuildContext context, WidgetRef ref,MeetingModel meeting) async {
    if (!await ref.read(paymentControllerProvider).subscriptionEnded) {
      if (meeting.endsAt.isBefore(DateTime.now()) && context.mounted) {
        AppHelper.customSnackbar(context: context, title: 'انتهت المكالمة ');
        return false;
      }
      print('not ended');
      return true;
    } else {
      ref.read(paymentControllerProvider).changePlanAfterEndDate;

      await FirebaseMessaging.instance.unsubscribeFromTopic('premium');
      if (context.mounted) {
        AppHelper.customSnackbar(
          context: context,
          title: 'يجب تفعيل الاشتراك لتتمكن من دخول البث المباشر',
        );
        Navigator.of(context).pushNamed(SubscriptionScreen.routeName);
      }

      return false;
    }
  }
}

class MeetingWidget extends StatelessWidget {
  final MeetingModel meeting;
  final VoidCallback onJoin;
  const MeetingWidget({
    Key? key,
    required this.meeting,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: BoxDecoration(
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
          )),
      child: Row(
        children: [
          Image.asset(
            AppImages.logo,
            width: 100.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(
                  text: meeting.title,
                  fontSize: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      SmallText(
                        text: meeting.viewers.length.toString(),
                        fontSize: 16,
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.person_outline_outlined,
                        color: lightAppBar,
                        size: 20,
                      ),
                      const Spacer(),
                      const Directionality(
                        textDirection: TextDirection.ltr,
                        child: SmallText(
                          text: "منذ 10 دقائق",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: onJoin,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: indicatorColor,
                          minimumSize: Size(100.w, 20.h)),
                      child: const SmallText(
                        text: 'ادخل الأن',
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
