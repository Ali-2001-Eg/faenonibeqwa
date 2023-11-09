import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxExtension on num {
  SizedBox get verticalspace => SizedBox(height: toDouble().h);
  SizedBox get horizontalspace => SizedBox(width: toDouble().w);
}
