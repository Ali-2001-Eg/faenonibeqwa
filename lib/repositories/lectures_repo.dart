// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use, avoid_print
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

import 'package:faenonibeqwa/models/lectures_model.dart';

import '../utils/base/app_helper.dart';
import '../utils/providers/app_providers.dart';

class LecturesRepo {
  final ProviderRef ref;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  LecturesRepo({
    required this.ref,
    required this.firestore,
    required this.auth,
  });
  final picker = ImagePicker();
  Future pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref.read(videoProvider.notifier).state = File(pickedFile.path);
    }
  }

  Future<void> uploadVideo({
    required String name,
    required File video,
  }) async {
    ref.read(isLoading.state).update((state) => true);
    try {
      String thumbnailURL = '';
      String downloadURL = '';
      Reference lectureRef = FirebaseStorage.instance
          .ref()
          .child('lectures/${DateTime.now().millisecondsSinceEpoch}.mp4');
      Reference thumbnailRef = FirebaseStorage.instance.ref().child(
          'videos/${DateTime.now().millisecondsSinceEpoch}/thumbnail.png');

      UploadTask uploadTask =
          lectureRef.putFile(File(await _compressVideoFile(video.path)));
      UploadTask uploadThumbnail =
          thumbnailRef.putFile(await _thumbnail(video));

      await uploadTask.whenComplete(() => print('Video uploaded'));
      await uploadThumbnail.whenComplete(() => print('Thumbnail uploaded'));

      // Get the download URL of the uploaded video
      downloadURL = await lectureRef.getDownloadURL();
      thumbnailURL = await thumbnailRef.getDownloadURL();
      String lectureId = const Uuid().v1();
      final LecturesModel lecture = LecturesModel(
        name: name,
        id: lectureId,
        lectureUrl: downloadURL,
        lectureThumbnail: thumbnailURL,
        audienceUid: const [],
      );
      firestore.collection('lectures').doc(lectureId).set(lecture.toMap());
      log(downloadURL);
      ref.read(isLoading.state).update((state) => false);
    } catch (e) {
      log('Error uploading video: $e');
      ref.read(isLoading.state).update((state) => false);
    }
  }

  Future _compressVideoFile(String path) async {
    final compressVideoFilePath = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.LowQuality,
    );
    return compressVideoFilePath!.path;
  }

  Future<File> _thumbnail(File video) async {
    final image = await VideoCompress.getFileThumbnail(video.path);
    return image;
  }

  Stream<List<LecturesModel>> get videos =>
      firestore.collection('lectures').snapshots().map((query) {
        final List<LecturesModel> lectures = [];
        if (query.docs.isNotEmpty) {
          for (var video in query.docs) {
            lectures.add(LecturesModel.fromMap(video.data()));
          }
        }
        return lectures;
      });

  Future<void> addUserToVideoAudience(String lectureId) async {
    await firestore.collection('lectures').doc(lectureId).update({
      'audienceUid': FieldValue.arrayUnion([auth.currentUser!.uid])
    });
  }

  Stream<num> lecturesWatched() async* {
    int lecturesNo = 0;
    var lectureDocs = await firestore.collection('lectures').get();
    for (var element in lectureDocs.docs) {
      if (element.data().isNotEmpty) {
        print('not empty');
        if (element.data()['audienceUid'].contains(auth.currentUser!.uid)) {
          print('added');

          lecturesNo++;
        }
      }
    }
    yield (lecturesNo/lectureDocs.docs.length)*100;
  }
}

final uploadVideoRepoProvider = Provider((ref) => LecturesRepo(
      ref: ref,
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));
final videoProvider = StateProvider<File?>((ref) => null);

class LectureVideoNotifier extends StateNotifier<File?> {
  LectureVideoNotifier(super.state);
  Future<void> pickFile(BuildContext context) async {
    state = await AppHelper.pickVideo(context);
  }

  Future<void> pickImage(BuildContext context) async {
    state = await AppHelper.pickImage(context);
  }
}

class PdfPathNotifier extends StateNotifier<String?> {
  PdfPathNotifier(super.state);
  Future<void> pickFile(BuildContext context) async {
    state = await AppHelper.pickFile(context);
  }
}
