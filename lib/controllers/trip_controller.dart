import 'dart:io';

import 'package:faenonibeqwa/repositories/trip_repo.dart';

import '../models/trip_model.dart';

class TripController {
  final TripRepository tripRepository;

  TripController(this.tripRepository);
  Stream<List<TripModel>> getTrip() => tripRepository.getTrip();
  Future<void> deleteTrip(String uid) => tripRepository.deleteTrip(uid);
  Future<void> updateTrip(TripModel tripModel) =>
      tripRepository.updateTrip(tripModel);
  Future<void> addTrip({
    required String tripName,
    required File image,
    required num price,
    required String description,
  }) =>
      tripRepository.addTrip(tripName, image, price, description);

  Future<void> saveTripPayment({
    required num tripPrice,
    required bool success,
    required int numberOfPeople,
    required String phoneNumber,
  }) =>
      tripRepository.savePaymentData(
        tripPrice: tripPrice,
        success: success,
        numberOfPeople: numberOfPeople,
        phoneNumber: phoneNumber,
      );
}
