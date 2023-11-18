// ignore_for_file: deprecated_member_use, unused_import

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

  Future<String> startMeeting(
      BuildContext context, String title, Uint8List? image) async {
    final user = await ref.read(authControllerProvider).user;
    print('user email is ${user?.email}');
    String channelId = '';
    try {
      if (title.isNotEmpty && user != null) {
        if (!((await firestore
                .collection('meeting')
                .doc('${user.uid}${user.displayName}')
                .get())
            .exists)) {
          String thumbnailUrl = '';
          if (image != null) {
            thumbnailUrl = await ref
                .read(firebaseStorageRepoProvider)
                .storeFileToFirebaseStorage(
                  'Meeting-thumbnails',
                  image,
                  user.uid,
                );
          } else {
            thumbnailUrl = '';
          }
          channelId = '${user.uid}${user.displayName}';

          MeetingModel meeting = MeetingModel(
            title: title,
            image: thumbnailUrl,
            uid: user.uid,
            username: user.displayName ?? '',
            viewers: 0,
            channelId: channelId,
            startedAt: DateTime.now(),
          );

          firestore.collection('meeting').doc(channelId).set(meeting.toMap());
        } else {
          if (context.mounted) {
            customSnackbar(
                context: context,
                text: 'Two Meeting cannot start at the same time.');
          }
        }
      }
    } on FirebaseException catch (e) {
      if (context.mounted) customSnackbar(context: context, text: e.message!);
    }
    return channelId;
  }

  Future<void> chat(String text, String id, BuildContext context) async {
    final user = await ref.read(authControllerProvider).user;

    try {
      String commentId = const Uuid().v1();
      await firestore
          .collection('meeting')
          .doc(id)
          .collection('comments')
          .doc(commentId)
          .set({
        'username': user!.displayName,
        'message': text,
        'uid': user.uid,
        'createdAt': DateTime.now(),
        'commentId': commentId,
      });
    } on FirebaseException catch (e) {
      if (context.mounted) customSnackbar(context: context, text: e.message!);
    }
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await firestore.collection('meeting').doc(id).update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> endMeeting(String channelId) async {
    try {
      QuerySnapshot snap = await firestore
          .collection('meeting')
          .doc(channelId)
          .collection('comments')
          .get();

      for (int i = 0; i < snap.docs.length; i++) {
        await firestore
            .collection('meeting')
            .doc(channelId)
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
      }
      await firestore.collection('meeting').doc(channelId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

final meetingRepoProvider = Provider((ref) =>
    MeetingRepo(ref, FirebaseAuth.instance, FirebaseFirestore.instance));
final micEnabled = StateProvider<bool>((ref) => false);
final camEnabled = StateProvider<bool>((ref) => false);
final shareScreenEnabled = StateProvider<bool>((ref) => false);
