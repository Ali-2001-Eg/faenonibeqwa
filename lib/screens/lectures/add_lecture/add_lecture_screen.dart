// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:faenonibeqwa/screens/lectures/widgets/video_player_widget.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/notification_model.dart';
import '../../../utils/shared/widgets/custom_appbar.dart';

class AddLectureScreen extends StatefulWidget {
  static const String routeName = '/add-new-lecture';
  const AddLectureScreen({super.key});

  @override
  State<AddLectureScreen> createState() => _AddLectureScreenState();
}

class _AddLectureScreenState extends State<AddLectureScreen> {
  final TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'اضافه محاضره',
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomTextField(
                    controller: titleController,
                    hintText: 'عنوان المحاضره',
                    labelText: 'عنوان المحاضره ',
                  ),
                ),
                10.hSpace,
                Consumer(
                  builder: (context, ref, child) {
                    if (kDebugMode) {
                      print('path ${ref.watch(fileNotifier)?.path}');
                    }
                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ref.watch(fileNotifier) == null
                              ? Container(
                                  height: context.screenHeight / 4,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all()),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomButton(
                                        onTap: () {
                                          ref
                                              .watch(fileNotifier.notifier)
                                              .pickFile(context);
                                        },
                                        text: 'اضف فيديو المحاضره',
                                      ),
                                    ],
                                  ),
                                )
                              : ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: context.screenHeight / 4,
                                    minWidth: context.screenWidth,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: VideoPlayerWidget(
                                        videoPath:
                                            ref.watch(fileNotifier)!.path,
                                        fromNetwotk: false),
                                  ),
                                ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(),
                          ),
                          margin: EdgeInsets.all(4.w),
                          child: IconButton(
                              onPressed: () {
                                ref
                                    .watch(fileNotifier.notifier)
                                    .pickFile(context);
                              },
                              icon: Icon(
                                Icons.video_call_outlined,
                                color: Colors.grey[800],
                                size: 20.h,
                              )),
                        )
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer(builder: (_, ref, child) {
                    if (ref.watch(isLoading)) {
                      return const CustomIndicator();
                    } else {
                      return CustomButton(
                          onTap: () {
                            ref
                                .watch(lecturesRepoProvider)
                                .uploadVideo(
                                  name: titleController.text.trim(),
                                  video:
                                      ref.watch(fileNotifier.notifier).state!,
                                ).then((value) {
                        ref
                            .watch(notificationRepoProvider)
                            .sendPremiumNotification(
                              'محاضره جديده',
                              '${titleController.text.trim()} 📽📸📽',
                              notifcationData: NotifcationModel(
                                time: DateTime.now().toString(),
                              ),
                            );
                      })
                                .then((value) => Navigator.pop(_));
                          },
                          text: 'إضافه الحلقه');
                    }
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
