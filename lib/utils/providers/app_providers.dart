import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/controllers/paper_controller.dart';
import 'package:faenonibeqwa/repositories/lectures_repo.dart';
import 'package:faenonibeqwa/utils/typedefs/app_typedefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/exam_controller.dart';
import '../../controllers/lectures_controller.dart';
import '../../controllers/meeting_controller.dart';
import '../../controllers/payment_controller.dart';
import '../../controllers/trip_controller.dart';
import '../../models/user_model.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/exam_repo.dart';
import '../../repositories/meeting_repo.dart';
import '../../repositories/paper_repo.dart';
import '../../repositories/payment_repo.dart';
import '../../repositories/trip_repo.dart';
import 'home_provider.dart';
import 'storage_provider.dart';

//providers
final authRepoProvider = Provider<AuthRepo>(
    (ref) => AuthRepo(FirebaseAuth.instance, FirebaseFirestore.instance, ref));
final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepoProvider);
  return AuthController(authRepo: authRepository);
});

final examRepoProvider = Provider((ref) => ExamRepo(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref));
final examControllerProvider = Provider((ref) {
  final examRepo = ref.read(examRepoProvider);
  return ExamController(ref: ref, examRepo: examRepo);
});
final meetingRepoProvider = Provider((ref) =>
    MeetingRepo(ref, FirebaseAuth.instance, FirebaseFirestore.instance));

final meetingControllerProvider = Provider((ref) {
  final meetingRepo = ref.watch(meetingRepoProvider);
  return MeetingController(ref, meetingRepo);
});

final paymentRepoProvider = Provider((ref) =>
    PaymentRepo(ref, FirebaseFirestore.instance, FirebaseAuth.instance));

final paymentControllerProvider = Provider((ref) {
  return PaymenController(ref.read(paymentRepoProvider));
});
final tripRepoProvider = Provider(
    (ref) => TripRepository(firestore: FirebaseFirestore.instance, ref: ref));

final tripControllerProvider = Provider((ref) {
  final tripRepo = ref.read(tripRepoProvider);
  return TripController(tripRepo);
});
final lecturesPepoProvider = Provider(
    (ref) => LecturesRepo(firestore: FirebaseFirestore.instance, ref: ref));

final lecturesControllerProvider = Provider((ref) {
  final lecturesRepo = ref.read(lecturesPepoProvider);
  return LecturesController(lecturesRepo: lecturesRepo);
});
final paperRepoProvider = Provider(
    (ref) => PaperRepo(firestore: FirebaseFirestore.instance, ref: ref));

final paperControllerProvider = Provider((ref) {
  final papeRepo = ref.read(paperRepoProvider);
  return PaperController(
    paperRepo: papeRepo,
  );
});

final firebaseStorageRepoProvider = Provider(
  (ref) => FirebaseStorageRepo(FirebaseStorage.instance),
);

//state providers
final currentIndex = StateProvider<int>((ref) => 0);
final displayName = StateProvider<String>((ref) => '');
final displayEmail = StateProvider<String>((ref) => '');
final displayPhotoUrl = StateProvider<String>((ref) => '');
final isAdmin = StateProvider<bool>((ref) => false);

//state notifiers providers
final homeNotifierProvider =
    StateNotifierProvider<HomeProvider, int>((ref) => HomeProvider(0));

final videoNotifier =
    StateNotifierProvider.autoDispose<LectureVideoNotifier, File?>(
        (ref) => LectureVideoNotifier(null));
final pdfPathNotifier =
    StateNotifierProvider.autoDispose<PdfPathNotifier, String?>(
        (ref) => PdfPathNotifier(null));
//future providers
//used tuple to pass two parameters
final questionsProvider =
    FutureProvider.family((ref, QuestionParameters parameters) {
  final examConrtoller = ref.read(examControllerProvider);
  return examConrtoller.questions(parameters);
});

final answersProvider =
    FutureProvider.family((ref, AnswersParameters parameters) {
  final examConrtoller = ref.read(examControllerProvider);
  return examConrtoller.answers(parameters);
});

//stream providers

final userDataProvider = StreamProvider<UserModel?>((ref) {
  final stream = ref.read(authControllerProvider).getUserData;
  return stream;
});

final questionIdsStream = StreamProvider.family((ref, String examId) {
  final provider = ref.watch(examControllerProvider);
  return provider.questionIds(examId);
});

final answerCardStream =
    StreamProvider.family((ref, AnswersIdentiferParameters parameters) {
  final stream =
      ref.watch(examControllerProvider).getAnswerIdentifier(parameters);
  return stream;
});

final examListStream = StreamProvider((ref) {
  final stream = ref.watch(examControllerProvider).exams;
  return stream;
});

final tripStream = StreamProvider((ref) {
  final stream = ref.watch(tripControllerProvider).getTrip();
  return stream;
});

final feedsStream = StreamProvider((ref) {
  final stream = ref.watch(meetingControllerProvider).feeds;
  return stream;
});
