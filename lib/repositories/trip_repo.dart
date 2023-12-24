// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/models/book_trip_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/models/trip_model.dart';

import '../utils/providers/storage_provider.dart';

class TripRepository extends ChangeNotifier {
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  TripRepository({
    required this.firestore,
    required this.ref,
  });

  Future<void> addTrip(
      String name, File imagePath, num price, String description) async {
    try {
      String image = await ref
          .read(firebaseStorageRepoProvider)
          .storeFileToFirebaseStorage('tripImages', imagePath);
      TripModel trip = TripModel(
        id: firestore.collection('trips').id,
        nameTrip: name,
        imageTrip: image,
        price: price,
        description: description,
      );
      log(trip.imageTrip);
      firestore.collection('trips').doc().set(trip.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<TripModel>> getTrip() {
    return firestore.collection('trips').snapshots().map((snapshot) {
      List<TripModel> tripLists = [];
      tripLists.clear();
      for (var item in snapshot.docs) {
        tripLists.add(TripModel.fromMap(item.data()));
      }
      return tripLists;
    });
  }

  Future<void> deleteTrip(String uid) async {
    try {
      await firestore.collection('trips').doc(uid).delete();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateTrip(TripModel tripModel) async {
    final document = firestore.collection('trips').doc(tripModel.id);
    tripModel.id = document.id;
    try {
      await document.update(tripModel.toMap());
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> savePaymentData({
    required num tripPrice,
    required bool success,
    required int numberOfPeople,
    required String phoneNumber,
  }) async {
    final bookTripModel = BookTripModel(
      tripPrice: tripPrice,
      success: success,
      totalPrice: tripPrice * numberOfPeople,
      numberOfPeople: numberOfPeople,
      email: ref.read(authControllerProvider).userInfo.email!,
      phoneNumber: phoneNumber,
      userName: ref.read(authControllerProvider).userInfo.displayName!,
      createdAt: DateTime.now(),
    );
    await firestore.collection('BookTrips').doc().set(bookTripModel.toMap());
  }
}

final tripRepoProvider = Provider(
    (ref) => TripRepository(firestore: FirebaseFirestore.instance, ref: ref));
