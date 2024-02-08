// ignore_for_file: deprecated_member_use, unused_import

import 'package:faenonibeqwa/screens/lectures/lectures_list_screen.dart';
import 'package:faenonibeqwa/screens/settings/settings_screen.dart';
import 'package:faenonibeqwa/screens/trip/trips_screen.dart';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/notification_repo.dart';
import '../../utils/providers/app_providers.dart';
import '../../utils/providers/home_provider.dart';
import '../exam/exams_list_screen.dart';
import 'home_screen.dart';

@immutable
class MainScreen extends ConsumerStatefulWidget {
  static const String routeName = '/home-screen';
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  String token = '';

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((tokenFcm) {
      setState(() {
        token = tokenFcm!;
      });
      print('===========');
      print(" ===========  ${token}");
      print('==============');
      NotificationRepo().updateTokenFcm(token);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //to rebuild the screen
    final selectedTabIndex = ref.watch(homeNotifierProvider);
    print(FirebaseAuth.instance.currentUser?.email);

    return Scaffold(
      body: IndexedStack(
        index: selectedTabIndex,
        children: const [
          HomeScreen(),
          LecturesListScreen(),
          ExamsListScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedTabIndex,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        onTap: (index) {
          //notifier to access home provider notifier
          ref.watch(homeNotifierProvider.notifier).changeIndex(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'الرئيسيه',
            // activeIcon: Icon(
            //   Icons.home_filled,
            //   color: context.theme.hoverColor,
            // ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.rocket,
            ),
            label: 'الرحلات',
            // activeIcon: Icon(
            //   Icons.rocket_launch,
            //   color: context.theme.hoverColor,
            // ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.text_snippet_outlined,
            ),
            label: 'الاختبارات',
            // activeIcon: Icon(
            //   Icons.moving_outlined,
            //   color: context.theme.hoverColor,
            // ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'حسابي',
            // activeIcon: Icon(
            //   Icons.settings_outlined,
            //   color: context.theme.hoverColor,
            // ),
          ),
        ],
      ),
    );
  }
}
