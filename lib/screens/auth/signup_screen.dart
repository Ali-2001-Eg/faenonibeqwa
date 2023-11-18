import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/utils/shared/widgets/meeting_title_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: AppBar(),
      body: Form(
        key: _formkey,
        child: Column(children: [
          CustomTextField(controller: _emailController, hint: 'Email Address'),
          20.verticalSpace,
          CustomTextField(controller: _passwordController, hint: 'Password'),
          20.verticalSpace,
          CustomTextField(controller: _usernameController, hint: 'Username'),
          20.verticalSpace,
          CustomButton(onTap: () => _signup(ref, context), text: 'Register'),
        ]),
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
