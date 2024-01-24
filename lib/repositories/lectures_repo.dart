import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LecturesRepo {
  final ProviderRef ref;
  final FirebaseFirestore firestore;

  LecturesRepo({required this.ref, required this.firestore});
}

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
