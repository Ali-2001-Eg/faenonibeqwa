// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/models/lectures_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

import '../utils/base/app_helper.dart';
import '../utils/providers/app_providers.dart';

class LecturesRepo {
  final ProviderRef ref;
  final FirebaseFirestore firestore;
  LecturesRepo({
    required this.ref,
    required this.firestore,
  });
  final picker = ImagePicker();
  Future pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref.read(videoProvider.notifier).state = File(pickedFile.path);
    }
  }

  String downloadURL = '';

  Future<void> uploadVideo({
    required String name,
    required File video,
  }) async {
    ref.read(isLoading.notifier).update((state) => true);
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');

      UploadTask uploadTask =
          storageReference.putFile(File(await compressVideoFile(video.path)));

      await uploadTask.whenComplete(() => print('Video uploaded'));

      // Get the download URL of the uploaded video
      downloadURL = await storageReference.getDownloadURL();
      String lectureId = const Uuid().v1();
      final LecturesModel lecture = LecturesModel(
        name: name,
        id: lectureId,
        lectureUrl: downloadURL,
        lectureThumbnail: (await thumbnail(video)).path,
        audienceUid: const [],
      );
      firestore.collection('lectures').doc(lectureId).set(lecture.toMap());
      log(downloadURL);
      ref.read(isLoading.notifier).update((state) => false);
    } catch (e) {
      log('Error uploading video: $e');
      ref.read(isLoading.notifier).update((state) => false);
    }
  }

  Future compressVideoFile(String path) async {
    final compressVideoFilePath = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.LowQuality,
    );
    return compressVideoFilePath!.path;
  }

  Future<File> thumbnail(File video) async {
    final image = await VideoCompress.getFileThumbnail(video.path);
    return image;
  }

  clearVideo() {
    ref.read(videoProvider.notifier).state = null;
  }
}

final uploadVideoRepoProvider = Provider(
    (ref) => LecturesRepo(ref: ref, firestore: FirebaseFirestore.instance));
final videoProvider = StateProvider<File?>((ref) => null);

class LectureVideoNotifier extends StateNotifier<File?> {
  LectureVideoNotifier(super.state);
  Future<void> pickVideo(BuildContext context) async {
    state = await AppHelper.pickVideo(context);
  }
}

class PdfPathNotifier extends StateNotifier<String?> {
  PdfPathNotifier(super.state);
  Future<void> pickFile(BuildContext context) async {
    state = await AppHelper.pickFile(context);
  }
}
