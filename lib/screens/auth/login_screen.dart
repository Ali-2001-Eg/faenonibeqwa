import 'package:faenonibeqwa/screens/auth/signup_screen.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/base/app_helper.dart';
import '../../utils/providers/app_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(ref.watch(isLoading));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                if (ref.watch(isLoading))
                  const CustomIndicator()
                else
                  CustomButton(
                    onTap: () => _login(ref, context),
                    text: 'تسجيل الدخول',
                    width: context.screenWidth * 0.7,
                  ),
                30.hSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const BigText(text: 'ليس لديك حساب ؟'),
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
      ),
    );
  }

  void _login(WidgetRef ref, BuildContext context) {
    if (_formkey.currentState!.validate() &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
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

  // ignore: unused_element
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
      AppHelper.customSnackbar(
        context: context,
        title: e.toString(),
      );
      return e;
    });
  }
}
