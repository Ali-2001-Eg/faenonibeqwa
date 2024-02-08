import 'package:equatable/equatable.dart';

class NotifcationModel extends Equatable {
  
  final String time;
  final String? status;
  final String? role;
  // final String? from;
  // final String? to;

  final String? id;
  const NotifcationModel({
  
    required this.time,
    this.status,
    this.role,
    // this.from,
    // this.to,
    this.id,
  });

  factory NotifcationModel.fromMap(Map<String, dynamic> map) {
    return NotifcationModel(
  
      time: map['time'] as String,
      status: map['status'] != null ? map['status'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      // from: map['from'] != null ? map['from'] as String : null,
      // to: map['to'] != null ? map['to'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
    
      'time': time,
      'status': status,
      'role': role,
      // 'from': from,
      // 'to': to,
      'id': id,
    };
  }

  @override
  List<Object?> get props {
    return [
    
      time,
      status,
      role,
      // from!,
      // to!,
      id!,
    ];
  }
}