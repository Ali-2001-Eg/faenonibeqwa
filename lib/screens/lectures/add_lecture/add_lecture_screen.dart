import 'package:faenonibeqwa/screens/lectures/widgets/video_player_widget.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          child: Column(
            children: [
              CustomTextField(controller: titleController),
              Consumer(
                builder: (context, ref, child) {
                  print('path ${ref.watch(videoNotifier)?.path}');
                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ref.watch(videoNotifier) == null
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
                                            .watch(videoNotifier.notifier)
                                            .pickVideo(context);
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
                                child: VideoPlayerWidget(
                                    videoPath: ref.watch(videoNotifier)!.path,
                                    fromNetwotk: false),
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
                                  .watch(videoNotifier.notifier)
                                  .pickVideo(context);
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
              Consumer(builder: (_, ref, child) {
                return ref.watch(isLoading.notifier).state
                    ? const CustomIndicator()
                    : CustomButton(
                        onTap: () {
                          ref
                              .watch(lecturesRepoProvider)
                              .uploadVideo(
                                name: titleController.text.trim(),
                                video: ref.watch(videoNotifier.notifier).state!,
                              )
                              .then((value) => Navigator.pop(_));
                        },
                        text: 'إضافه الحلقه');
              })
            ],
          ),
        ),
      ),
    );
  }
}
