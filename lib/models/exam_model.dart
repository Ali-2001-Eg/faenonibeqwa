import 'package:equatable/equatable.dart';

class ExamModel extends Equatable {
  final String id;
  final String examTitle;
  final double totalGrade;
  final DateTime deadlineTime;
  final int timeMinutes;
  final String examImageUrl;
  final List<Question> questions;
  const ExamModel({
    required this.id,
    required this.examTitle,
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
  List<Object> get props => [
        id,
        examTitle,
        totalGrade,
        deadlineTime,
        timeMinutes,
        examImageUrl,
        questions,
      ];
}

class Question extends Equatable {
  final String title;
  final String correctAnswerIdentifier;
  final String? selectedAnswer;
  final List<Answers> answers;
  const Question({
    required this.title,
    required this.correctAnswerIdentifier,
    this.selectedAnswer,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'correctAnswer': correctAnswerIdentifier,
      'selectedAnswer': selectedAnswer,
      'answers': answers.map((x) => x.toMap()).toList(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      title: map['title'] as String,
      correctAnswerIdentifier: map['correctAnswer'] as String,
      selectedAnswer: map['selectedAnswer'] != null
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
  List<Object> get props => [title, correctAnswerIdentifier, answers];
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
