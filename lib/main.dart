import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/base/dark_theme.dart';
import 'package:faenonibeqwa/utils/base/light_theme.dart';
import 'package:faenonibeqwa/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Faenonibeqwa',
            theme: lightMode(context),
            darkTheme: darkMode(context),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) => generateRoute(settings),
            home: const Directionality(
              textDirection: TextDirection.rtl,
              child: MainScreen(),
            ),
          );
        });
  }
}
