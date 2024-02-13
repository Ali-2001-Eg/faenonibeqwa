import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/shimmer_widget.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../models/meeting_model.dart';
import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/big_text.dart';
import '../../../utils/shared/widgets/custom_indicator.dart';

class FeedWidget extends ConsumerWidget {
  const FeedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(feedsStream).when(data: (data) {
      if (data.isEmpty) {
        return Center(
          child: BigText(
            text: 'لايوجد مكالمات',
            fontSize: 28,
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
                        'assets/images/trip.jpg',
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
                  trailing: SmallText(text: timeago.format(feed.startedAt)),
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

  Future<Object?> _joinMeeting(
      WidgetRef ref, MeetingModel feed, BuildContext context) {
    return ref
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
