import 'dart:io';

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends ConsumerWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.book,
            size: 250.h,
            color: context.theme.cardColor,
          ),
          const BigText(
            text: 'قم بتسجيل الدخول لتمنح لأبنائك فرصه للتنشئه الدينيه الصحيحه',
            textAlign: TextAlign.center,
          ),
          CustomButton(
            onTap: () => _googleSignIn(ref, context),
            svgPath: 'assets/svg/google.svg',
            text: 'Sign in with Google',
          ),
          if (Platform.isIOS)
            CustomButton(
              onTap: () {},
              svgPath: 'assets/svg/apple.svg',
              text: 'Sign in with Apple',
            ),
        ],
      ),
    );
  }

  void _googleSignIn(WidgetRef ref, BuildContext context) {
    ref
        .read(authControllerProvider)
        .signInWithGoggleAccount()
        .then((value) => Navigator.pushNamedAndRemoveUntil(
              context,
              MainScreen.routeName,
              (route) => false,
            ))
        .catchError((e) {
      customSnackbar(
        context: context,
        text: e.toString(),
        color: Colors.red,
      );
      return e;
    });
  }
}
