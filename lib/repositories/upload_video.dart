// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoRepo {
  final ProviderRef ref;
  UploadVideoRepo({
    required this.ref,
  });
  final picker = ImagePicker();
  Future pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref.read(videoProvider.notifier).state = File(pickedFile.path);
    }
  }

  String downloadURL = '';

  Future uploadVideo() async {
    if (ref.read(videoProvider) == null) return;
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');

      UploadTask uploadTask = storageReference.putFile(
          File(await compressVideoFile(ref.read(videoProvider)!.path)));

      await uploadTask.whenComplete(() => print('Video uploaded'));

      // Get the download URL of the uploaded video
      downloadURL = await storageReference.getDownloadURL();

      log('Download URL: $downloadURL');
    } catch (e) {
      log('Error uploading video: $e');
    }
  }

  Future compressVideoFile(String path) async {
    final compressVideoFilePath = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.LowQuality,
    );
    return compressVideoFilePath!.path;
  }

  getImageComprees() async {
    final image =
        await VideoCompress.getFileThumbnail(ref.read(videoProvider)!.path);
    return image;
  }

  clearVideo() {
    ref.read(videoProvider.notifier).state = null;
  }
}

final uploadVideoRepoProvider = Provider((ref) => UploadVideoRepo(ref: ref));
final videoProvider = StateProvider<File?>((ref) => null);

