import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import '../../utils/shared/widgets/feed_widget.dart';
import '../meeting/create_meeting_screen.dart';

class HomeScreen extends ConsumerWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('admin => ${ref.read(authControllerProvider).isAdmin}');
    return Scaffold(
      appBar: AppBar(
        title: const BigText(
          text: 'فَأَعِينُونِي بِقُوَّةٍ',
          color: Colors.white,
        ),
        actions: [
          if (ref.read(authControllerProvider).isAdmin)
            Padding(
              padding: const EdgeInsets.only(left: 10).w,
              child: IconButton(
                onPressed: () {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                    id: 10,
                    channelKey: 'basic_channel',
                    title: 'Simple Notification',
                    body: 'Test Awesome Notification',
                  ));
                  Navigator.pushNamed(context, CreateMeetingScreen.routeName);
                },
                tooltip: 'قم بإنشاء محادثه بينك و بين أصدقائك',
                icon: const Icon(
                  Icons.call,
                ),
              ),
            )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.hSpace,
              const FeedWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
