// ignore_for_file: deprecated_member_use, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/models/meeting_model.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:videosdk/videosdk.dart';

import '../controllers/auth_controller.dart';
import '../utils/base/constants.dart';
import '../utils/shared/data/api_client.dart';
import '../utils/shared/widgets/snackbar.dart';

class MeetingRepo extends ChangeNotifier {
  final ProviderRef ref;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  MeetingRepo(this.ref, this.auth, this.firestore);

  void get toggleMic => _toggleMeetingFeatures(micEnabled.state);
  void get toggleCam => _toggleMeetingFeatures(camEnabled.state);
  void get toggleScreenShare =>
      _toggleMeetingFeatures(shareScreenEnabled.state);

  void _toggleMeetingFeatures(ProviderListenable stateProvider) {
    ref.read(stateProvider).update((state) => !state);
    notifyListeners();
  }

  Future<void> createMeeting(BuildContext context) async {
    // call api to create meeting and then navigate to MeetingScreen with meetingId,token
    await ApiClient.createMeeting().then((meetId) async {
      if (kDebugMode) {
        print('meeting id is  $meetId');
      }
      MeetingModel meeting = MeetingModel(
        id: meetId,
        admin: await ref.read(authControllerProvider).getName,
        adminPhotoUrl: await ref.read(authControllerProvider).getPhotoUrl,
        timeEnded: false,
        audience: [auth.currentUser!.uid],
      );
      firestore.collection('meetings').doc(meetId).set(meeting.toMap());
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MeetingScreen(
              conferenceID: meetId,
              token: AppConstants.videosdkToken,
            ),
          ),
        );
      }
    });
  }

  Future<void> joinMeeting(BuildContext context, String meetingId) async {
    var re = RegExp("\\w{4}\\-\\w{4}\\-\\w{4}");
    // check meeting id is not null or invaild
    // if meeting id is vaild then navigate to MeetingScreen with meetingId,token
    if (meetingId.isNotEmpty && re.hasMatch(meetingId)) {
      await firestore.collection('meetings').doc(meetingId).update({
        'audience': FieldValue.arrayUnion([auth.currentUser!.uid]),
      });
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MeetingScreen(
              conferenceID: meetingId,
              token: AppConstants.videosdkToken,
            ),
          ),
        );
      }
    } else {
      customSnackbar(
        context: context,
        text: "لا توجد اي غرف بالرمز $meetingId",
      );
    }
  }

  Future<void> endMeeeting(Room room, BuildContext context) async {
    await firestore
        .collection('meetings')
        .doc(room.id)
        .update({'timeEnded': true});
    room.end();
    if (context.mounted) Navigator.popUntil(context, (route) => false);
  }
}

final meetingRepoProvider = Provider((ref) =>
    MeetingRepo(ref, FirebaseAuth.instance, FirebaseFirestore.instance));
final micEnabled = StateProvider<bool>((ref) => false);
final camEnabled = StateProvider<bool>((ref) => false);
final shareScreenEnabled = StateProvider<bool>((ref) => false);
