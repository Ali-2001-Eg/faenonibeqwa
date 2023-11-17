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
  Future<UserModel?> get getUserData => authRepo.getUserData;
  Future<User?> get user => authRepo.user();
  Future<String> get getPhotoUrl => authRepo.getPhotoUrl;
  String get getName => authRepo.getName;
  User get userInfo => authRepo.auth.currentUser!;
}

final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepoProvider);
  return AuthController(authRepo: authRepository);
});

//future provider
final userDataProvider = FutureProvider<User?>((ref) async {
  final authController = ref.read(authControllerProvider);
  return authController.user;
});
