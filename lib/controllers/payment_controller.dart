import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/payment_repo.dart';

class PaymenController {
  final PaymentRepo paymentRepo;

  PaymenController(this.paymentRepo);

  Future<void> getPaymentAuth() => paymentRepo.getAuthPayment();
  Future<void> getOrderId({required num price,required BuildContext context,required String phoneNumber}) =>
      paymentRepo.getOrderId(price: price, context: context,phoneNumber: phoneNumber);
}

final paymentControllerProvider = Provider((ref) {
  return PaymenController(ref.read(paymentRepoProvider));
});
