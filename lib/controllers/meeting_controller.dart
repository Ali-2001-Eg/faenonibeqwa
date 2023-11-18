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
  Future<String> startMeeting(
          BuildContext context, String title, Uint8List? image) =>
      meetingRepo.startMeeting(context, title, image);
  //chat
  Future<void> chat(String text, String id, BuildContext context) async => ref
      .read(userDataProvider)
      .whenData((value) => meetingRepo.chat(text, id, context));
  //update viewer count
  Future<void> updateViewCount(String id, bool isIncrease) async => ref
      .read(userDataProvider)
      .whenData((value) => meetingRepo.updateViewCount(id, isIncrease));
  //end meeting
  Future<void> endMeeting(String channelId) async => ref
      .read(userDataProvider)
      .whenData((value) => meetingRepo.endMeeting(channelId));
  
}
