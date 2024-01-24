import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/shared/widgets/custom_text_field.dart';

class AddDocumentScreen extends StatefulWidget {
  static const String routeName = '/add-doc';
  const AddDocumentScreen({super.key});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: 'إضافه ملف'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BigText(text: 'اسم الملف'),
              20.hSpace,
              CustomTextField(
                controller: _titleController,
              ),
              30.hSpace,
              Consumer(builder: (context, ref, child) {
                if (ref.watch(pdfPathNotifier) != null) {
                  return const BigText(text: 'تم اختيار الملف بنجاح');
                } else {
                  return CustomButton(
                    text: 'لإضافه ملف جديد',
                    onTap: () {
                      ref.watch(pdfPathNotifier.notifier).pickFile(context);
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer(builder: (context, ref, child) {
        return FloatingActionButton(
          heroTag: 'upload',
          elevation: 0,
          onPressed: () {
            if (ref.watch(pdfPathNotifier) != null) {
              _uploadFile(ref, _titleController.text.trim(),
                  ref.watch(pdfPathNotifier)!);
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

  void _uploadFile(WidgetRef ref, String title, String filePath) {
    ref.read(paperRepoProvider).uploadPaper(title, filePath).then((value) =>
        Navigator.of(context)
            .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false));
  }
}
