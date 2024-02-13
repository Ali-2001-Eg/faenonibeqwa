// ignore_for_file: deprecated_member_use, unused_import, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/models/user_model.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import '../utils/providers/app_providers.dart';

class AuthRepo {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  AuthRepo(this.auth, this.firestore, this.ref);

//google sign in
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> signInWithGoogleAccount() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    ref
        .read(displayName.state)
        .update((state) => googleSignInAccount!.displayName!);
    ref.read(displayEmail.state).update((state) => googleSignInAccount!.email);
    ref.read(displayPhotoUrl.state).update((state) =>
        googleSignInAccount!.photoUrl ??
        'https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg');
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credentials = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    await auth.signInWithCredential(
      credentials,
    );
    //firestore
    _saveCredentials();
  }

  //firestore
  Future<void> _saveCredentials() async {
    try {
      // String userId = const Uuid().v1();
      UserModel user = UserModel(
          name: ref.read(displayName),
          uid: auth.currentUser!.uid,
          photoUrl: ref.read(displayPhotoUrl),
          email: ref.read(displayEmail),
          isAdmin: false,
          isPremium: false,
          notificationToken: (await FirebaseMessaging.instance.getToken())!);
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(user.toMap());
      print('email is ${user.email}');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //get user data

  Stream<UserModel?> get getUserData => firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .snapshots()
          .map((query) {
        UserModel? user;
        if (query.exists) {
          user = UserModel.fromMap(query.data()!);
        }
        return user;
      });

  Future<User?> user() async => auth.currentUser;

  //get photo url
  String get getPhotoUrl => ref.read(userDataProvider).when(
      data: (data) => data!.photoUrl,
      error: (error, s) {
        throw error;
      },
      loading: () => '');

  //name
  String get getName => ref.read(userDataProvider).when(
      data: (data) => data!.name,
      error: (error, s) {
        throw error;
      },
      loading: () => '');
  String get getEmail => ref.read(userDataProvider).when(
      data: (data) => data!.email,
      error: (error, s) {
        throw error;
      },
      loading: () => '');

  //check role
  bool get isAdmin => ref.read(userDataProvider).when(
      data: (data) => data!.isAdmin,
      error: (error, s) {
        throw error;
      },
      loading: () => false);

  bool get isPremium => ref.read(userDataProvider).when(
      data: (data) => data!.isPremium,
      error: (error, s) {
        throw error;
      },
      loading: () => false);

  Future<void> signout() async {
    try {
      auth.signOut();
    } catch (e) {
      print('sign out $e');
    }
  }

  Future signUp(String email, String password, String username) async {
    try {
      ref.read(isLoading.notifier).update((state) => true);

      await Future.delayed(const Duration(seconds: 5), () {
        print('loading');
      });
      // await auth.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // auth.currentUser!.updateProfile(displayName: ref.read(displayName));
      // await auth.currentUser!.reload();

      // _saveCredentials();
    } catch (e) {
      print('error');
    }
    ref.read(isLoading.notifier).update((state) => false);
  }

  Future login(String email, String password, BuildContext context) async {
    try {
      ref.read(isLoading.notifier).update((state) => true);

      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          AppHelper.customSnackbar(context: context, title: 'الحساب غير موجود');
        }
      } else if (e.code == 'wrong-password') {
        print('e.code is ${e.code}');
        if (context.mounted) {
          AppHelper.customSnackbar(
              context: context, title: 'كلمه المرور خاطئه');
        }
      } else {
        if (context.mounted) {
          AppHelper.customSnackbar(
              context: context,
              title: 'ادخل بيانات حسابك الصحيحه او قم بعمل حساب أولا');
        }
      }
    } catch (e) {
      print(e.toString());
      if (context.mounted) {
        AppHelper.customSnackbar(
            context: context, title: 'catch ${e.toString()}');
      }
    }
    ref.read(isLoading.notifier).update((state) => false);
  }

  Future<void> editPhoto(String filePath) async {
    String imageUrl = await ref
        .read(firebaseStorageRepoProvider)
        .storeFileToFirebaseStorage(
            'users', auth.currentUser!.uid, File(filePath));
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'photoUrl': imageUrl});
  }
}
