// ignore_for_file: deprecated_member_use, unused_import, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/models/user_model.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../screens/home/main_sceen.dart';
import '../utils/providers/app_providers.dart';

class AuthRepo {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  AuthRepo(this.auth, this.firestore, this.ref);

  Future signUp(String email, String password, String username,
      BuildContext context) async {
    try {
      ref.read(isLoading.notifier).update((state) => true);

      // await Future.delayed(const Duration(seconds: 5), () {
      //   print('loading');
      // });
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user = UserModel(
          name: username,
          uid: auth.currentUser!.uid,
          photoUrl: '',
          email: email,
          isAdmin: false,
          isPremium: false,
          notificationToken: (await FirebaseMessaging.instance.getToken())!);
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(user.toMap());

      auth.currentUser!.updateProfile(displayName: username);
      await auth.currentUser!.reload();
    } catch (e) {
      if (context.mounted) {
        AppHelper.customSnackbar(
            context: context,
            title: e.toString(),
            snackbarPosition: ToastGravity.TOP);
      }
      print('error');
    }
    ref.read(isLoading.notifier).update((state) => false);
  }

  Future login(String email, String password, BuildContext context) async {
    try {
      ref.read(isLoading.notifier).update((state) => true);

      await auth.signInWithEmailAndPassword(email: email, password: password);
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.routeName, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          AppHelper.customSnackbar(
              context: context, title: ' هذا الحساب غير موجود');
        }
      } else if (e.code == 'wrong-password') {
        print('e.code is ${e.code}');
        if (context.mounted) {
          AppHelper.customSnackbar(
              context: context, title: 'كلمه المرور غير صحيحه');
        }
      }
    } catch (e) {
      print(e.toString());
      if (context.mounted) {
        AppHelper.customSnackbar(context: context, title: e.toString());
      }
    }
    ref.read(isLoading.notifier).update((state) => false);
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
      data: (data) {
        if (data == null) {
          return 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fstudent_354637&psig=AOvVaw3MqaKfajFyVXeKjn476gK3&ust=1709305183164000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCMjb1pTo0IQDFQAAAAAdAAAAABAE';
        }
        return data.photoUrl;
      },
      error: (error, s) {
        return "";
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

  Future<void> editPhoto(String filePath) async {
    TaskSnapshot snap = await FirebaseStorage.instance
        .ref()
        .child(auth.currentUser!.uid)
        .child(filePath)
        .putFile(File(filePath));
    String imageUrl = await snap.ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'photoUrl': imageUrl});
  }

  Stream<List<UserModel>> get users =>
      firestore.collection('users').snapshots().map((query) {
        List<UserModel> users = [];
        for (var user in query.docs) {
          if (user.exists) {
            users.add(UserModel.fromMap(user.data()));
          }
        }
        return users;
      });
}
