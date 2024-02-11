// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';


import '../utils/enums/plan_enum.dart';

class UserModel extends Equatable {
  final String name;
  final String uid;
  final String photoUrl;
  final String email;
  final bool isAdmin;
  final String notificationToken;
  final bool isPremium;
  final bool? freePlanEnded;
  final PlanEnum? planEnum;
  final DateTime? timeToFinishSubscribtion;
  final int? streamsJoined;
  const UserModel({
    required this.name,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.isAdmin,
    required this.notificationToken,
    required this.isPremium,
    this.freePlanEnded = false,
    this.planEnum = PlanEnum.notSubscribed,
    this.timeToFinishSubscribtion,
    this.streamsJoined = 0,
  });

  @override
  List<Object?> get props {
    return [
      name,
      uid,
      photoUrl,
      email,
      isAdmin,
      notificationToken,
      isPremium,
      freePlanEnded,
      planEnum,
      timeToFinishSubscribtion,
      streamsJoined,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'photoUrl': photoUrl,
      'email': email,
      'isAdmin': isAdmin,
      'notificationToken': notificationToken,
      'premium': isPremium,
      'freePlanEnded': freePlanEnded,
      'planEnum': planEnum?.type,
      'timeToFinishSubscribtion':
          timeToFinishSubscribtion?.millisecondsSinceEpoch,
      'streamsJoined': streamsJoined,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      photoUrl: map['photoUrl'] as String,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] as bool,
      notificationToken: map['notificationToken'] as String,
      isPremium: map['premium'] as bool,
      freePlanEnded:
          map['freePlanEnded'] != null ? map['freePlanEnded'] as bool : null,
      planEnum: map['planEnum'] != null
          ? (map['planEnum'] as PlanEnum)
          : PlanEnum.notSubscribed,
      timeToFinishSubscribtion: map['timeToFinishSubscribtion'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['timeToFinishSubscribtion'] as int)
          : null,
      streamsJoined:
          map['streamsJoined'] != null ? map['streamsJoined'] as int : 0,
    );
  }

  UserModel copyWith({
    String? name,
    String? uid,
    String? photoUrl,
    String? email,
    bool? isAdmin,
    String? notificationToken,
    bool? isPremium,
    bool? freePlanEnded,
    PlanEnum? planEnum,
    DateTime? timeToFinishSubscribtion,
    int? streamsJoined,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      notificationToken: notificationToken ?? this.notificationToken,
      isPremium: isPremium ?? this.isPremium,
      freePlanEnded: freePlanEnded ?? this.freePlanEnded,
      planEnum: planEnum ?? this.planEnum,
      timeToFinishSubscribtion:
          timeToFinishSubscribtion ?? this.timeToFinishSubscribtion,
      streamsJoined: streamsJoined ?? this.streamsJoined,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
