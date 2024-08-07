import 'package:faenonibeqwa/screens/lectures/view_lecture_screen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/payment/subscription_screen.dart';
import 'widgets/lecture_widget.dart';

class LecturesListScreen extends StatelessWidget {
  const LecturesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'المحاضرات'),
      body: Consumer(
        builder: (context, ref, child) {
          return ref.watch(lecturesStream).when(
            data: (data) {
              if (data.isEmpty) {
                return const Expanded(
                    child: Center(child: BigText(text: 'لا توجد فيديوهات')));
              }
              return ListView.separated(
                itemCount: data.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 14),
                separatorBuilder: (context, index) =>
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                itemBuilder: (ctx, index) {
                  final lecture = data[index];
                  return InkWell(
                    onTap: () async {
                      if (await ref
                          .read(paymentControllerProvider)
                          .subscriptionEnded) {
                        if (context.mounted) {
                          Navigator.of(context)
                              .pushNamed(SubscriptionScreen.routeName);
                        }
                        await ref
                            .read(paymentControllerProvider)
                            .changePlanAfterEndDate;
                        await FirebaseMessaging.instance
                            .unsubscribeFromTopic('premium');
                        if (context.mounted) {
                          AppHelper.customSnackbar(
                            context: context,
                            title:
                                'يجب تفعيل الاشتراك لتتمكن من مشاهده المحاضره',
                          );
                        }
                      } else if (context.mounted) {
                        if (!lecture.audienceUid.contains(
                            ref.watch(authControllerProvider).userInfo.uid)) {
                          await ref
                              .watch(lecturesControllerProvider)
                              .addUserToVideoAudience(lecture.id);
                        }
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) {
                                return ViewLectureScreen(
                                    title: lecture.name,
                                    videoPath: lecture.lectureUrl,
                                    id: lecture.id,
                                    audienceNo:
                                        lecture.audienceUid.length.toString());
                              },
                            ),
                          );
                        }
                      }
                    },
                    child: LectureWidget(
                      lecture: lecture,
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) {
              AppHelper.customSnackbar(
                  context: context, title: error.toString());
              throw error;
            },
            loading: () {
              return const CustomIndicator();
            },
          );
        },
      ),
    );
  }
}
