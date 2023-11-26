import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/shared/widgets/custom_button.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});
  final TextEditingController _passwordController = TextEditingController(),
      _usernameController = TextEditingController(),
      _emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText(
          text: 'إنشاء حساب',
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(children: [
            CustomTextField(
              controller: _usernameController,
              hintText: 'اسم المستخدم',
            ),
            20.hSpace,
            CustomTextField(
              controller: _emailController,
              hintText: 'البريد الألكتروني',
            ),
            20.hSpace,
            CustomTextField(
              controller: _passwordController,
              hintText: 'الرقم السرى',
            ),
            20.hSpace,
            CustomButton(
              onTap: () => _signup(ref, context),
              text: 'إنشاء حساب',
              fontSize: 18,
            ),
          ]),
        ),
      ),
    );
  }

  void _signup(WidgetRef ref, BuildContext context) {
    if (_formkey.currentState!.validate()) {
      ref
          .read(authControllerProvider)
          .signup(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _usernameController.text.trim(),
            '',
          )
          .then(
            (value) => Navigator.pushNamed(context, LoginScreen.routeName),
          );
    }
  }
}
