
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String uid;
  final String photoUrl;
  final String email;
  final bool isAdmin;
  final String notificationToken;
  const UserModel({
    required this.name,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.isAdmin,
    required this.notificationToken,
  });

  @override
  List<Object> get props {
    return [
      name,
      uid,
      photoUrl,
      email,
      isAdmin,
      notificationToken,
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
    );
  }

  UserModel copyWith({
    String? name,
    String? uid,
    String? photoUrl,
    String? email,
    bool? isAdmin,
    String? notificationToken,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      notificationToken: notificationToken ?? this.notificationToken,
    );
  }

}
