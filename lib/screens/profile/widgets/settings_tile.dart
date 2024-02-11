import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/shared/widgets/big_text.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
    this.logout = false,
  });
  final String text;
  final VoidCallback onTap;
  final IconData icon;
  final bool? logout;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.w),
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              BigText(
                text: text,
                textAlign: TextAlign.center,
              ),
              if (!logout!)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
