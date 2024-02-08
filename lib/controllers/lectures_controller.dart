import 'dart:io';

import 'package:faenonibeqwa/repositories/lectures_repo.dart';

import '../models/lectures_model.dart';

class LecturesController {
  final LecturesRepo lecturesRepo;

  LecturesController({required this.lecturesRepo});
  Stream<List<LecturesModel>> get videos => lecturesRepo.videos;
  Future<void> uploadLecture({required String name, required File video}) =>
      lecturesRepo.uploadVideo(name: name, video: video);
  Future<void> addUserToVideoAudience(String lectureId) async =>
      lecturesRepo.addUserToVideoAudience(lectureId);
}
