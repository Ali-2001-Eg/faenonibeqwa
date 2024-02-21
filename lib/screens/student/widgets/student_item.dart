import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/base/app_images.dart';
import '../../../utils/shared/widgets/small_text.dart';
import 'student_details.dart';

class StudentItem extends StatelessWidget {
  final String name;
  final String id;
  const StudentItem({
    super.key,
    required this.name,
    required this.id,
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(
                    text: 'اسم الطالب : $name',
                    fontSize: 15,
                    //  fontWeight: FontWeight.w600,
                  ),
                  20.hSpace,
                  SmallText(
                    text: 'كود الطالب : $id',
                    fontSize: 15,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
