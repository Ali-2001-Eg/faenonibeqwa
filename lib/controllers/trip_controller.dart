import 'package:faenonibeqwa/repositories/trip_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/trip_model.dart';

class TripController {
  final TripRepository tripRepository;

  TripController(this.tripRepository);
  Stream<List<TripModel>> getTrip() => tripRepository.getTrip();
  Future<void> deleteTrip(String uid) => tripRepository.deleteTrip(uid);
  Future<void> updateTrip(TripModel tripModel) =>
      tripRepository.updateTrip(tripModel);
  Future<void> addTrip(TripModel tripModel) =>
      tripRepository.addTrip(tripModel);
}

final tripControllerProvider = Provider((ref) {
  final tripRepo = ref.read(tripRepoProvider);
  return TripController(tripRepo);
});