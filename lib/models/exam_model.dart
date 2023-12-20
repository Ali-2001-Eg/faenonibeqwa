import 'package:equatable/equatable.dart';

class ExamModel extends Equatable {
  final String id;
  final String? examTitle;
  final String? examDescription;
  final double totalGrade;
  final DateTime deadlineTime;
  final int timeMinutes;
  final String examImageUrl;
  final List<Question> questions;
  const ExamModel({
    required this.id,
    this.examTitle,
    this.examDescription,
    required this.totalGrade,
    required this.deadlineTime,
    required this.timeMinutes,
    required this.examImageUrl,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'examTitle': examTitle,
      'examDescription': examDescription,
      'totalGrade': totalGrade,
      'deadlineTime': deadlineTime.millisecondsSinceEpoch,
      'timeMinutes': timeMinutes,
      'examImageUrl': examImageUrl,
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      id: map['id'] as String,
      examTitle: map['examTitle'] as String,
      examDescription: map['examDescription'] as String,
      totalGrade: map['totalGrade'] as double,
      deadlineTime:
          DateTime.fromMillisecondsSinceEpoch(map['deadlineTime'] as int),
      timeMinutes: map['timeMinutes'] as int,
      examImageUrl: map['examImageUrl'] as String,
      questions: List<Question>.from(
        (map['questions'] as List<int>).map<Question>(
          (x) => Question.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      examTitle!,
      examDescription!,
      totalGrade,
      deadlineTime,
      timeMinutes,
      examImageUrl,
      questions,
    ];
  }
}

class Question extends Equatable {
  final String body;
  final String correctAnswerIdentifier;
  final String? questionImage;
  final String? selectedAnswerIdentifier;
  final List<Answers> answers;
  const Question({
    required this.body,
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
      'selectedAnswer': selectedAnswerIdentifier,
      'answers': answers.map((x) => x.toMap()).toList(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      body: map['body'] as String,
      correctAnswerIdentifier: map['correctAnswerIdentifier'] as String,
      questionImage:
          map['questionImage'] != null ? map['questionImage'] as String : null,
      selectedAnswerIdentifier: map['selectedAnswer'] != null
          ? map['selectedAnswer'] as String
          : null,
      answers: List<Answers>.from(
        (map['answers'] as List<int>).map<Answers>(
          (x) => Answers.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  List<Object> get props {
    return [
      body,
      correctAnswerIdentifier,
      questionImage!,
      selectedAnswerIdentifier!,
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
