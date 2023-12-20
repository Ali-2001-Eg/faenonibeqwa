// ignore_for_file: body_might_complete_normally_catch_error, unused_element

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/screens/auth/signup_screen.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:faenonibeqwa/utils/shared/widgets/customSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends ConsumerWidget {
  static const String routeName = '/login';
  LoginScreen({super.key});
  final TextEditingController _passwordController = TextEditingController(),
      _emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book,
                size: 250.h,
                color: context.theme.cardColor,
              ),
              16.hSpace,
              const BigText(
                text:
                    'قم بتسجيل الدخول لتمنح لأبنائك فرصه للتنشئه الدينيه الصحيحه',
                textAlign: TextAlign.center,
              ),
              16.hSpace,
              CustomTextField(
                controller: _emailController,
                hintText: 'البريد الألكتروني',
              ),
              15.hSpace,
              CustomTextField(
                controller: _passwordController,
                hintText: 'الرقم السرى',
              ),
              15.hSpace,
              CustomButton(
                  onTap: () => _login(ref, context), text: 'تسجيل الدخول'),
              30.hSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const BigText(text: 'ليس لديك حساب ؟'),
                  ),
                  6.wSpace,
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => SignUpScreen()),
                        ),
                      );
                    },
                    child: const BigText(
                      text: 'إنشاء حساب',
                      color: Colors.blue,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _login(WidgetRef ref, BuildContext context) {
    if (_formkey.currentState!.validate() &&
        _emailController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .login(_emailController.text.trim(), _passwordController.text.trim())
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.routeName, (route) => false));
    } else {
      customSnackbar(
          context: context,
          text: 'قم بإكمال كافه البيانات الخاصه بتسجيل الدخول');
    }
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
    });
  }
}
