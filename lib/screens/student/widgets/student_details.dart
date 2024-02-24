import 'package:faenonibeqwa/utils/shared/widgets/shimmer_widget.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'details_widget.dart';
import '../../../utils/shared/widgets/small_text.dart';

class StudenDetails extends ConsumerWidget {
  const StudenDetails({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'اختبارات الطالب'),
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
              child: SmallText(
                  text:
                      'عدد الحضور ${_examsJoined(ref)} من ${_totalExams(ref)}')),
          Expanded(
            child: ref.watch(examsHistoryProvider).when(
                  data: (data) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final exam = data[index];
                      if (data.isEmpty) {
                        return const Center(
                            child: BigText(
                          text: 'لم يختبر بعد',
                          fontSize: 30,
                        ));
                      }
                      return StudentDetailsItem(
                        title: exam.title,
                        grade: exam.studentGrade,
                      );
                    },
                  ),
                  error: (error, d) => BigText(text: error.toString()),
                  loading: () => const ShimmerWidget(
                    cardsNumber: 3,
                    heigth: 100,
                  ),
                ),
          )
        ],
      ),
    );
  }

  int _examsJoined(WidgetRef ref) {
    return ref.watch(examsJoinedProvider).when(data: (data) {
      return data;
    }, error: (error, s) {
      return 0;
    }, loading: () {
      return 0;
    });
  }

  int _totalExams(WidgetRef ref) {
    return ref.watch(totalExamsProvider).when(data: (data) {
      return data;
    }, error: (error, s) {
      return 0;
    }, loading: () {
      return 0;
    });
  }
}
