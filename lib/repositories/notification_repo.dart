import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../models/notification_model.dart';
import '../utils/base/app_constants.dart';

class NotificationRepo {
  final _dbFireStoreUsers = FirebaseFirestore.instance.collection('users');
  final _dbFireStoreNotification =
      FirebaseFirestore.instance.collection('notification');

  Future<void> updateTokenFcm(String tokenFcm) async {
    try {
      String id = FirebaseAuth.instance.currentUser!.uid;
      final document = _dbFireStoreUsers.doc(id);

      await document.update({
        'notificationToken': tokenFcm,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  String tokenFCM = '';
  getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      tokenFCM = token!;

      print(tokenFCM);
      // emit(GetTokeFcmSuccess());
    });
  }

  Future<void> sendNotification(
    String token,
    String title,
    String body, {
    required NotifcationModel notifcationData,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${AppConstants.fcmKey}'
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': {
              'title': title,
              'body': body,
            },
            'priority': 'high',
            'data': notifcationData.toMap(),
            'to': token
          },
        ),
      );
      // emit(NotificationSendedSuccess());
      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print("Error");
      }
    } catch (e) {}
  }

  Future<void> sendPremiumNotification(
    String title,
    String body, {
    required NotifcationModel? notifcationData,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${AppConstants.fcmKey}'
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': {
              'title': title,
              'body': body,
            },
            'priority': 'high',
            'data': notifcationData?.toMap(),
            'to': '/topics/premium'
          },
        ),
      );
      // emit(NotificationSendedSuccess());
      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print("Error");
      }
    } catch (e) {}
  }
}