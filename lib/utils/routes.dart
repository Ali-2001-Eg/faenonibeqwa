import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:flutter/material.dart';

import '../screens/home/main_sceen.dart';
import '../screens/meeting/create_meeting_screen.dart';
import 'base/error_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return _buildNewRoute( LoginScreen());
    case MainScreen.routeName:
      return _buildNewRoute(const MainScreen());
    case CreateMeetingScreen.routeName:
      return _buildNewRoute(const CreateMeetingScreen());
    case MeetingScreen.routeName:
      final args = settings.arguments as Map<String, String>;
      final channelId = args['channelId'] as String;
      final isBroadcaster = args['isBroadcaster'] as bool;
      return _buildNewRoute(MeetingScreen(
        channelId: channelId,
        isBroadcaster: isBroadcaster,
      ));
    default:
      return _buildNewRoute(const ErrorScreen());
  }
}

MaterialPageRoute<dynamic> _buildNewRoute(Widget screen) {
  return MaterialPageRoute(
    builder: (context) => screen,
  );
}
