  // final _dbFireStoreUsers = FirebaseFirestore.instance.collection('users');
  // final _dbFireStoreNotification =
  //     FirebaseFirestore.instance.collection('notification');

  // Future<void> updateTokenFcm(String id, String tokenFcm) async {
  //   try {
  //     final document = _dbFireStoreUsers.doc(id);
  //     id = document.id;
  //     await document.update({
  //       'token': tokenFcm,
  //     });
  //     emit(UpdateTokeFcmSuccess());
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // String tokenFCM = '';
  // getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     tokenFCM = token!;
  //     updateTokenFcm(
  //       FirebaseAuth.instance.currentUser!.uid,
  //       token,
  //     );
  //     print(tokenFCM);
  //     emit(GetTokeFcmSuccess());
  //   });
  // }

  // Future<void> sendNotification(
  //   String token,
  //   String title,
  //   String body, {
  //   required NotifcationModel notifcationData,
  // }) async {
  //   try {
  //     http.Response response = await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=${firebaseMassgingServerKey}'
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': {
  //             'title': title,
  //             'body': body,
  //           },
  //           'priority': 'high',
  //           'data': notifcationData.toMap(),
  //           'to': token
  //         },
  //       ),
  //     );
  //     emit(NotificationSendedSuccess());
  //     if (response.statusCode == 200) {
  //       print("Yeh notificatin is sended");
  //     } else {
  //       print("Error");
  //     }
  //   } catch (e) {}
  // }

  // Future<void> saveNotificationToFireStore(
  //     NotifcationModel notificationModel) async {
  //   try {
  //     final document = _dbFireStoreNotification.doc();
  //     notificationModel.id = document.id;
  //     await document.set(notificationModel.toMap());
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // List<NotifcationModel> notifcationList = [];
  // getNotifications() {
  //   emit(GetNotificationsLoading());
  //   _dbFireStoreNotification
  //       .where('role', isEqualTo: 'user')
  //       .snapshots()
  //       .listen((event) {
  //     notifcationList.clear();
  //     event.docs
  //         .map((e) => notifcationList.add(NotifcationModel.fromMap(e.data())))
  //         .toList();
  //     emit(GetNotificationsSuccess());
  //   }).onError((e) {
  //     emit(GetNotificationsError());
  //     print(e.toString());
  //   });
  // }

  // Future<void> deleteSingleNotification(String id) async {
  //   try {
  //     final document = _dbFireStoreNotification.doc(id);
  //     await document.delete();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<void> deleteAllNotification() async {
  //   try {
  //     // Get all documents in the collection
  //     QuerySnapshot querySnapshot = await _dbFireStoreNotification.get();

  //     // Delete each document in the collection
  //     for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //       await documentSnapshot.reference.delete();
  //     }
  //     // final document = _dbFireStoreNotification.d;
  //     // await document.delete();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
