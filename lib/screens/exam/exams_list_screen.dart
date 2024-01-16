import 'package:faenonibeqwa/controllers/exam_controller.dart';
import 'package:faenonibeqwa/models/exam_model.dart';
import 'package:faenonibeqwa/screens/exam/create-exam/create_exam_screen.dart';
import 'package:faenonibeqwa/screens/exam/widgets/exam_tile_widget.dart';
import 'package:faenonibeqwa/utils/shared/widgets/admin_floating_action_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/shared/widgets/big_text.dart';
import '../../utils/shared/widgets/custom_indicator.dart';

class ExamsListScreen extends ConsumerWidget {
  const ExamsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الاختبارات'),
      body: StreamBuilder<List<ExamModel>>(
          stream: ref.watch(examControllerProvider).exams,
          builder: (_, snap) {
            if (snap.hasError) {
              return Center(
                  child: BigText(
                text: snap.error.toString(),
                textAlign: TextAlign.center,
                color: Colors.red,
              ));
            }
            if (snap.connectionState == ConnectionState.waiting) {
              return const CustomIndicator();
            }
            if (snap.hasData && snap.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snap.data!.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ExamTileWidget(
                    ref: ref,
                    examModel: snap.data![index],
                  );
                },
              );
            }
            return const Center(
              child: BigText(
                text: 'لا يوجد اختبارات',
                fontSize: 28,
              ),
            );
          }),
      floatingActionButton: const AdminFloatingActionButton(
        icon: Icons.add,
        routeName: CreateExamScreen.routeName,
        heroTag: 'createExam',
      ),
    );
  }
}
