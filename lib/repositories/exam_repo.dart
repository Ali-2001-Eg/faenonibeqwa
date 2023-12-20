import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/models/exam_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExamRepo {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ExamRepo({required this.auth, required this.firestore});
}

var examData = StateProvider<ExamModel?>((ref) => null);
