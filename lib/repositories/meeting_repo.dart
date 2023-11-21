// ignore_for_file: deprecated_member_use, unused_import

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/models/meeting_model.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/providers/storage_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> startMeeing(
      String title, bool isBrodcater, String channelId) async {
    try {
      if (title.isNotEmpty && channelId.isNotEmpty) {
        MeetingModel meeting = MeetingModel(
          title: title,
          isBrodcater: isBrodcater,
          uid: auth.currentUser!.uid,
          username: auth.currentUser!.displayName!,
          startedAt: DateTime.now(),
          viewers: 1,
          channelId: channelId,
        );
        await firestore
            .collection('meeting')
            .doc(auth.currentUser!.uid)
            .set(meeting.toMap());
      } else {
        print('fill all fields');
      }
    } catch (e) {
      print('error $e');
    }
  }
}

final meetingRepoProvider = Provider((ref) =>
    MeetingRepo(ref, FirebaseAuth.instance, FirebaseFirestore.instance));
final micEnabled = StateProvider<bool>((ref) => false);
final camEnabled = StateProvider<bool>((ref) => false);
final shareScreenEnabled = StateProvider<bool>((ref) => false);
