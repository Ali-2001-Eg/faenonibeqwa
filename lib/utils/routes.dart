import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/screens/exam/create-exam/create_exam_screen.dart';
import 'package:faenonibeqwa/screens/home/add_document_screen.dart';
import 'package:faenonibeqwa/screens/lectures/add_lecture/add_lecture_screen.dart';
import 'package:faenonibeqwa/screens/meeting/create_meeting_screen.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/screens/home/payment/subscription_screen.dart';
import 'package:flutter/material.dart';

import '../screens/home/main_sceen.dart';
import 'base/error_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return _buildNewRoute(const LoginScreen());
    case MainScreen.routeName:
      return _buildNewRoute(const MainScreen());
    case CreateMeetingScreen.routeName:
      return _buildNewRoute(const CreateMeetingScreen());
    case SubscriptionScreen.routeName:
      return _buildNewRoute(const SubscriptionScreen());
    
    
    case CreateExamScreen.routeName:
      return _buildNewRoute(const CreateExamScreen());
    case AddLectureScreen.routeName:
      return _buildNewRoute(const AddLectureScreen());
    case AddDocumentScreen.routeName:
      final args = settings.arguments as Map<String, dynamic>;
      final lectureId = args['lectureId'];
      final lectureName = args['lectureName'];
      return _buildNewRoute(AddDocumentScreen(
        lectureId: lectureId, lectureName: lectureName,
      ));
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
