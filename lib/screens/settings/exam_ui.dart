import 'package:faenonibeqwa/utils/base/app_images.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'widgets/question_anwsers.dart';
import 'widgets/question_details.dart';
import 'widgets/quiz_appbar.dart';

class QuizUI extends StatefulWidget {
  const QuizUI({super.key});

  @override
  State<QuizUI> createState() => _QuizUIState();
}

class _QuizUIState extends State<QuizUI> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff004840),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView(
            children: [
              const QuizAppBar(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const QuestionDetails(),
                    const SizedBox(height: 15),
                    const QuestionAnswers(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          width: 100,
                          onTap: () {},
                          text: 'التالى',
                        ),
                        CustomButton(
                          width: 100,
                          onTap: () {},
                          text: 'السابق',
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
