import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/utils/base/subscription_dialoge.dart';
import 'package:faenonibeqwa/utils/enums/toast_enum.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../utils/base/app_helper.dart';
import '../../utils/providers/app_providers.dart';
import '../../utils/shared/widgets/big_text.dart';
import '../../utils/shared/widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      // appBar: const CustomAppBar(title: 'حسابي'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 35.h),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: context.theme.appBarTheme.backgroundColor!
                      .withOpacity(0.6),
                  backgroundImage:
                      ref.watch(authControllerProvider).getPhotoUrl != ''
                          ? CachedNetworkImageProvider(
                              ref.watch(authControllerProvider).getPhotoUrl)
                          : null,
                  child: ref.watch(authControllerProvider).getPhotoUrl == ''
                      ? const Icon(
                          Icons.person,
                          size: 50,
                        )
                      : null,
                ),
                InkWell(
                    onTap: () {},
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
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<SalesData, String>>[
                  LineSeries<SalesData, String>(
                      // Bind data source
                      dataSource: <SalesData>[
                        SalesData('Jan', 35),
                        SalesData('Feb', 28),
                        SalesData('Mar', 34),
                        SalesData('Apr', 32),
                        SalesData('May', 40)
                      ],
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales)
                ])),
            15.hSpace,
            ListView(shrinkWrap: true, children: [
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
            ]),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
    this.logout = false,
  });
  final String text;
  final VoidCallback onTap;
  final IconData icon;
  final bool? logout;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.w),
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              BigText(
                text: text,
                textAlign: TextAlign.center,
              ),
              if (!logout!)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
