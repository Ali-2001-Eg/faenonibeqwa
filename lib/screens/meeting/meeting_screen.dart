import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/utils/base/constants.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import '../../controllers/meeting_controller.dart';

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
              backgroundColor: context.theme.cardColor,
              title: const Text("الخروج من المكالمه",
                  style: TextStyle(color: Colors.white70)),
              content: const Text(
                  "يمكنك الخروج من المكالمه و الرجوع في اي وقت لاحق",
                  style: TextStyle(color: Colors.white70)),
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
    return WillPopScope(
      onWillPop: () async {
        _handelExitFromMeeting(ref);

        return true;
      },
      child: SafeArea(
        child: ZegoUIKitPrebuiltVideoConference(
          appID: AppConstants.appId,
          appSign: AppConstants.appSign,
          userID: ref.read(authControllerProvider).userInfo.uid,
          userName: ref.read(authControllerProvider).userInfo.displayName!,
          conferenceID: channelId,
          config: config,
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
