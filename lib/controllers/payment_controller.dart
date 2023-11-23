import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/payment_repo.dart';

class PaymenController {
  final PaymentRepo paymentRepo;

  PaymenController(this.paymentRepo);

  Future<void> getPaymentAuth() => paymentRepo.getAuthPayment();
  Future<void> getOrderId({required num price}) =>
      paymentRepo.getOrderId(price: price);
}

final paymentControllerProvider = Provider((ref) {
  return PaymenController(ref.read(paymentRepoProvider));
});
