import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notification_model.dart';
import '../../utils/shared/widgets/custom_text_field.dart';

class AddDocumentScreen extends StatefulWidget {
  static const String routeName = '/add-doc';
  const AddDocumentScreen(
      {super.key, required this.lectureId, required this.lectureName});
  final String lectureId;
  final String lectureName;
  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final TextEditingController _titleController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.lectureName);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: 'إضافه ملف'),
      body: Consumer(
        builder: (context, ref, child) {
          if (!ref.watch(isLoading)) {
            const BigText(
              text: 'loading',
            );
          }
          return Center(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BigText(text: 'لإضافه الملف'),
                  20.hSpace,
                  CustomTextField(
                    controller: _titleController,
                    hintText: 'اسم الملف',
                    keyBoardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 1,
                  ),
                  30.hSpace,
                  Align(
                    alignment: Alignment.center,
                    child: Consumer(builder: (context, ref, child) {
                      if (ref.watch(isLoading)) {
                        return const CustomIndicator();
                      } else if (ref.watch(pdfPathNotifier) != null) {
                        return const BigText(text: 'تم اختيار الملف بنجاح');
                      } else {
                        return CustomButton(
                          text: 'لإضافه ملف جديد',
                          onTap: () {
                            ref
                                .watch(pdfPathNotifier.notifier)
                                .pickFile(context);
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ));
        },
      ),
      floatingActionButton: Consumer(builder: (context, ref, child) {
        return FloatingActionButton(
          heroTag: 'upload',
          elevation: 0,
          onPressed: () {
            if (ref.watch(pdfPathNotifier) != null) {
              _uploadFile(ref, _titleController.text.trim(),
                      ref.watch(pdfPathNotifier)!, widget.lectureId)
                  .then((value) {
                ref.watch(notificationRepoProvider).sendPremiumNotification(
                      'ملف جديد عن المحاضره : ${widget.lectureName}',
                      '${_titleController.text.trim()} 💡📖📕💡',
                      notifcationData: NotifcationModel(
                        time: DateTime.now().toString(),
                      ),
                    );
              }).then((value) =>
                      Navigator.of(context).pop());
            } else {
              AppHelper.customSnackbar(
                  context: context, title: 'اضف كافه البيانات');
            }
          },
          child: const Icon(Icons.upload),
        );
      }),
    );
  }

  Future<void> _uploadFile(
      WidgetRef ref, String title, String filePath, String lectureId) async {
    ref
        .read(paperControllerProvider)
        .uploadPaper(title: title, filePath: filePath, lectureId: lectureId);
  }
}
