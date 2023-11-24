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
import '../utils/base/app_constants.dart';
import '../utils/shared/data/api_client.dart';
import '../utils/shared/widgets/snackbar.dart';

class MeetingRepo extends ChangeNotifier {
  final ProviderRef ref;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  MeetingRepo(this.ref, this.auth, this.firestore);

 

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
          viewers: <String>[auth.currentUser!.uid],
          channelId: channelId,
        );
        await firestore
            .collection('meeting')
            .doc(channelId)
            .set(meeting.toMap());
      } else {
        print('fill all fields');
      }
    } catch (e) {
      print('error $e');
    }
  }

  Stream<List<MeetingModel>> get feeds =>
      firestore.collection('meeting').snapshots().map((query) {
        List<MeetingModel> meetings = [];
        for (var meeting in query.docs) {
          meetings.add(MeetingModel.fromMap(meeting.data()));
        }
        return meetings;
      });

  Future<void> joinMeeting(String channelId) async {
    var meetingData =
        await firestore.collection('meeting').doc(channelId).get();
    if (meetingData.data() != null) {
      await firestore.collection('meeting').doc(channelId).update({
        'viewers': FieldValue.arrayUnion([auth.currentUser!.uid]),
      });
    }
  }

  Future<void> leaveMeeting(String channelId) async {
    await firestore.collection('meeting').doc(channelId).update({
      'viewers': FieldValue.arrayRemove([auth.currentUser!.uid]),
    });
  }

  Future<void> endMeeting(String channelId) async {
    await firestore.collection('meeting').doc(channelId).delete();
  }
}

final meetingRepoProvider = Provider((ref) =>
    MeetingRepo(ref, FirebaseAuth.instance, FirebaseFirestore.instance));

