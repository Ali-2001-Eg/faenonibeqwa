import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExamRepo{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ExamRepo({required this.auth, required this.firestore});
  
}