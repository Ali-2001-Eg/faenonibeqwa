import 'package:faenonibeqwa/screens/lectures/add_lecture/add_lecture_screen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/shared/widgets/admin_floating_action_button.dart';
import 'widgets/lecture_widget.dart';

class LecturesListScreen extends StatelessWidget {
  const LecturesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AdminFloatingActionButton(
        icon: Icons.add,
        routeName: AddLectureScreen.routeName,
        heroTag: 'addLecture',
      ),
      appBar: const CustomAppBar(title: 'المحاضرات'),
      body: Consumer(
        builder: (context, ref, child) {
          return ref.watch(lecturesStream).when(
            data: (data) {
              if (data.isEmpty) {
                return const Expanded(
                    child: Center(child: BigText(text: 'لا توجد فيديوهات')));
              }
              return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => Divider(
                  color: context.theme.dividerColor,
                  thickness: 2,
                  indent: 30,
                ),
                itemBuilder: (ctx, index) {
                  final lecture = data[index];
                  return LectureWidget(
                    lecturepath: lecture.lectureUrl,
                    title: lecture.name,
                    audienceNo: lecture.audienceUid.length.toString(),
                  );
                },
              );
            },
            error: (error, stackTrace) {
              AppHelper.customSnackbar(
                  context: context, title: error.toString());
              throw error;
            },
            loading: () {
              return const CircularProgressIndicator();
            },
          );
        },
      ),
    );
  }
}
