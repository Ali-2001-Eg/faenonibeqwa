// ignore_for_file: avoid_print

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/screens/main_sceen.dart';
import 'package:faenonibeqwa/screens/video/video_screen.dart';
import 'package:faenonibeqwa/screens/video/video_view_widget.dart';
import 'package:faenonibeqwa/utils/base/app_constants.dart';
import 'package:faenonibeqwa/utils/base/dark_theme.dart';
import 'package:faenonibeqwa/utils/base/light_theme.dart';
import 'package:faenonibeqwa/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/settings/exam_ui.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: Random().nextInt(10000),
      channelKey: 'firebase key',
      title: message.notification!.title,
      body: message.notification!.body,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PaymobPayment.instance.initialize(
    apiKey: AppConstants.apiKey,
    integrationID: AppConstants.integrationId,
    iFrameID: 787143,
  );
  _initAwesomeLocalNotifications();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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

  runApp(const ProviderScope(child: MyApp()));
}

void _initAwesomeLocalNotifications() {
  AwesomeNotifications().initialize(
    "resource://drawable/notification",
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
      ),
    ],
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        print('notification permission is granted');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            home: FirebaseAuth.instance.currentUser == null
                ? LoginScreen()
                : const VideoScreen(),
            // Scaffold(
            //   body: ref.watch(userDataProvider).when(
            //     data: (user) {
            //       // print('email is ${user?.email}');
            //       // print('displayname is ${user?.name}');
            //       // print('is admin ${user?.isAdmin}');
            //       if (FirebaseAuth.instance.currentUser == null) {
            //         return LoginScreen();
            //       }

            //       return const QuizUI();
            //     },
            //     error: (error, stackTrace) {
            //       if (kDebugMode) {
            //         print('error is ${error.toString()}');
            //       }
            //       return Scaffold(
            //         body: Center(
            //           child: Text(
            //             'This page doesn\'t exist because ${error.toString()}',
            //             style: TextStyle(color: Colors.black),
            //           ),
            //         ),
            //       );
            //     },
            //     loading: () {
            //       return Scaffold(body: Container());
            //     },
            //   ),
            // ),
          );
        });
  }
}
