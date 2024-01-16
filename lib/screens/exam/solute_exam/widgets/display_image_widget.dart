import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/magnified_question_image_widget.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DisplayQuestionImageWidget extends StatelessWidget {
  const DisplayQuestionImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      height: context.screenHeight * 0.3,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  // height: 120.h,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          ZoomInButton(
            imageUrl: imageUrl,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MagnifiedQuestionImageWidget(imageUrl),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageUrl,
    required this.fit,
  });

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (_, url) => Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.grey[100]!,
        child: Container(
            height: 120.h,
            width: context.screenWidth,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15))),
      ),
      // placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

class ZoomInButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;
  const ZoomInButton({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: onTap,
        style: context.theme.iconButtonTheme.style!.copyWith(
          shape:
              const MaterialStatePropertyAll<OutlinedBorder>(StadiumBorder()),
          backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
        ),
        icon: const Icon(Icons.zoom_out_map_outlined, color: Colors.black),
      ),
    );
  }
}
