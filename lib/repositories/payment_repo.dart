// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/screens/payment/visa_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/base/app_constants.dart';
import '../utils/shared/data/api_client.dart';

class PaymentRepo {
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

      log('First Token ${ref.read(firstToken.state).state}');
    }).catchError((error) {
      log(error.toString());
    });
  }

  Future<void> getOrderId({
    required num price,
    required String phoneNumber,
    required BuildContext context,
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

      log('OrderID ${ref.read(orderID.state).state}');
      await _getPaymentRequest(
        price: price,
        context: context,
        phoneNumber: phoneNumber,
      );
      // log('loading is ${ref.read(loadingFinalToken.state).state}');
    });
  }

  Future<void> _getPaymentRequest({
    required num price,
    required BuildContext context,
    required String phoneNumber,
  }) async {
    // ref.watch(loadingFinalToken.state).update((state) => true);
    // log('loading before ${ref.read(loadingFinalToken.state).state}');

    await ApiClient.postData(
      url: AppConstants.baseUrl + AppConstants.paymentKeyRequest,
      data: {
        "auth_token": ref.watch(firstToken.state).state,
        "amount_cents": price,
        "expiration": 3600,
        "order_id": ref.watch(orderID.state).state,
        "billing_data": {
          "apartment": "NA",
          "email": ref.watch(authControllerProvider).userInfo.uid,
          "floor": "NA",
          "first_name": "NA",
          "street": "phone",
          "building": "NA",
          "phone_number": phoneNumber,
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
    ).then((value) async {
      ref.read(finalToken.state).update((state) => value.data['token']);
      log('finalToken ${ref.read(finalToken.state).state}');

      if (context.mounted) {
        await Navigator.push(context, MaterialPageRoute(
          builder: (_) {
            return VisaCardView(
              finalToken: ref.read(finalToken.state).state,
            );
          },
        ));
      }
    }).catchError((error) {
      log(error.toString());
    });
  }
}

final paymentRepoProvider = Provider((ref) => PaymentRepo(ref));
final firstToken = StateProvider<String>((ref) => "");
final finalToken = StateProvider<String>((ref) => "");
final orderID = StateProvider<int>((ref) => 0);
final loadingFinalToken = StateProvider<bool>((ref) => false);
