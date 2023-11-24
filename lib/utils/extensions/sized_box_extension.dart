import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxExtension on num {
  SizedBox get xSpace => SizedBox(height: h);
  SizedBox get ySpace => SizedBox(width: w);
}
