// ignore_for_file: avoid_print

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/base/app_constants.dart';
import 'package:faenonibeqwa/utils/base/dark_theme.dart';
import 'package:faenonibeqwa/utils/base/light_theme.dart';
import 'package:faenonibeqwa/utils/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaymobPayment.instance.initialize(
    apiKey: AppConstants.apiKey,
    integrationID: AppConstants.integrationId,
    iFrameID: 787143,
  );
  _initAwesomeLocalNotifications();
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  String? token = await FirebaseMessaging.instance.getToken();
  print('token is $token');
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('message from background message: ${message.data}');
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void _initAwesomeLocalNotifications() {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        
      ),
    ],
    debug: true,
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
              home: Scaffold(
                body: ref.watch(userDataProvider).when(
                  data: (user) {
                    print('email is ${user?.email}');
                    print('displayname is ${user?.name}');
                    print('is admin ${user?.isAdmin}');
                    if (user == null) {
                      return LoginScreen();
                    }

                    return const MainScreen();
                  },
                  error: (error, stackTrace) {
                    if (kDebugMode) {
                      print('error is ${error.toString()}');
                    }
                    return Scaffold(
                      body: Center(
                          child: Text(
                              'This page doesn\'t exist because ${error.toString()}')),
                    );
                  },
                  loading: () {
                    return Scaffold(body: Container());
                  },
                ),
              ));
        });
  }
}
