import 'dart:io';

import 'package:faenonibeqwa/screens/exam/widgets/answer_list_view_builder_widget.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/shared/widgets/small_text.dart';

class QuestionContentWidget extends StatefulWidget {
  const QuestionContentWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuestionContentWidgetState createState() => _QuestionContentWidgetState();
}

class _QuestionContentWidgetState extends State<QuestionContentWidget>
    with AutomaticKeepAliveClientMixin {
  //auto keep alive to save
  int _selectedOption = 0;
  CroppedFile? _questionImage;
  final TextEditingController _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BigText(text: 'اختر نوع السؤال'),
          //radio buttons
          Row(
            children: [
              Radio(
                value: 0,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value as int;
                  });
                },
              ),
              const BigText(text: 'سؤال مقالي'),
            ],
          ),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value as int;
                  });
                },
              ),
              const BigText(text: 'الحق صوره للسؤال'),
            ],
          ),
          20.hSpace,
          //actions
          _selectedOption == 0
              ? CustomTextField(
                  controller: _questionController,
                )
              : _questionImage == null
                  ? Center(
                      child: CustomButton(
                        onTap: pickImage,
                        text: 'اختر صوره',
                      ),
                    )
                  : Column(
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 30.h,
                              maxHeight: 100.h,
                            ),
                            child: Image.file(File(_questionImage!.path))),
                        10.hSpace,
                        CustomTextField(
                          controller: _questionController,
                          hintText: 'السؤال',
                        )
                      ],
                    ),
          20.hSpace,
          const BigText(text: "الاجابات"),
          10.hSpace,
          //answers
          const AnswersListWiewBuilderWidget(),
        ],
      ),
    );
  }

  void pickImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const BigText(text: 'اختر مصدر الصوره'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                CroppedFile? image = await AppHelper.pickImage(context,
                    imageSource: ImageSource.camera);
                setState(() {
                  _questionImage = image;
                });
                print('image is $_questionImage');

                if (context.mounted) Navigator.pop(context);
              },
              child: const SmallText(text: 'كاميرا'),
            ),
            TextButton(
              onPressed: () async {
                CroppedFile? image = await AppHelper.pickImage(context,
                    imageSource: ImageSource.gallery);
                setState(() {
                  _questionImage = image;
                });
                print('image is $_questionImage');
                if (context.mounted) Navigator.pop(context);
              },
              child: const SmallText(text: 'المعرض'),
            ),
          ],
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
