// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repo.dart';

class AuthController {
  final AuthRepo authRepo;
  AuthController({
    required this.authRepo,
  });
  Future<void> signInWithGoggleAccount() async =>
      await authRepo.signInWithGoogleAccount();
  Future<UserModel?> get getUserData => authRepo.getUserData;
  Future<String> get getPhotoUrl => authRepo.getPhotoUrl;
  Future<String> get getName => authRepo.getName;
}

final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepoProvider);
  return AuthController(authRepo: authRepository);
});

//future provider
final userDataProvider = FutureProvider<UserModel?>((ref) async {
  final authController = ref.read(authControllerProvider);
  return authController.getUserData;
});
