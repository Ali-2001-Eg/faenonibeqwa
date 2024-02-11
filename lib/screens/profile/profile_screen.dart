import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/utils/base/subscription_dialoge.dart';
import 'package:faenonibeqwa/utils/enums/toast_enum.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
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
import 'widgets/settings_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 35.h),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (ref.watch(isLoading)) const LinearProgressIndicator(),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                if (ref.watch(userDataProvider).value!.photoUrl.isEmpty)
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: context.theme.appBarTheme.backgroundColor!
                        .withOpacity(0.6),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),
                Container(
                  width: context.screenWidth / 3,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        ref.watch(authControllerProvider).getPhotoUrl,
                      ),
                    ),
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
                        )))
              ],
            ),
            30.hSpace,
            BigText(text: ref.watch(authControllerProvider).getName),
            15.hSpace,
            CustomButton(
                onTap: () {
                  if (ref.watch(authControllerProvider).isPremium) {
                    AppHelper.customSnackbar(
                      context: context,
                      title: 'تم الاشتراك بالفعل',
                      status: ToastStatus.success,
                    );
                  } else {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const SubscriptionDialog();
                        });
                  }
                },
                text: 'الاشتراك في الخطه'),
            Expanded(
                child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    series: <LineSeries<ProfileCartModel, String>>[
                  lineSeries(ref)
                ])),
            15.hSpace,
            ListView(
              shrinkWrap: true,
              children: [
                SettingsTile(
                  text: 'نشاطك',
                  icon: Icons.history_outlined,
                  onTap: () {},
                ),
                SettingsTile(
                  text: 'تسجيل خروج',
                  icon: Icons.logout_sharp,
                  onTap: () => ref.watch(authControllerProvider).signout.then(
                      (value) => Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.routeName, (route) => false)),
                ),
              ],
            ),
          ],
        ),
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

  int streamsJoined(WidgetRef ref) =>
      ref.watch(userDataProvider).value!.streamJoined ?? 0;

  int lecturesWatched(WidgetRef ref) {
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
