enum PlanEnum {
  notSubscribed('notSubscribed'),
  freeTrail('freeTrail'),
  monthly('monthly'),
  semiAnnually('semiAnnually'),
  annually('annually');

  const PlanEnum(this.type);
  final String type;
}
