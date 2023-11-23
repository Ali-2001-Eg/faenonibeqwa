// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/models/trip_model.dart';

class TripRepository extends ChangeNotifier {
  final FirebaseFirestore firestore;
  TripRepository({
    required this.firestore,
  });

  Future<void> addTrip(TripModel tripModel) async {
    try {
      final document = firestore.collection('trips').doc();
      tripModel.id = document.id;
      await document.set(tripModel.toMap());
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
}

final tripRepoProvider =
    Provider((ref) => TripRepository(firestore: FirebaseFirestore.instance));
