import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxExtension on num {
  SizedBox get hSpace => SizedBox(height: h);
  SizedBox get wSpace => SizedBox(width: w);
}
