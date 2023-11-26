import 'package:equatable/equatable.dart';

class BookTripModel extends Equatable {
  final String? id;
  final num tripPrice;
  final bool success;
  final num totalPrice;
  final int numberOfPeople;
  final String email;
  final String phoneNumber;
  final String userName;
  final DateTime createdAt;
  const BookTripModel({
    this.id,
    required this.tripPrice,
    required this.success,
    required this.totalPrice,
    required this.numberOfPeople,
    required this.email,
    required this.phoneNumber,
    required this.userName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tripPrice': tripPrice,
      'success': success,
      'totalPrice': totalPrice,
      'numberOfPeople': numberOfPeople,
      'email': email,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'ceatedAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory BookTripModel.fromMap(Map<String, dynamic> map) {
    return BookTripModel(
      id: map['id'] as String,
      tripPrice: map['tripPrice'] as num,
      success: map['success'] as bool,
      totalPrice: map['totalPrice'] as num,
      numberOfPeople: map['numberOfPeople'] as int,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      userName: map['userName'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  List<Object> get props {
    return [
      id!,
      tripPrice,
      success,
      totalPrice,
      numberOfPeople,
      email,
      phoneNumber,
      userName,
      createdAt,
    ];
  }
}
