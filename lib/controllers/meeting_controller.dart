import 'package:faenonibeqwa/models/meeting_model.dart';
import 'package:faenonibeqwa/repositories/meeting_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class MeetingController {
  final MeetingRepo meetingRepo;
  final ProviderRef ref;
  MeetingController(this.ref, this.meetingRepo);

  //meeting start
  Future<void> startMeeting({
    required String title,
    required bool isBrodcater,
    required String channelId,
  }) =>
      meetingRepo.startMeeing(title, isBrodcater, channelId);
  //get live feeds
  Stream<List<MeetingModel>> get feeds => meetingRepo.feeds;
  //join meeting
  Future<void> joinMeeting(String channelId) =>
      meetingRepo.joinMeeting(channelId);
  //leave meeting
  Future<void> leaveMeeting(String channelId) =>
      meetingRepo.leaveMeeting(channelId);
  //end meeting
  Future<void> endMeeting(String channelId) =>
      meetingRepo.endMeeting(channelId);
}
