// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class ExamHistoryModel extends Equatable {
  final String title;
  final String studentGrade;
  const ExamHistoryModel({
    required this.title,
    required this.studentGrade,
  });

  ExamHistoryModel copyWith({
    String? title,
    String? studentGrade,
  }) =>
      ExamHistoryModel(
        title: title ?? this.title,
        studentGrade: studentGrade ?? this.studentGrade,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title,
        'studentGrade': studentGrade,
      };

  factory ExamHistoryModel.fromMap(Map<String, dynamic> map) =>
      ExamHistoryModel(
        title: map['title'] as String,
        studentGrade: map['studentGrade'] as String,
      );

  @override
  List<Object> get props => [title, studentGrade];
}
