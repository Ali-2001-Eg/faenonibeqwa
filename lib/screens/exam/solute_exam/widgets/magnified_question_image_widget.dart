import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/display_image_widget.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class MagnifiedQuestionImageWidget extends StatelessWidget {
  final String imageUrl;
  const MagnifiedQuestionImageWidget(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: context.screenWidth / 0.9,
          height: context.screenHeight / 0.4,
          child: ImageWidget(imageUrl: imageUrl, fit: BoxFit.contain),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ZoomInButton(
            imageUrl: imageUrl,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
