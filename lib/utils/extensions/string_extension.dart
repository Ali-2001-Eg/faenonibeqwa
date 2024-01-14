import '../enums/plan_enum.dart';

extension ConvertPlan on String {
  PlanEnum toEnum() {
    switch (this) {
      case 'notSubscribed':
        return PlanEnum.notSubscribed;
      case 'freeTrail':
        return PlanEnum.freeTrail;
      case 'monthly':
        return PlanEnum.monthly;
      case 'semiAnnually':
        return PlanEnum.semiAnnually;
      case 'annually':
        return PlanEnum.annually;
      default:
        return PlanEnum.notSubscribed;
    }
  }

  int toInt() => int.parse(this);
}
