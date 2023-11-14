import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/base/dark_theme.dart';
import 'package:faenonibeqwa/utils/base/light_theme.dart';
import 'package:faenonibeqwa/utils/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*  Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]); */
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            title: 'Faenonibeqwa',
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) => generateRoute(settings),
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: ref.watch(userDataProvider).when(
                  data: (user) {
                    if (user == null) {
                      return const LoginScreen();
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
              ),
            ),
          );
        });
  }
}
