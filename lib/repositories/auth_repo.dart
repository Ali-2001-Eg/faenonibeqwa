// ignore_for_file: deprecated_member_use, unused_import, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class AuthRepo extends ChangeNotifier {
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
    notifyListeners();
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
  Future<UserModel?> get getUserData async {
    UserModel? user;
    var userData =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<User?> user() async => auth.currentUser;

  //get photo url
  String get getPhotoUrl => ref.watch(userDataProvider).value!.photoUrl;

  //name
  String get getName => ref.watch(userDataProvider).value!.name;

  //check role
  bool get isAdmin => ref.watch(userDataProvider).value!.isAdmin;

  bool get isPremium => ref.watch(userDataProvider).value!.isPremium;

  Future<void> signout() async {
    try {
      auth.signOut();
    } catch (e) {
      print('sign out $e');
    }
  }

  Future signUp(
      String email, String password, String username, String image) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ref.read(displayName.state).update((state) => username);
      ref.read(displayEmail.state).update((state) => email);
      ref.read(displayPhotoUrl.state).update((state) => image);
      auth.currentUser!.updateProfile(displayName: ref.read(displayName));
      await auth.currentUser!.reload();
      notifyListeners();
      _saveCredentials();
    } catch (e) {
      print('error');
    }
  }

  Future login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {
        print('e.code is ${e.code}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<bool> premiumAccount() => firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .snapshots()
          .map((query) {
        bool premium = false;
        if (query.exists) {
          premium = query.data()!['premium'];
        }
        return premium;
      });
}

//provider
final authRepoProvider = Provider<AuthRepo>(
    (ref) => AuthRepo(FirebaseAuth.instance, FirebaseFirestore.instance, ref));
//state providers
final displayName = StateProvider<String>((ref) => '');
final displayEmail = StateProvider<String>((ref) => '');
final displayPhotoUrl = StateProvider<String>((ref) => '');
//create admin الخطوه الجايه لما اعمل
final isAdmin = StateProvider<bool>((ref) => false);

final premiumAccount = StreamProvider<bool>((ref) {
  final stream = ref.read(authRepoProvider).premiumAccount();
  return stream;
});
