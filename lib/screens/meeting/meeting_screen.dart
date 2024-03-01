import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/utils/base/app_constants.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import '../../utils/providers/app_providers.dart';

class MeetingScreen extends ConsumerWidget {
  static const String routeName = '/meeting-sceen';
  const MeetingScreen({
    Key? key,
    required this.channelId,
    required this.title,
    required this.isBrodcaster,
  }) : super(key: key);
  final String channelId;
  final String title;
  final bool isBrodcaster;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var zegoBottomMenuBarConfig = ZegoBottomMenuBarConfig(
      buttons: <ZegoMenuBarButtonName>[
        ZegoMenuBarButtonName.toggleMicrophoneButton,
        ZegoMenuBarButtonName.toggleCameraButton,
        ZegoMenuBarButtonName.switchAudioOutputButton,
        ZegoMenuBarButtonName.chatButton,
        ZegoMenuBarButtonName.leaveButton,
      ],
    );
    var zegoTopMenuBarConfig = ZegoTopMenuBarConfig(
      title: title,
      buttons: <ZegoMenuBarButtonName>[
        ZegoMenuBarButtonName.showMemberListButton,
        ZegoMenuBarButtonName.switchCameraButton,
        if (isBrodcaster) ZegoMenuBarButtonName.toggleScreenSharingButton,
      ],
    );
    var config = ZegoUIKitPrebuiltVideoConferenceConfig(
      onLeaveConfirmation: (BuildContext context) async {
        return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              // backgroundColor: context.theme.cardColor,
              title: const BigText(
                text: "الخروج من المكالمه",
              ),
              content: const SmallText(
                text: "يمكنك الخروج من المكالمه و الرجوع في اي وقت لاحق",
              ),
              actions: [
                ElevatedButton(
                  child: const Text("الاكمال",
                      style: TextStyle(color: Colors.white70)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  child: const Text("الخروج"),
                  onPressed: () {
                    _handelExitFromMeeting(ref)
                        .then((value) => Navigator.of(context).pop(true));
                  },
                ),
              ],
            );
          },
        );
      },
    )
      ..layout = ZegoLayout.gallery(
          addBorderRadiusAndSpacingBetweenView: false,
          showScreenSharingFullscreenModeToggleButtonRules:
              ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
          showNewScreenSharingViewInFullscreenMode:
              true) // Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
      ..bottomMenuBarConfig = zegoBottomMenuBarConfig
      ..turnOnCameraWhenJoining = false
      ..topMenuBarConfig = zegoTopMenuBarConfig;
    return PopScope(
      onPopInvoked: (t) {
        _handelExitFromMeeting(ref);
      },
      child: SafeArea(
        child: Stack(
          children: [
            ZegoUIKitPrebuiltVideoConference(
              appID: AppConstants.appId,
              appSign: AppConstants.appSign,
              userID: ref.watch(authControllerProvider).userInfo.uid,
              userName: ref.watch(authControllerProvider).userInfo.displayName!,
              conferenceID: channelId,
              config: config,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handelExitFromMeeting(WidgetRef ref) async {
    isBrodcaster
        ? ref.read(meetingControllerProvider).endMeeting(channelId)
        : ref.read(meetingControllerProvider).leaveMeeting(channelId);
  }
}
