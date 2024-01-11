// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final AuthRepo authRepo;
  AuthController({
    required this.authRepo,
  });
  Future<void> signInWithGoggleAccount() async =>
      await authRepo.signInWithGoogleAccount();
  Stream<UserModel?> get getUserData => authRepo.getUserData;
  Future<User?> get user => authRepo.user();
  String get getPhotoUrl => authRepo.getPhotoUrl;
  String get getName => authRepo.getName;
  bool get isAdmin => authRepo.isAdmin;
  bool get isPremium => authRepo.isPremium;
  User get userInfo => authRepo.auth.currentUser!;
  Future<void> get signout => authRepo.signout();
  Future<void> signup(
          String email, String password, String username, String image) =>
      authRepo.signUp(email, password, username, image);
  Future<void> login(String email, String password) =>
      authRepo.login(email, password);
}

final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepoProvider);
  return AuthController(authRepo: authRepository);
});

//future provider
final userDataProvider = StreamProvider<UserModel?>((ref) {
  final stream = ref.read(authControllerProvider).getUserData;
  return stream;
});
