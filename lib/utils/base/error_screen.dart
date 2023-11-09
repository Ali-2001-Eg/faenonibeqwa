import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'This page doesn\'t exist',
          style: TextStyle(
              color: Theme.of(context).colorScheme.error, fontSize: 40.h),
        ),
      ),
    );
  }
}
