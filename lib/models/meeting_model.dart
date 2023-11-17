

import 'package:equatable/equatable.dart';

class MeetingModel extends Equatable {


final String title;
  final String image;
  final String uid;
  final String username;
  final DateTime startedAt;
  final int viewers;
  final String channelId;
  const MeetingModel({
    required this.title,
    required this.image,
    required this.uid,
    required this.username,
    required this.startedAt,
    required this.viewers,
    required this.channelId,
  });

 



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'image': image,
      'uid': uid,
      'username': username,
      'startedAt': startedAt.millisecondsSinceEpoch,
      'viewers': viewers,
      'channelId': channelId,
    };
  }

  factory MeetingModel.fromMap(Map<String, dynamic> map) {
    return MeetingModel(
      title: map['title'] as String,
      image: map['image'] as String,
      uid: map['uid'] as String,
      username: map['username'] as String,
      startedAt: DateTime.fromMillisecondsSinceEpoch(map['startedAt'] as int),
      viewers: map['viewers'] as int,
      channelId: map['channelId'] as String,
    );
  }

  

  @override
  List<Object> get props => [
      title,
      image,
      uid,
      username,
      startedAt,
      viewers,
      channelId,
    ];
}
