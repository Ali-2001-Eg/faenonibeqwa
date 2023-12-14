import 'package:faenonibeqwa/screens/exam/create-exam/create_exam_screen.dart';
import 'package:faenonibeqwa/utils/shared/widgets/admin_floating_action_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExamsListScreen extends ConsumerWidget {
  const ExamsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'الاختبارات'),
      floatingActionButton: AdminFloatingActionButton(
        icon: Icons.add,
        routeName: CreateExamScreen.routeName,
        referKey: 'createExam',
      ),
    );
  }
}
