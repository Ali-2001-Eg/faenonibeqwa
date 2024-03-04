// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:faenonibeqwa/utils/extensions/string_extension.dart';

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
  // final int? streamJoined;
  const UserModel({
    required this.name,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.isAdmin,
    required this.notificationToken,
    required this.isPremium,
    this.planEnum = PlanEnum.notSubscribed,
    this.timeToFinishSubscribtion,
    this.freePlanEnded,
    // this.streamJoined = 0,
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
      planEnum,
      freePlanEnded,
      timeToFinishSubscribtion,
      // streamJoined,
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
      'planEnum': planEnum!.type,
      'freePlanEnded': freePlanEnded,
      "timeToFinishSubscribtion": timeToFinishSubscribtion,
      // 'streamsJoined': streamJoined,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      photoUrl: map['photoUrl'] as String,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] as bool,
      freePlanEnded: map['freePlanEnded'] as bool? ?? false,
      notificationToken: map['notificationToken'] as String,
      isPremium: map['premium'] as bool,
      timeToFinishSubscribtion: map['timeToFinishSubscribtion'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timeToFinishSubscribtion'])
          : null,
      planEnum: map['planEnum'] != null
          ? (map['planEnum'] as String).toEnum()
          : PlanEnum.notSubscribed,

      // streamJoined: map['streamJoined'] != null
      //     ? (map['streamJoined'] as int)
      //     : 0,
    );
  }
}
