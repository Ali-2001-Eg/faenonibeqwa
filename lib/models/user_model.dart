// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String uid;
  final String photoUrl;
  final String email;
  const UserModel({
    required this.name,
    required this.uid,
    required this.photoUrl,
    required this.email,
  });

  @override
  List<Object> get props => [name, uid, photoUrl];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'photoUrl': photoUrl,
      'email':email
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      photoUrl: map['photoUrl'] as String,
      email: map['email'] as String,
    );
  }

}
