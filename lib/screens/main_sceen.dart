// ignore_for_file: deprecated_member_use, unused_import

import 'package:faenonibeqwa/screens/settings/settings_screen.dart';
import 'package:faenonibeqwa/screens/trip/trips_screen.dart';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/providers/home_provider.dart';
import 'exam/exams_list_screen.dart';
import 'home/home_screen.dart';

class MainScreen extends ConsumerWidget {
  static const String routeName = '/home-screen';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //to rebuild the screen
    final selectedTabIndex = ref.watch(homeIndexState.state).state;

    return Scaffold(
      body: IndexedStack(
        index: selectedTabIndex,
        children: const [
          HomeScreen(),
          TripsScreen(),
          ExamsListScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedTabIndex,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        onTap: (value) {
          ref.read(homeProvider).changeIndex(value);
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
