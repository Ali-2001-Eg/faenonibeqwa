import 'package:equatable/equatable.dart';

class MeetingModel extends Equatable {
  final String id;
  final String admin;
  final String adminPhotoUrl;
  final List<String> audience;
  final bool timeEnded;
  const MeetingModel({
    required this.id,
    required this.admin,
    required this.adminPhotoUrl,
    required this.audience,
    required this.timeEnded,
  });

  @override
  List<Object> get props => [id, admin, adminPhotoUrl, audience];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'admin': admin,
      'adminPhotoUrl': adminPhotoUrl,
      'audience': audience.toSet().toList(),
      'timeEnded': timeEnded
    };
  }

  factory MeetingModel.fromMap(Map<String, dynamic> map) {
    return MeetingModel(
        id: map['id'] as String,
        admin: map['admin'] as String,
        adminPhotoUrl: map['adminPhotoUrl'] as String,
        timeEnded: map['timeEnded'] as bool,
        audience: List<String>.from(
          (map['audience'] as List<String>).toSet().toList(),
        ));
  }
}
