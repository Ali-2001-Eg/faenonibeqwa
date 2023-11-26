import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/shared/widgets/feed_widget.dart';
import '../meeting/create_meeting_screen.dart';

class HomeScreen extends ConsumerWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        title: const BigText(
          text: 'فَأَعِينُونِي بِقُوَّةٍ',
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10).w,
            child: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, CreateMeetingScreen.routeName),
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
