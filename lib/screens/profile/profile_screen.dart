import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/screens/exam/create-exam/create_exam_screen.dart';
import 'package:faenonibeqwa/screens/meeting/create_meeting_screen.dart';
import 'package:faenonibeqwa/screens/profile/change_plan/change_plan_screen.dart';
import 'package:faenonibeqwa/screens/home/payment/subscription_screen.dart';
import 'package:faenonibeqwa/utils/enums/toast_enum.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/profile_chart_model.dart';
import '../../utils/base/app_helper.dart';
import '../../utils/providers/app_providers.dart';
import '../../utils/shared/widgets/big_text.dart';
import '../../utils/shared/widgets/custom_button.dart';
import '../lectures/add_lecture/add_lecture_screen.dart';
import '../student/student_screen.dart';
import 'widgets/settings_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    print(ref.watch(authControllerProvider).getName);
    print(ref.watch(authControllerProvider).email);
    print(ref.watch(authControllerProvider).userInfo.uid);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 35.h),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (ref.watch(isLoading)) const LinearProgressIndicator(),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  if (ref.watch(authControllerProvider).getPhotoUrl.isEmpty)
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: context
                          .theme.appBarTheme.backgroundColor!
                          .withOpacity(0.6),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    )
                  else
                    Container(
                      width: context.screenWidth / 3,
                      height: 120.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              ref.watch(authControllerProvider).getPhotoUrl,
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                  // margin: EdgeInsets.all(20.h),

                  InkWell(
                    onTap: () {
                      ref.watch(fileNotifier.notifier).pickImage(context).then(
                          (value) => ref
                              .watch(authRepoProvider)
                              .editPhoto(ref.watch(fileNotifier)!.path));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: Icon(
                        Icons.add_a_photo_sharp,
                        size: 20,
                        color: context.theme.appBarTheme.backgroundColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            20.hSpace,
            BigText(
              text: ref.watch(authControllerProvider).getName,
              fontSize: 20.sp,
              textAlign: TextAlign.center,
              color: Colors.black,
            ),
            10.hSpace,
            SmallText(
              textAlign: TextAlign.center,
              text: ref.watch(authControllerProvider).email,
              fontSize: 14.sp,
              color: Colors.black,
            ),
            15.hSpace,
            if (!ref.watch(authControllerProvider).isAdmin)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 70.w),
                child: CustomButton(
                    onTap: () {
                      if (ref.watch(authControllerProvider).isPremium) {
                        AppHelper.customSnackbar(
                          context: context,
                          title: 'تم الاشتراك بالفعل',
                          status: ToastStatus.success,
                        );
                      } else {
                        Navigator.of(context)
                            .pushNamed(SubscriptionScreen.routeName);
                      }
                    },
                    text: 'الاشتراك في الخطه'),
              ),
            (ref.watch(authControllerProvider).isAdmin)
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SettingsTile(
                            onTap: () => Navigator.pushNamed(
                                context, CreateMeetingScreen.routeName),
                            text: "مكالمه جماعيه",
                            icon: Icons.call,
                            leadingIconColor: Colors.green),
                        SettingsTile(
                            onTap: () => Navigator.pushNamed(
                                context, CreateExamScreen.routeName),
                            text: 'إضافه اختبار',
                            icon: Icons.book,
                            leadingIconColor: Colors.yellow),
                        SettingsTile(
                            onTap: () => Navigator.pushNamed(
                                context, AddLectureScreen.routeName),
                            text: 'إضافه حلقه',
                            icon: Icons.ondemand_video_rounded,
                            leadingIconColor: Colors.redAccent),
                        SettingsTile(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePlanScreen())),
                            text: 'إضافه خطه دفع',
                            icon: Icons.monetization_on,
                            leadingIconColor: Colors.green),
                        SettingsTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const StudentScreen();
                                  },
                                ),
                              );
                            },
                            text: 'بيانات الطلاب',
                            icon: Icons.history_outlined,
                            leadingIconColor: Colors.white),
                        SettingsTile(
                          leadingIconColor: Colors.redAccent,
                          text: 'تسجيل خروج',
                          icon: Icons.logout_sharp,
                          onTap: () => _signout(ref, context),
                        ),
                      ],
                    ),
                  )
                : SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    series: <LineSeries<ProfileCartModel, String>>[
                        lineSeries(ref)
                      ]),
            // 15.hSpace,
            if (!ref.watch(authControllerProvider).isAdmin)
              SettingsTile(
                leadingIconColor: Colors.redAccent,
                text: 'تسجيل خروج',
                icon: Icons.logout_sharp,
                onTap: () => _signout(ref, context),
              ),
          ],
        ),
      ),
    );
  }

  Future<Object?> _signout(WidgetRef ref, BuildContext context) {
    return showDialog(
      context: context,
      builder: (conetxt) => AlertDialog(
        actions: [
          CustomButton(
            onTap: () => ref.watch(authControllerProvider).signout.then(
                (value) => Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.routeName, (route) => false)),
            text: 'تأكيد',
            backgroundColor: Colors.redAccent,
          ),
          CustomButton(
            onTap: () => Navigator.of(context).pop(),
            text: 'الرجوع',
          )
        ],
        title: const BigText(text: 'تأكيد تسجيل الخروج'),
      ),
    );
  }

  LineSeries<ProfileCartModel, String> lineSeries(WidgetRef ref) {
    if (kDebugMode) {
      print(lecturesWatched(ref));
    }
    return LineSeries<ProfileCartModel, String>(
        // Bind data source
        dataSource: <ProfileCartModel>[
          ProfileCartModel('الحضور', streamsJoined(ref)),
          ProfileCartModel('المحاضرات', lecturesWatched(ref)),
          ProfileCartModel('الدرجات', examsTotalGrade(ref)),
        ],
        xValueMapper: (ProfileCartModel value, _) => value.title,
        yValueMapper: (ProfileCartModel value, _) => value.data);
  }

  num streamsJoined(WidgetRef ref) {
    return ref.watch(streamJoinedProvider).when(data: (data) {
      return data;
    }, error: (error, s) {
      return 0;
    }, loading: () {
      return 0;
    });
  }

  num lecturesWatched(WidgetRef ref) {
    return ref.watch(lecturesWatchedProvider).when(data: (data) {
      return data;
    }, error: (error, s) {
      return 0;
    }, loading: () {
      return 0;
    });
  }

  num examsTotalGrade(WidgetRef ref) {
    return ref.watch(totalGradeProvider).when(data: (data) {
      return data;
    }, error: (error, s) {
      return 0;
    }, loading: () {
      return 0;
    });
  }
}
