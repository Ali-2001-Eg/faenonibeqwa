import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: InkWell(
          child: Text(
            'Signout',
            style: context.theme.textTheme.displayMedium,
          ),
          onTap: () => ref.read(authControllerProvider).signout.then((value) =>
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.routeName, (route) => false)),
        ),
      ),
    );
  }
}
