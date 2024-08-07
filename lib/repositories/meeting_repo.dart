// ignore_for_file: deprecated_member_use, unused_import

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/models/meeting_model.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/providers/storage_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../controllers/auth_controller.dart';
import '../utils/base/app_constants.dart';
import '../utils/shared/data/api_client.dart';

class MeetingRepo extends ChangeNotifier {
  final ProviderRef ref;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  MeetingRepo(this.ref, this.auth, this.firestore);

  Future<void> startMeeing(String title, String channelId) async {
    try {
      if (title.isNotEmpty && channelId.isNotEmpty) {
        MeetingModel meeting = MeetingModel(
          title: title,
          // isBrodcater: isBrodcater,
          uid: auth.currentUser!.uid,
          username: auth.currentUser!.displayName!,
          endsAt: DateTime.now().add(const Duration(days: 1)),
          viewers: <String>[auth.currentUser!.uid],
          channelId: channelId,
        );
        await firestore
            .collection('meeting')
            .doc(channelId)
            .set(meeting.toMap());
      } else {
        if (kDebugMode) {
          print('fill all fields');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('error $e');
      }
    }
  }

  Stream<List<MeetingModel>> get feeds =>
      firestore.collection('meeting').snapshots().map((query) {
        List<MeetingModel> meetings = [];
        for (var meeting in query.docs) {
          MeetingModel meetingModel = MeetingModel.fromMap(meeting.data());
          if (meetingModel.endsAt.isAfter(DateTime.now())) {
            meetings.add(meetingModel);
          }
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
    var meetingData =
        await firestore.collection('meeting').doc(channelId).get();
    if (meetingData.data() != null) {
      await firestore.collection('meeting').doc(channelId).update({
        'viewers': FieldValue.arrayRemove([auth.currentUser!.uid]),
      });
    }
  }

  Future<void> endMeeting(String channelId) async {
    firestore.collection('meeting').doc(channelId).update({
      'startedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Future<void> _addStreamToUser(String channelId) async {
  //   final meetingData =
  //       await firestore.collection('meeting').doc(channelId).get();
  //   if (meetingData.exists) {
  //     final bool userJoined =
  //         meetingData.data()!['viewers'].contains(auth.currentUser!.uid);
  //     if (!userJoined) {
  //       await firestore.collection('users').doc(auth.currentUser!.uid).update({
  //         'streamsJoined': FieldValue.increment(1),
  //       });
  //     }
  //   }
  // }

  Stream<num> get userPresence async* {
    num userPresence = 0;
    var meetingDocs = await firestore.collection('meeting').get();
    for (var element in meetingDocs.docs) {
      if (element.exists) {
        if (element.data()['viewers'].contains(auth.currentUser!.uid)) {
          userPresence++;
        }
      }
    }
    if (meetingDocs.docs.length.isNaN) {
      yield 0;
    }
    yield (userPresence / meetingDocs.docs.length) * 100;
  }
}
