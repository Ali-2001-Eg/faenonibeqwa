import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/enums/plan_enum.dart';
import '../utils/providers/app_providers.dart';

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
      //to be updated after finishing this phase
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

  Future<bool> get subscriptionEnded {
     Completer<bool> completer = Completer<bool>();
    ref.read(authRepoProvider).getUserData.listen((event) {
    bool ended =false; 
       ended = event!.timeToFinishSubscribtion!.isBefore(DateTime.now());
       if(completer.isCompleted){
        
       }
          completer.complete(ended);
    });
      return completer.future;
   
    }
  PlanEnum get subscriptionPlan =>
      ref.read(userDataProvider).value!.planEnum ?? PlanEnum.notSubscribed;

  Future<void> get changePlanAfterEndDate async =>
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'plan': PlanEnum.notSubscribed.type,
        'premium': false,
        'freePlanEnded': true
      });
  Future<void> changePlansAmount(
      String monthPlan, String semiAnnuallPlan, String annuallPlan) async {
    ref.read(isLoading.notifier).update((state) => true);
    await firestore.collection('plans').doc('plans').set({
      'monthPlan': monthPlan,
      'semiAnnuallPlan': semiAnnuallPlan,
      'annuallPlan': annuallPlan,
    });
    ref.read(isLoading.notifier).update((state) => false);
  }

  Stream<String> planPrice(PlanEnum plan) {
    // ref.read(isLoading.notifier).update((state) => true);
    return firestore.collection('plans').doc('plans').snapshots().map((event) {
      String price = '';
      if (event.exists) {
        switch (plan) {
          case PlanEnum.notSubscribed:
            price = '0';
            break;
          case PlanEnum.freeTrail:
            price = '0';
            break;
          case PlanEnum.monthly:
            price = '${event.data()!['monthPlan']}00';
            break;
          case PlanEnum.semiAnnually:
            price = '${event.data()!['semiAnnuallPlan']}00';
            break;
          case PlanEnum.annually:
            price = '${event.data()!['annuallPlan']}00';
            break;
        }
      }
      // ref.read(isLoading.notifier).update((state) => false);
      return price;
    });
  }
}
