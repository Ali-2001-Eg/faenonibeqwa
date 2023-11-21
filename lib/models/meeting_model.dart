// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class MeetingModel extends Equatable {
  final String title;
  final bool isBrodcater;
  final String uid;
  final String username;
  final DateTime startedAt;
  final int viewers;
  final String channelId;
  const MeetingModel({
    required this.title,
    required this.isBrodcater,
    required this.uid,
    required this.username,
    required this.startedAt,
    required this.viewers,
    required this.channelId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'uid': uid,
      'isBrodcater': isBrodcater,
      'username': username,
      'startedAt': startedAt.millisecondsSinceEpoch,
      'viewers': viewers,
      'channelId': channelId,
    };
  }

  factory MeetingModel.fromMap(Map<String, dynamic> map) {
    return MeetingModel(
      title: map['title'] as String,
      uid: map['uid'] as String,
      username: map['username'] as String,
      startedAt: DateTime.fromMillisecondsSinceEpoch(map['startedAt'] as int),
      viewers: map['viewers'] as int,
      isBrodcater: map['isBrodcater'] as bool,
      channelId: map['channelId'] as String,
    );
  }

  @override
  List<Object> get props => [
        title,
        uid,
        username,
        startedAt,
        viewers,
        channelId,
        isBrodcater,
      ];
}
