//to grab question data
import 'package:flutter/material.dart';

import '../../models/exam_model.dart';

class QuestionZ {
  TextEditingController questionBodyController = TextEditingController();
  List<TextEditingController> answerControllers =
      List.generate(4, (index) => TextEditingController());
  int correctAnswerIndex = 0;
  Question convertToQuestion() {
    List<Answers> answersList = List.generate(
      4,
      (index) => Answers(
        identifier: (index + 1).toString(),
        answer: answerControllers[index].text,
      ),
    );

    return Question(
      body: questionBodyController.text,
      correctAnswerIdentifier: answersList[correctAnswerIndex].identifier,
      answers: answersList,
    );
  }
}