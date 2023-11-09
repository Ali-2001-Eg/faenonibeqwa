import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/base/constants.dart';
import 'package:flutter/material.dart';

import '../screens/home/main_sceen.dart';
import 'base/error_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MainScreen.routeName:
      return _buildNewRoute(const MainScreen());
    case MeetingScreen.routeName:
      final args = settings.arguments as Map<String, String>;
      final conferenceID = args['conferenceID'] as String;
      return _buildNewRoute(MeetingScreen(
        conferenceID: conferenceID,
        token: AppConstants.videosdkToken,
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
