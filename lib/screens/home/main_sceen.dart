// ignore_for_file: deprecated_member_use

import 'package:faenonibeqwa/screens/home/settings_screen.dart';
import 'package:faenonibeqwa/screens/trip/trips_screen.dart';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/providers/home_provider.dart';
import 'events.screen.dart';
import 'home_screen.dart';

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
          EventsScreen(),
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: context.theme.cardColor),
              label: 'الرئيسيه',
              activeIcon: Icon(
                Icons.home_filled,
                color: context.theme.hoverColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.rocket, color: context.theme.cardColor),
              label: 'الرحلات',
              activeIcon: Icon(
                Icons.rocket_launch,
                color: context.theme.hoverColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.moving_sharp, color: context.theme.cardColor),
              label: 'نشاطك',
              activeIcon: Icon(
                Icons.moving_outlined,
                color: context.theme.hoverColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: context.theme.cardColor),
              label: 'الاعدادات',
              activeIcon: Icon(
                Icons.settings_outlined,
                color: context.theme.hoverColor,
              )),
        ],
      ),
    );
  }
}
