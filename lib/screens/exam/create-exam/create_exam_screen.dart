import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'exam_info_screen.dart';
import 'add_questions_screen.dart';
import 'submit_exam_screen.dart';

class CreateExamScreen extends StatelessWidget {
  static const String routeName = "/create-exam-screen";
  CreateExamScreen({super.key});

  PageController _pageController = PageController(initialPage: 0);
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
          ExamInfoScreen(
            onNextPressed: () => _onNextPressed(1),
            onPreviousPressed: () => print('first index'),
          ),
          AddQuestionsScreen(
              onNextPressed: () => _onNextPressed(2),
              onPreviousPressed: () => _onNextPressed(0)),
          SubmitExamScreen(
              onNextPressed: () => print('Last index'),
              onPreviousPressed: () => _onNextPressed(1)),
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
}
