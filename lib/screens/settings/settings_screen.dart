import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/utils/base/subscription_dialoge.dart';
import 'package:faenonibeqwa/utils/enums/toast_enum.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/base/app_helper.dart';
import '../../utils/shared/widgets/custom_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'حسابي'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'تسجيل خروج',
              onTap: () => ref.watch(authControllerProvider).signout.then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.routeName, (route) => false)),
            ),
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
              text: 'اشتراك ',
            ),
          ],
        ),
      ),
    );
  }
}
