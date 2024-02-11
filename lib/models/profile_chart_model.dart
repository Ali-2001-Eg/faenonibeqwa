// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:equatable/equatable.dart';

class ProfileCartModel extends Equatable {
  const ProfileCartModel(
    this.title,
    this.data,
  );
  final String title;
  final num data;

  ProfileCartModel copyWith({
    String? title,
    double? data,
  }) {
    return ProfileCartModel(
      title ?? this.title,
      data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'data': data,
    };
  }

  factory ProfileCartModel.fromMap(Map<String, dynamic> map) {
    return ProfileCartModel(
      map['title'] as String,
      map['data'] as double,
    );
  }

  @override
  List<Object> get props => [title, data];
}
