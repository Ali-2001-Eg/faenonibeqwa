import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/base/app_images.dart';
import '../../../utils/shared/widgets/small_text.dart';

class StudenDetails extends StatelessWidget {
  const StudenDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            height: 40.h,
            width: 180.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: SmallText(text: 'عدد الحضور :  10 من 12 اختبار '),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return const StudentDetailsItem();
              },
            ),
          )
        ],
      ),
    );
  }
}

class StudentDetailsItem extends StatelessWidget {
  const StudentDetailsItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      height: 100.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: const Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallText(
              text: 'اسم الاختبار : الكيمياء العضويه',
              fontSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SmallText(
              text: 'درجة الطالب : 25/30',
              fontSize: 16,
            ),
            SmallText(
              text: 'الحضور : تم الحضور',
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
