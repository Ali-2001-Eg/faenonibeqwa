import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/utils/base/app_images.dart';
import 'package:faenonibeqwa/utils/base/colors.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/base/app_helper.dart';
import '../../utils/providers/app_providers.dart';
import '../../utils/shared/widgets/big_text.dart';
import '../../utils/shared/widgets/custom_button.dart';
import '../../utils/shared/widgets/custom_text_field.dart';
import '../home/main_sceen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String routeName = '/signUp';

  @override
  ConsumerState<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController(),
      _usernameController = TextEditingController(),
      _emailController = TextEditingController();
  bool isEmailCorrect = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.05,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                AppImages.backGround,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  40.hSpace,
                  Image.asset(
                    AppImages.logo,
                    fit: BoxFit.cover,
                    height: 220.h,
                    color: indicatorColor,
                  ),
                  CustomTextField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    hintText: 'اسم المستخدم',
                    validator: (value) {
                      if (!validateEmail(value!)) {
                        return 'يرجي ادخال اسم المستخدم';
                      }
                      return null;
                    },
                  ),
                  20.hSpace,
                  CustomTextField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    hintText: 'البريد الالكتروني',
                    validator: (value) {
                      if (!validateEmail(value!)) {
                        return 'يرجي ادخال البريد الالكتروني';
                      }
                      return null;
                    },
                  ),
                  20.hSpace,
                  CustomTextField(
                    hintText: 'الرقم السرى',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجي ادخال الرقم السري';
                      } else if (value.length < 6) {
                        return 'الرقم السرى يجب ان يكون مكون من 6 احرف';
                      } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*d).+$')
                          .hasMatch(value)) {
                        return 'الرقم السرى يجب ان يحتوى على ارقام و حروف و رموز';
                      }
                      return null;
                    },
                  ),
                  20.hSpace,
                  ref.watch(isLoading)
                      ? const CustomIndicator()
                      : CustomButton(
                          onTap: () {
                            _signup(ref, context);
                          },
                          text: 'انشاء حساب',
                          width: 170.w,
                          backgroundColor: indicatorColor,
                        ),
                  15.hSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BigText(
                        text: ' لديك حساب ؟',
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const LoginScreen()),
                            ),
                          );
                        },
                        child: const BigText(
                          text: 'تسجيل الدخول',
                          color: indicatorColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signup(WidgetRef ref, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider).signup(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _usernameController.text.trim(),
            context,
          );
    } else {
      AppHelper.customSnackbar(
          context: context,
          title: 'قم بإكمال كافه البيانات الخاصه بتسجيل الدخول');
    }
  }

  bool validateEmail(String value) {
    if (value.isEmpty) {
      return false;
    } else {
      final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
      );
      return emailRegex.hasMatch(value);
    }
  }
}
