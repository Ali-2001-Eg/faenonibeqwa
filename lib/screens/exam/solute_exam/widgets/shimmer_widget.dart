import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    this.cardsNumber = 4,
    this.heigth = 60,
  });
  final int cardsNumber;
  final double heigth;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            cardsNumber,
            (index) => Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(15),
              width: context.screenWidth,
              height: heigth.h,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
            ),
          )),
    );
  }
}
