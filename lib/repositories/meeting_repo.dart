import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetingRepo extends ChangeNotifier {
  final ProviderRef ref;

  MeetingRepo(this.ref);

void get toggleMic =>_toggleMeetingFeatures(micEnabled.state);
void get toggleCam =>_toggleMeetingFeatures(camEnabled.state);
void get toggleScreenShare =>_toggleMeetingFeatures(shareScreenEnabled.state);

  void _toggleMeetingFeatures(ProviderListenable stateProvider) {
    ref.read(stateProvider).update((state) => !state);
    notifyListeners();
  }
}

final meetingRepoProvider = Provider((ref) => MeetingRepo(ref));
final micEnabled = StateProvider<bool>((ref) => false);
final camEnabled = StateProvider<bool>((ref) => false);
final shareScreenEnabled = StateProvider<bool>((ref) => false);
