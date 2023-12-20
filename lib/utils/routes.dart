import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/screens/exam/create-exam/create_exam_screen.dart';
import 'package:faenonibeqwa/screens/meeting/create_meeting_screen.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/screens/trip/create_trip_screen.dart';
import 'package:flutter/material.dart';

import '../screens/home/main_sceen.dart';
import 'base/error_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return _buildNewRoute(LoginScreen());
    case MainScreen.routeName:
      return _buildNewRoute(const MainScreen());
    case CreateMeetingScreen.routeName:
      return _buildNewRoute(const CreateMeetingScreen());
    case CreateTripScreen.routeName:
      return _buildNewRoute(const CreateTripScreen());
    case CreateExamScreen.routeName:
      return _buildNewRoute(CreateExamScreen());
    case MeetingScreen.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      final channelId = args['channelId'] as String;
      final title = args['title'] as String;
      final isBroadcaster = args['isBroadcaster'] as bool;
      return _buildNewRoute(MeetingScreen(
        channelId: channelId,
        isBrodcaster: isBroadcaster,
        title: title,
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
