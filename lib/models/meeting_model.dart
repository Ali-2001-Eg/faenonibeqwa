// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class MeetingModel extends Equatable {
  final String title;
  // final bool isBrodcater;
  final String uid;
  final String username;
  final DateTime endsAt;
  final List<String> viewers;
  final String channelId;
  const MeetingModel({
    required this.title,
    // required this.isBrodcater,
    required this.uid,
    required this.username,
    required this.endsAt,
    required this.viewers,
    required this.channelId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      // 'isBrodcater': isBrodcater,
      'uid': uid,
      'username': username,
      'startedAt': endsAt.millisecondsSinceEpoch,
      'viewers': viewers,
      'channelId': channelId,
    };
  }

  factory MeetingModel.fromMap(Map<String, dynamic> map) {
    return MeetingModel(
      title: map['title'] as String,
      // isBrodcater: map['isBrodcater'] as bool,
      uid: map['uid'] as String,
      username: map['username'] as String,
      endsAt: DateTime.fromMillisecondsSinceEpoch(map['startedAt'] as int),
      viewers: List<String>.from((map['viewers'])),
      channelId: map['channelId'] as String,
    );
  }

  @override
  List<Object> get props {
    return [
      title,
      // isBrodcater,
      uid,
      username,
      endsAt,
      viewers,
      channelId,
    ];
  }
}
