import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/base/app_images.dart';
import '../../../utils/shared/widgets/small_text.dart';
import 'student_details.dart';

class StudentItem extends StatelessWidget {
  const StudentItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const StudenDetails();
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        height: 90.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Image.asset(
              AppImages.studnet,
              // width: 70.w,
            ),
            25.wSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SmallText(
                  text: 'اسم الطالب / على محمد جاد',
                  fontSize: 15,
                  // fontWeight: FontWeight.w600,
                ),
                20.hSpace,
                const SmallText(
                  text: 'كود الطالب / 5896845',
                  fontSize: 15,
                  // fontWeight: FontWeight.w600,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
