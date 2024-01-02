import 'package:faenonibeqwa/models/exam_model.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/solute_exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../utils/shared/widgets/custom_button.dart';
import '../../../utils/shared/widgets/small_text.dart';

class ExamTileWidget extends StatelessWidget {
  final ExamModel examModel;
  const ExamTileWidget({
    super.key,
    required this.examModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SoluteExamScreen(
            exam: examModel,
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10, left: 0, right: 0),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: examModel.examImageUrl,
                height: 120.h,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SmallText(
                      text: 'اسم الاختبار / ${examModel.examTitle}',
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SmallText(
                    text: 'مده الاختبار / ${examModel.timeMinutes} دقيقه',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SmallText(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                text: 'الوصف / ${examModel.examDescription}',
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: CustomButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SoluteExamScreen(
                          exam: examModel,
                        );
                      },
                    ),
                  );
                },
                text: 'ادخل الآن',
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
