import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/utils/shared/widgets/shimmer_widget.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/base/app_images.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../models/meeting_model.dart';
import '../../../utils/base/app_helper.dart';
import '../payment/subscription_screen.dart';
import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/big_text.dart';
import '../../../utils/shared/widgets/custom_indicator.dart';

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
            MeetingModel feed = data[index];

            return Column(
              children: [
                ListTile(
                  onTap: () => _joinMeeting(ref, feed, context),
                  leading: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        AppImages.logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: BigText(
                    fontSize: 14,
                    text: feed.title,
                    color: Colors.black,
                  ),
                  subtitle: SmallText(
                    text: feed.username,
                    color: Colors.black,
                  ),
                  style: ListTileStyle.drawer,
                  trailing: SmallText(
                      text:
                          ' عدد الحضور بالداخل: ${feed.viewers.length.toString()}'),
                ),
                // Divider(
                //   thickness: 2.h,
                //   endIndent: 50,
                // )
              ],
            );
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
    if (await _checkSubscribtionState(context, ref)) {
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
    }
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
          title: 'يجب تفعيل الاشتراك لتتمكن من دخول البث المباشر',
        );
        Navigator.of(context).pushNamed(SubscriptionScreen.routeName);
      }

      return false;
    }
  }
}
