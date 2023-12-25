// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/controllers/auth_controller.dart';

class AdminFloatingActionButton extends ConsumerWidget {
  final IconData icon;
  final String routeName;
  final String heroTag;
  const AdminFloatingActionButton({
    super.key,
    required this.icon,
    required this.routeName,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context, ref) {
    return ref.read(authControllerProvider).isAdmin
        ? FloatingActionButton(
            heroTag: heroTag,
            onPressed: () => Navigator.pushNamed(context, routeName),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          )
        : Container();
  }
}
