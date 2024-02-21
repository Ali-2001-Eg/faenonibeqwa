import 'package:equatable/equatable.dart';

class ExamModel extends Equatable {
  final String id;
  final String examTitle;
  final String examDescription;
  final int totalGrade;
  // final DateTime deadlineTime;
  final int timeMinutes;
  // final String examImageUrl;
  final List<Question> questions;
  const ExamModel({
    required this.id,
    required this.examTitle,
    required this.examDescription,
    required this.totalGrade,
    // required this.deadlineTime,
    required this.timeMinutes,
    // required this.examImageUrl,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'examTitle': examTitle,
      'examDescription': examDescription,
      'totalGrade': totalGrade,
      // 'deadlineTime': deadlineTime.millisecondsSinceEpoch,
      'timeMinutes': timeMinutes,
      // 'examImageUrl': examImageUrl,
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      id: map['id'] as String,
      examTitle: map['examTitle'] as String,
      examDescription: map['examDescription'] as String,
      totalGrade: map['totalGrade'] as int,
      // deadlineTime:
      //     DateTime.fromMillisecondsSinceEpoch(map['deadlineTime'] as int),
      timeMinutes: map['timeMinutes'] as int,
      // examImageUrl: map['examImageUrl'] as String,
      questions: const [],
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      examTitle,
      examDescription,
      totalGrade,
      // deadlineTime,
      timeMinutes,
      // examImageUrl,
      questions,
    ];
  }
}

// ignore: must_be_immutable
class Question extends Equatable {
  final String body;
  final String id;
  final String correctAnswerIdentifier;
  final String? questionImage;
  String? selectedAnswerIdentifier;
  final List<Answers> answers;
  Question({
    required this.body,
    required this.id,
    required this.correctAnswerIdentifier,
    this.questionImage,
    this.selectedAnswerIdentifier,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'body': body,
      'correctAnswerIdentifier': correctAnswerIdentifier,
      'questionImage': questionImage,
      'id': id,
      'selectedAnswer': selectedAnswerIdentifier
    };
  }
  
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        body: map['body'],
        id: map['id'],
        correctAnswerIdentifier: map['correctAnswerIdentifier'],
        questionImage: map['questionImage'],
        answers: const []);
  }

  @override
  List<Object> get props {
    return [
      body,
      id,
      correctAnswerIdentifier,
      answers,
    ];
  }
}

class Answers extends Equatable {
  final String identifier;
  final String answer;
  const Answers({
    required this.identifier,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'identifier': identifier,
      'answer': answer,
    };
  }

  factory Answers.fromMap(Map<String, dynamic> map) {
    return Answers(
      identifier: map['identifier'] as String,
      answer: map['answer'] as String,
    );
  }

  @override
  List<Object> get props => [identifier, answer];
}
