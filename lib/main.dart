// ignore_for_file: avoid_print

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/base/app_constants.dart';
import 'package:faenonibeqwa/utils/base/dark_theme.dart';
import 'package:faenonibeqwa/utils/base/light_theme.dart';
import 'package:faenonibeqwa/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'utils/providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true
      // option: set to false to disable working with http links (default: false)
      );
  await AwesomeNotifications().initialize(
    "resource://drawable/notification",
    [
      NotificationChannel(
        channelKey: 'firebase key',
        channelName: 'firebase channel',
        channelDescription: 'firebase for test',
        playSound: true,
        channelShowBadge: true,
      )
    ],
  );
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onBackgroundMessage((message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(10000),
        channelKey: 'firebase key',
        title: message.notification!.title,
        body: message.notification!.body,
      ),
    );
    print(message.data);

    if (message.notification != null) {
      print("body onBackgroundMessage ===========");
      print(message.notification!.body);
      print("body onBackgroundMessage ===========");
    }
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(10000),
        channelKey: 'firebase key',
        title: message.notification!.title,
        body: message.notification!.body,
      ),
    );
    print(message.data);

    if (message.notification != null) {
      print("body onMessage===========");
      print(message.notification!.body);
      print("body onMessage ===========");
    }
  });

  PaymobPayment.instance.initialize(
    apiKey: AppConstants.apiKey,
    integrationID: AppConstants.integrationId,
    iFrameID: 787143,
  );
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('message from background message: ${message.data}');
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.email);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Faenonibeqwa',
          theme: lightMode,
          darkTheme: darkMode,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) => generateRoute(settings),
          home: FirebaseAuth.instance.currentUser != null
              ? MainScreen()
              : LoginScreen(),
        );
      },
    );
  }
}
