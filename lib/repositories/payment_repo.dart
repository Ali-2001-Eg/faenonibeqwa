// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/enums/plan_enum.dart';

class PaymentRepo {
  final ProviderRef ref;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  PaymentRepo(this.ref, this.firestore, this.auth);

  //for subsicription
  Future<void> subscribe(PlanEnum planType) async {
    Duration duration = _determineEndSubsicriptionTime(planType);
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'premium': true,
      'timeToFinishSubscribtion':
          DateTime.now().add(duration).millisecondsSinceEpoch,
      'plan': planType.type,
    });
  }

  Duration _determineEndSubsicriptionTime(PlanEnum planType) {
    Duration duration;
    switch (planType) {
      case PlanEnum.freeTrail:
        duration = const Duration(days: 15);
        break;
      case PlanEnum.monthly:
        duration = const Duration(days: 30);
        break;
      case PlanEnum.semiAnnually:
        duration = const Duration(days: 100);
        break;
      case PlanEnum.annually:
        duration = const Duration(days: 365);
        break;
      case PlanEnum.notSubscribed:
        //to be ignored
        duration = const Duration(days: 0);
        break;
    }
    return duration;
  }
}

final paymentRepoProvider = Provider((ref) =>
    PaymentRepo(ref, FirebaseFirestore.instance, FirebaseAuth.instance));
final firstToken = StateProvider<String>((ref) => "");
final finalToken = StateProvider<String>((ref) => "");
final orderID = StateProvider<int>((ref) => 0);
final loadingFinalToken = StateProvider<bool>((ref) => false);
