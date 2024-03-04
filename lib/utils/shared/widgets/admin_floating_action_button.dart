// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';

class AdminFloatingActionButton extends ConsumerWidget {
  final IconData icon;
  final String routeName;
  final String heroTag;
  final Object? arguments;
  const AdminFloatingActionButton({super.key, 
    required this.icon,
    required this.routeName,
    required this.heroTag,
    this.arguments,
  });

  @override
  Widget build(BuildContext context, ref) {
    return FutureBuilder<bool>(
          future: ref.watch(authControllerProvider).isAdmin,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return FloatingActionButton(
                heroTag: heroTag,
                onPressed: () => Navigator.pushNamed(context, routeName,arguments:arguments ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              );
            }
            else{
              return Container();
            }
          }
        );
  }
}
