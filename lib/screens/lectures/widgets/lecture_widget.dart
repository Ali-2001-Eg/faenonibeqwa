import 'package:faenonibeqwa/utils/base/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/lectures_model.dart';
import '../../../utils/shared/widgets/small_text.dart';

class LectureWidget extends ConsumerWidget {
  final LecturesModel lecture;

  const LectureWidget({
    Key? key,
    required this.lecture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 4, right: 8, left: 8),
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            // blurRadius: 50,
            spreadRadius: 10,
            color: Colors.white,
            offset: Offset(0, -3),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        title: SmallText(
          text: lecture.name,
          fontSize: 15,
        ),
        trailing: const Icon(
          Icons.video_collection_outlined,
          color: indicatorColor,
        ),
      ),
    );
  }
}
