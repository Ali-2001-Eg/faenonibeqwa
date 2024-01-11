import 'package:faenonibeqwa/utils/enums/plan_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/payment_repo.dart';

class PaymenController {
  final PaymentRepo paymentRepo;

  PaymenController(this.paymentRepo);

  Future<void> subscibe({required PlanEnum planType}) =>
      paymentRepo.subscribe(planType);
}

final paymentControllerProvider = Provider((ref) {
  return PaymenController(ref.read(paymentRepoProvider));
});
