// ignore_for_file: public_member_api_docs, sort_constructors_first


class TripModel {
  String? id;
  final String nameTrip;
  final String imageTrip;
  final num price;
  final String description;

  TripModel({
    this.id,
    required this.nameTrip,
    required this.imageTrip,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameTrip': nameTrip,
      'imageTrip': imageTrip,
      'price': price,
      'description': description,
    };
  }

  factory TripModel.fromMap(dynamic map) {
    return TripModel(
      id: map['id'] as String,
      nameTrip: map['nameTrip'] as String,
      imageTrip: map['imageTrip'] as String,
      price: map['price'] as num,
      description: map['description'] as String,
    );
  }
}

