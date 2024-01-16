import 'package:faenonibeqwa/repositories/exam_repo.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/display_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/shared/widgets/big_text.dart';

class QuestionDetails extends StatelessWidget {
  final String questionBody;
  final String? questionImage;
  final WidgetRef ref;
  const QuestionDetails({
    super.key,
    required this.questionBody,
    this.questionImage,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        questionImage != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: DisplayQuestionImageWidget(imageUrl: questionImage!),
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(height: 15.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: BigText(
              text: 'س${ref.watch(currentIndex) + 1}:  $questionBody ',
            ),
          ),
        ),
      ],
    );
  }
}
