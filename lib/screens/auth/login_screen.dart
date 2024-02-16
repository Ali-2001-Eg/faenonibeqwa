import 'package:faenonibeqwa/screens/auth/signup_screen.dart';
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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isEmailCorrect = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    hintText: 'البريد الالكتروني',
                    validator: (value) {
                      if (!validateEmail(value!)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  20.hSpace,
                  CustomTextField(
                    hintText: 'الرقم السرى',
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  30.hSpace,
                  ref.watch(isLoading)
                      ? const CustomIndicator()
                      : CustomButton(
                          onTap: () {
                            _login(ref, context);
                          },
                          text: 'تسجيل الدخول',
                          backgroundColor: indicatorColor,
                        ),
                  15.hSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BigText(
                        text: 'ليس لديك حساب ؟',
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const SignUpScreen()),
                            ),
                          );
                        },
                        child: const BigText(
                          text: 'إنشاء حساب',
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

  void _login(WidgetRef ref, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider)
          .login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            context,
          )
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.routeName, (route) => false));
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