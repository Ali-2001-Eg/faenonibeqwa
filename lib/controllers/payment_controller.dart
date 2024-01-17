import 'package:faenonibeqwa/utils/enums/plan_enum.dart';

import '../repositories/payment_repo.dart';

class PaymenController {
  final PaymentRepo paymentRepo;

  PaymenController(this.paymentRepo);

  Future<void> subscibe({required PlanEnum planType}) =>
      paymentRepo.subscribe(planType);
  bool get subscriptionEnded => paymentRepo.subscriptionEnded;
  PlanEnum get planType => paymentRepo.subscriptionPlan;
  Future<void> get changePlanAfterEndDate => paymentRepo.changePlanAfterEndDate;
}
