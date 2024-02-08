import 'package:faenonibeqwa/screens/lectures/add_lecture/add_lecture_screen.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/shared/widgets/admin_floating_action_button.dart';

class LecturesListScreen extends ConsumerWidget {
  const LecturesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        floatingActionButton: const AdminFloatingActionButton(
          icon: Icons.add,
          routeName: AddLectureScreen.routeName,
          heroTag: 'addLecture',
        ),
        appBar: const CustomAppBar(title: 'المحاضرات'),
        body: Container());
  }
}
