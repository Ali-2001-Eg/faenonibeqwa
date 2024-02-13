// ignore_for_file: avoid_print

import 'dart:io';

import 'package:faenonibeqwa/screens/exam/create-exam/add_questions_screen.dart';
import 'package:faenonibeqwa/screens/exam/create-exam/exam_info_screen.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/exam_model.dart';
import '../../../utils/base/question_z.dart';
import '../../../utils/providers/app_providers.dart';
import 'exam_sammary_screen.dart';

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
  DateTime selectedDateTime = DateTime.now();

  final TextEditingController _timeMinutesController = TextEditingController();
  //second page
  List<QuestionZ> questions = [QuestionZ()];
  File? examImage;
  DateTime _deadlineTime = DateTime.now();
  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _totalGradeController.dispose();

    _timeMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('day is ${_deadlineTime.day}');
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
            deadlineTime: _deadlineTime,
            pickExamImage: pickExamImage,
            timeMinutesController: _timeMinutesController,
            selectDeadline: (BuildContext context) {
              _selectDateTime(context);
            },
          ),
          //second page
          AddQuestionScreen(
            onNextPressed: (index) {
              _storeQuestioImages().then((value) => _onNextPressed(index));
            },
            questions: questions,
          ),

          if (_totalGradeController.text.trim().isNotEmpty &&
              _timeMinutesController.text.trim().isNotEmpty &&
              examImage != null &&
              _deadlineTime != DateTime.now())

            //third page
            ExamSammaryScreen(
              exam: ExamModel(
                id: '0',
                examTitle: _titleController.text.trim(),
                examDescription: _descriptionController.text.trim(),
                totalGrade: int.parse(_totalGradeController.text.trim()),
                deadlineTime: _deadlineTime,
                timeMinutes: int.parse(_timeMinutesController.text.trim()),
                examImageUrl: examImage!.path,
                questions: questions.map((e) => e.convertToQuestion()).toList(),
              ),
              onSubmitted: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, MainScreen.routeName, (route) => false);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: _deadlineTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_deadlineTime),
      );

      if (pickedTime != null) {
        setState(() {
          _deadlineTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _storeQuestioImages() async {
    ref.read(isLoading.notifier).update((state) => true);
    for (var i = 0; i < questions.length; i++) {
      var element = questions[i];
      if (element.questionImage != null) {
        await ref
            .read(firebaseStorageRepoProvider)
            .storeFileToFirebaseStorage('examImageUrl/images/',
                (i + 1).toString(), File(element.questionImage!.path))
            .then((value) {
          setState(() {
            element.imageUrl = value;
          });
        });
      }
    }
    if (context.mounted) {
      _storeExamData(context).then(
          (value) => ref.read(isLoading.notifier).update((state) => false));
    }
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
          deadlineTime: _deadlineTime,
          timeMinutes: int.parse(_timeMinutesController.text),
          image: examImage!,
          context: context,
          question: quiz,
        )
        .then((value) => print('done'));
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
