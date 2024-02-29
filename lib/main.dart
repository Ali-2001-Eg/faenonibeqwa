import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/base/app_constants.dart';
import 'package:faenonibeqwa/utils/base/dark_theme.dart';
import 'package:faenonibeqwa/utils/base/light_theme.dart';
import 'package:faenonibeqwa/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/auth/login_screen.dart';

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PaymobPayment.instance.initialize(
    apiKey: AppConstants.apiKey,
    integrationID: AppConstants.integrationId,
    iFrameID: 787143,
  );
  _initAwesomeLocalNotifications();

  runApp(const ProviderScope(child: MyApp()));
}

void _initAwesomeLocalNotifications() async {
  await AwesomeNotifications().initialize(
    null,
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
  FirebaseMessaging.onBackgroundMessage((message) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(10000),
        channelKey: 'firebase key',
        title: message.notification!.title,
        body: message.notification!.body,
      ),
    );

    if (message.notification != null) {
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

    if (message.notification != null) {
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
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
            home: FirebaseAuth.instance.currentUser == null
                ? const LoginScreen()
                : const MainScreen(),
          );
        });
  }
}
