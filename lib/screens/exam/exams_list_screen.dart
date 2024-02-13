import 'package:faenonibeqwa/screens/exam/create-exam/create_exam_screen.dart';
import 'package:faenonibeqwa/screens/exam/widgets/exam_tile_widget.dart';
import 'package:faenonibeqwa/utils/shared/widgets/admin_floating_action_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/providers/app_providers.dart';
import '../../utils/shared/widgets/big_text.dart';
import '../../utils/shared/widgets/custom_indicator.dart';

class ExamsListScreen extends ConsumerWidget {
  const ExamsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الاختبارات'),
      body: ref.watch(examListStream).when(data: (data) {
        if (data.isEmpty) {
          return const Expanded(
              child: Center(
            child: BigText(
              text: 'لا يوجد اختبارات',
              fontSize: 28,
            ),
          ));
        }
        return ListView.builder(
          itemCount: data.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ExamTileWidget(
              ref: ref,
              examModel: data[index],
            );
          },
        );
      }, error: (error, stackTrace) {
        return BigText(text: error.toString());
      }, loading: () {
        return const Center(child: CustomIndicator());
      }),
    );
  }
}
