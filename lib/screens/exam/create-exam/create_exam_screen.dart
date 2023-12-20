import 'dart:io';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/exam_model.dart';
import '../../../utils/base/app_helper.dart';
import '../../../utils/shared/widgets/big_text.dart';
import '../../../utils/shared/widgets/custom_button.dart';
import '../../../utils/shared/widgets/custom_text_field.dart';
import '../../../utils/shared/widgets/small_text.dart';
import '../widgets/page_view_widget.dart';
import 'submit_exam_screen.dart';

class CreateExamScreen extends StatefulWidget {
  static const String routeName = "/create-exam-screen";
  const CreateExamScreen({super.key});

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends State<CreateExamScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  //first page
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  //second page
  List<Widget> generatedWidgets = [];
  List<QuestionZ> questions = [QuestionZ()];
  final QuestionZ question = QuestionZ();

  CroppedFile? questionImage;
  int _selectedOption = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'إضافه اختبار'),
      resizeToAvoidBottomInset: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        pageSnapping: false,
        reverse: false,
        controller: _pageController,
        children: [
          //first page
          PageWidget(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SmallText(text: "عنوان الاختبار"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        controller: _titleController,
                        hintText: 'العنوان',
                      ),
                    ),
                    15.hSpace,
                    const SmallText(
                      text: "وصف الاختبار",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        controller: _descriptionController,
                        hintText: 'الوصف',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onSubmitted: () {
              _onNextPressed(1);
            },
          ),
          //second page
          PageWidget(
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
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
                                controller: questions[0].questionBodyController,
                              )
                            : questionImage == null
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
                                          child: Image.file(
                                              File(questionImage!.path))),
                                      10.hSpace,
                                      CustomTextField(
                                        controller:
                                            questions[0].questionBodyController,
                                        hintText: 'السؤال',
                                      )
                                    ],
                                  ),
                        20.hSpace,
                        const BigText(text: "الاجابات"),
                        10.hSpace,
                        //answers
                        ListView.separated(
                          itemCount: 4,
                          shrinkWrap: true,
                          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (_, i) => Padding(
                              padding: EdgeInsets.all(10.w),
                              child: Container()),
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // SmallText(text: index.toString(), fontWeight: FontWeight.w700),
                                Container(
                                    constraints: BoxConstraints(
                                      minWidth: 30,
                                      maxWidth: context.screenWidth - 60,
                                      maxHeight: 200,
                                      minHeight: 50,
                                    ),
                                    child: CustomTextField(
                                      controller:
                                          questions[0].answerControllers[index],
                                      hintText: index == 0
                                          ? 'أ'
                                          : index == 1
                                              ? 'ب'
                                              : index == 2
                                                  ? 'ج'
                                                  : 'د',
                                    ))
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (questions.length == 1)
                    Center(child: _addNewQuestionButton),
                  //added questions
                  if (questions.length > 1) ...[
                    ListView.builder(
                        itemCount: questions.length - 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
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
                                        controller: questions[index + 1]
                                            .questionBodyController,
                                      )
                                    : questionImage == null
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
                                                  child: Image.file(File(
                                                      questionImage!.path))),
                                              10.hSpace,
                                              CustomTextField(
                                                controller: questions[index + 1]
                                                        .answerControllers[
                                                    index + 1],
                                                hintText: 'السؤال',
                                              )
                                            ],
                                          ),
                                20.hSpace,
                                const BigText(text: "الاجابات"),
                                10.hSpace,
                                //answers
                                ListView.separated(
                                  itemCount: 4,
                                  shrinkWrap: true,
                                  // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (_, i) => Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Container()),
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // SmallText(text: index.toString(), fontWeight: FontWeight.w700),
                                        Container(
                                            constraints: BoxConstraints(
                                              minWidth: 30,
                                              maxWidth:
                                                  context.screenWidth - 60,
                                              maxHeight: 200,
                                              minHeight: 50,
                                            ),
                                            child: CustomTextField(
                                              controller: question
                                                  .answerControllers[index],
                                              hintText: index == 0
                                                  ? 'أ'
                                                  : index == 1
                                                      ? 'ب'
                                                      : index == 2
                                                          ? 'ج'
                                                          : 'د',
                                            ))
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                    Center(child: _addNewQuestionButton),
                  ]
                ],
              ),
            ),
            onPreviousPressed: () {
              _onNextPressed(0);
            },
            onSubmitted: () {
              _onNextPressed(2);
            },
          ),

          //third page
          SubmitExamScreen(
            onPreviousPressed: () => _onNextPressed(1),
            onSubmitted: () {
              print(questions[0].questionBodyController.text);
              ExamModel model = ExamModel(
                id: 'id',
                totalGrade: 60,
                deadlineTime: DateTime.now(),
                timeMinutes: 500,
                examImageUrl: '',
                questions: [],
              );
            },
          ),
        ],
      ),
    );
  }

  void _onNextPressed(int pageNumber) {
    _pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  CustomButton get _addNewQuestionButton {
    return CustomButton(
        onTap: () {
          // Generate a new widget and add it to the list

          setState(() {
            questions.add(QuestionZ());
          });
        },
        text: 'إضافه سؤال');
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
                  questionImage = image;
                });
                print('image is $widget.questionImage');

                if (context.mounted) Navigator.pop(context);
              },
              child: const SmallText(text: 'كاميرا'),
            ),
            TextButton(
              onPressed: () async {
                CroppedFile? image = await AppHelper.pickImage(context,
                    imageSource: ImageSource.gallery);
                setState(() {
                  questionImage = image;
                });
                print('image is $widget.questionImage');
                if (context.mounted) Navigator.pop(context);
              },
              child: const SmallText(text: 'المعرض'),
            ),
          ],
        );
      },
    );
  }
}
//to grab question data
class QuestionZ {
  TextEditingController questionBodyController = TextEditingController();
  List<TextEditingController> answerControllers =
      List.generate(4, (index) => TextEditingController());
}
