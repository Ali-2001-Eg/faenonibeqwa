// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';

import '../../ads/banner_widget.dart';
import '../../utils/providers/app_providers.dart';
import '../../utils/shared/widgets/big_text.dart';
import '../meeting/create_meeting_screen.dart';
import 'widgets/feed_widget.dart';

class HomeScreen extends ConsumerWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) {
      print(ref.watch(userDataProvider).value?.isAdmin);
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: 'فَأَعِينُونِي بِقُوَّةٍ',
        actions: [
          if (ref.watch(authControllerProvider).isAdmin)
            Padding(
              padding: const EdgeInsets.only(left: 10).w,
              child: IconButton(
                onPressed: () {
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
              if (ref.watch(isDownloading)) ...[
                const LinearProgressIndicator(),
              ],
              const BigText(text: 'للانضمام للبث المباشر'),
              20.hSpace,
              const Expanded(child: FeedWidget()),
              // const PapersWidget(),
              const BannerWidget(),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: const AdminFloatingActionButton(
      //   heroTag: 'add document',
      //   icon: Icons.picture_as_pdf,
      //   routeName: AddDocumentScreen.routeName,
      // ),
    );
  }
}
