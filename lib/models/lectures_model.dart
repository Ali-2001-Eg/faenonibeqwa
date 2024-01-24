

import 'package:equatable/equatable.dart';

class LecturesModel extends Equatable {
  final String name;
  final String id;
  final String lectureUrl;
  final String lectureThumbnail;
  final List<String> audienceUid;
  const LecturesModel({
    required this.name,
    required this.id,
    required this.lectureUrl,
    required this.lectureThumbnail,
    required this.audienceUid,
  });
  

  @override
  List<Object> get props {
    return [
      name,
      id,
      lectureUrl,
      lectureThumbnail,
      audienceUid,
    ];
  }

  LecturesModel copyWith({
    String? name,
    String? id,
    String? lectureUrl,
    String? lectureThumbnail,
    List<String>? audienceUid,
  }) {
    return LecturesModel(
      name: name ?? this.name,
      id: id ?? this.id,
      lectureUrl: lectureUrl ?? this.lectureUrl,
      lectureThumbnail: lectureThumbnail ?? this.lectureThumbnail,
      audienceUid: audienceUid ?? this.audienceUid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'lectureUrl': lectureUrl,
      'lectureThumbnail': lectureThumbnail,
      'audienceUid': audienceUid,
    };
  }

  factory LecturesModel.fromMap(Map<String, dynamic> map) {
    return LecturesModel(
      name: map['name'] as String,
      id: map['id'] as String,
      lectureUrl: map['lectureUrl'] as String,
      lectureThumbnail: map['lectureThumbnail'] as String,
      audienceUid: List<String>.from((map['audienceUid'] as List<String>),
    ));
  }

  
}
