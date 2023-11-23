import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

import '../utils/base/constants.dart';
import '../utils/shared/data/api_client.dart';

class PaymentRepo extends ChangeNotifier {
  final ProviderRef ref;

  PaymentRepo(this.ref);

  Future<void> getAuthPayment() async {
    await ApiClient.postData(
      url: AppConstants.baseUrl + AppConstants.authTokenUrl,
      data: {
        "api_key": AppConstants.apiKey,
      },
    ).then((value) {
      ref.read(firstToken.state).update((state) => value.data['token']);
      notifyListeners();
      log('First Token ${ref.read(firstToken.state).state}');
    }).catchError((error) {
      log(error);
    });
  }

  Future<void> getOrderId({
    required num price,
  }) async {
    await ApiClient.postData(
      url: AppConstants.baseUrl + AppConstants.orderID,
      data: {
        "auth_token": ref.read(firstToken.state).state,
        "delivery_needed": "false",
        "amount_cents": price,
        "currency": "EGP",
        "items": []
      },
    ).then((value) async {
      ref.read(orderID.state).update((state) => value.data['id']);
      ref.read(loadingFinalToken.state).update((state) => true);
      notifyListeners();
      _getPaymentRequest(
        price: price,
      ).then((value) =>
          ref.read(loadingFinalToken.state).update((state) => false));
      notifyListeners();
      log('Order ${ref.read(orderID.state).state}');
    }).catchError((error) {
      log(error.toString());
    });
  }

  Future<void> _getPaymentRequest({
    required num price,
  }) async {
    await ApiClient.postData(
      url: AppConstants.baseUrl + AppConstants.paymentKeyRequest,
      data: {
        "auth_token": ref.watch(firstToken.state).state,
        "amount_cents": price,
        "expiration": 3600,
        "order_id": ref.watch(orderID.state).state,
        "billing_data": {
          "apartment": "NA",
          "email": "NA",
          "floor": "NA",
          "first_name": "NA",
          "street": "phone",
          "building": "NA",
          "phone_number": "NA",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "last_name": "NA",
          "state": "NA"
        },
        "currency": "EGP",
        "integration_id": AppConstants.integrationId
      },
    ).then((value) {
      ref.watch(finalToken.state).update((state) => value.data['token']);
      notifyListeners();
      log('finalToken ${ref.read(finalToken.state).state}');
    }).catchError((error) {
      log(error.toString());
    });
  }
}

final paymentRepoProvider = Provider((ref) => PaymentRepo(ref));
final firstToken = StateProvider<String>((ref) => "");
final finalToken = StateProvider<String?>((ref) => null);
final orderID = StateProvider<int>((ref) => 0);
final loadingFinalToken = StateProvider<bool?>((ref) => null);
