import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackbar(
      {required BuildContext context,
      required String text,
      Color color = Colors.redAccent}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: const StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(3),
      backgroundColor: color,
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15.h, color: Colors.white),
      ),
    ));
  }