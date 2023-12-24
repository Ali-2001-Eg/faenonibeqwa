// ignore_for_file: avoid_print

import 'dart:io';

import 'package:faenonibeqwa/controllers/exam_controller.dart';
import 'package:faenonibeqwa/screens/exam/create-exam/add_questions_screen.dart';
import 'package:faenonibeqwa/screens/exam/create-exam/exam_info_screen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/shared/widgets/customSnackbar.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../models/exam_model.dart';
import '../../../utils/base/question_z.dart';
import 'submit_exam_screen.dart';

class CreateExamScreen extends ConsumerStatefulWidget {
  static const String routeName = "/create-exam-screen";
  const CreateExamScreen({super.key});

  @override
  ConsumerState<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends ConsumerState<CreateExamScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  //first page
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _totalGradeController = TextEditingController();
  final TextEditingController _deadlineTimeController = TextEditingController();
  final TextEditingController _timeMinutesController = TextEditingController();
  //second page
  List<QuestionZ> questions = [QuestionZ()];
  File? examImage;
  CroppedFile? questionImage;

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _totalGradeController.dispose();
    _deadlineTimeController.dispose();
    _timeMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(questions.map((e) => e.correctAnswerIndex));
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
          ExamInfoScreen(
            onNextPressed: _onNextPressed,
            titleController: _titleController,
            examImage: examImage,
            descriptionController: _descriptionController,
            totalGradeController: _totalGradeController,
            deadlineTimeController: _deadlineTimeController,
            pickExamImage: pickExamImage,
            timeMinutesController: _timeMinutesController,
          ),
          //second page
          AddQuestionScreen(
              onNextPressed: _onNextPressed, questions: questions),

          //third page
          SubmitExamScreen(
            body: Container(),
            onPreviousPressed: () => _onNextPressed(1),
            onSubmitted: () {
              _storeExamData(context).catchError((err) => customSnackbar(
                    context: context,
                    text: err.toString(),
                    color: Colors.redAccent,
                  ));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _storeExamData(BuildContext context) async {
    List<Question> quiz = [];
    for (var element in questions) {
      quiz.add(element.convertToQuestion());
    }

    await ref
        .read(examControllerProvider)
        .addExamInfoToFirebase(
          examDescription: _descriptionController.text.trim(),
          examTitle: _titleController.text.trim(),
          totalGrade: num.parse(_totalGradeController.text),
          deadlineTime: DateTime.now(),
          timeMinutes: int.parse(_timeMinutesController.text),
          image: examImage!,
          context: context,
          question: quiz,
        )
        .then((value) => print('done'))
        .catchError((err) => customSnackbar(
              context: context,
              text: err.toString(),
              color: Colors.redAccent,
            ));
  }

  void _onNextPressed(int pageNumber) {
    _pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void pickExamImage() async {
    File? pickedImage = await AppHelper.pickImage(context);
    setState(() {
      examImage = pickedImage;
    });
  }
}
