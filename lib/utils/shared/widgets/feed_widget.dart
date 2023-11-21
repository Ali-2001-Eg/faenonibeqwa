import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../controllers/auth_controller.dart';
import '../../../controllers/meeting_controller.dart';
import '../../../models/meeting_model.dart';
import 'big_text.dart';
import 'custom_indicator.dart';

class FeedWidget extends ConsumerWidget {
  const FeedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<MeetingModel>>(
      stream: ref.read(meetingControllerProvider).feeds,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return BigText(text: snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomIndicator();
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: context.screenHeight / 3),
            child: ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => Divider(
                      color: context.theme.dividerColor,
                      thickness: 2,
                      indent: 30,
                    ),
                itemBuilder: (context, index) {
                  MeetingModel feed = snapshot.data![index];

                  return Column(
                    children: [
                      ListTile(
                        onTap: () => _joinMeeting(ref, feed, context),
                        leading: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://static.wixstatic.com/media/7335d9_2a55f7bb2970467984b8c5773e6723bb~mv2.jpg/v1/fill/w_640,h_426,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/7335d9_2a55f7bb2970467984b8c5773e6723bb~mv2.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: BigText(text: feed.title),
                        subtitle: SmallText(text: feed.username),
                        style: ListTileStyle.drawer,
                        trailing:
                            SmallText(text: timeago.format(feed.startedAt)),
                      ),
                      Divider(
                        thickness: 2.h,
                        endIndent: 50,
                      )
                    ],
                  );
                }),
          );
        } else {
          return Container();
        }
      },
    );
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
                'userID': ref.read(authControllerProvider).userInfo.uid,
                'isBroadcaster': false,
                'title': feed.title,
              },
            ))
        .catchError((err) {
      customSnackbar(context: context, text: err);
      return err;
    });
  }
}
