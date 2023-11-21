import 'dart:typed_data';

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/repositories/meeting_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meetingControllerProvider = Provider((ref) {
  final meetingRepo = ref.watch(meetingRepoProvider);
  return MeetingController(ref, meetingRepo);
});

class MeetingController {
  final MeetingRepo meetingRepo;
  final ProviderRef ref;
  MeetingController(this.ref, this.meetingRepo);
  //toggle meeting features
  void get toggleMicEnabled => meetingRepo.toggleMic;
  void get toggleCamEnabled => meetingRepo.toggleCam;
  void get toggleScreenShareEnabled => meetingRepo.toggleScreenShare;
  //meeting start
  Future<void> startMeeting({
    required String title,
    required bool isBrodcater,
    required String channelId,
  }) =>
      meetingRepo.startMeeing(title, isBrodcater, channelId);
}
