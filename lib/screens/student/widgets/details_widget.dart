import 'package:flutter/material.dart';
import '../../../utils/shared/widgets/small_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentDetailsItem extends StatelessWidget {
  final String title;
  final String grade;
  const StudentDetailsItem({
    super.key,
    required this.title,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      height: 100.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallText(
            text: 'اسم الاختبار : $title',
            fontSize: 14,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SmallText(
            text: 'درجة الطالب : $flippeGrade',
            fontSize: 16,
          ),
        ],
      ),
    );
  }

  String get flippeGrade {
    String originalGrade = grade;

    List<String> parts = originalGrade.split('/');

    String numerator = parts[0];
    String denominator = parts[1];

    // Swap the numerator and denominator
    String newFraction = '$denominator/$numerator';

    print('Original Fraction: $originalGrade');
    print('Converted Fraction: $newFraction');
    return newFraction;
  }
}
