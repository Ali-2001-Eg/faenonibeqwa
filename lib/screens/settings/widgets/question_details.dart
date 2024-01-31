import 'package:flutter/material.dart';

import '../../../utils/base/app_images.dart';
import '../../../utils/shared/widgets/big_text.dart';

class QuestionDetails extends StatelessWidget {
  const QuestionDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BigText(text: 'Muitiple Choose Questions'),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              AppImages.tripImage,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: BigText(
              text: 'س 4 : من اين انت ؟',
            ),
          ),
        ),
      ],
    );
  }
}
