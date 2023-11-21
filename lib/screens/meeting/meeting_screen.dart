import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/utils/base/constants.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class MeetingScreen extends ConsumerStatefulWidget {
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
  ConsumerState<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends ConsumerState<MeetingScreen> {
  

 

  @override
  Widget build(BuildContext context) {
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
      title: widget.title,
      buttons: <ZegoMenuBarButtonName>[
        ZegoMenuBarButtonName.showMemberListButton,
        ZegoMenuBarButtonName.switchCameraButton,
        if (widget.isBrodcaster)
          ZegoMenuBarButtonName.toggleScreenSharingButton,
      ],
    );
    var config = ZegoUIKitPrebuiltVideoConferenceConfig()
      ..layout = ZegoLayout.gallery(
          // isSmallViewDraggable: false,
          // smallViewMargin: const EdgeInsets.all(10),
          // smallViewPosition: ZegoViewPosition.bottomLeft,
          // smallViewSize: Size(30, 40),
          // switchLargeOrSmallViewByClick: false,
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
        return true;
      },
      child: SafeArea(
        child: ZegoUIKitPrebuiltVideoConference(
            appID: AppConstants.appId,
            appSign: AppConstants.appSign,
            userID: ref.read(authControllerProvider).userInfo.uid,
            userName: ref.read(authControllerProvider).userInfo.displayName!,
            conferenceID: widget.channelId,
            config: config),
      ),
    );
  }

}
