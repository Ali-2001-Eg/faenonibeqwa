import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/enums/plan_enum.dart';
import '../../../../utils/providers/app_providers.dart';
import 'plan_widget.dart';
class PaymentBody extends ConsumerStatefulWidget {
  const PaymentBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentBodyState();
}

class _PaymentBodyState extends ConsumerState<PaymentBody> {
  int selectedContainerIndex =
      -1; // Index of the selected container, -1 for none

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        //free trail
        // if (ref.watch(userDataProvider).value!.freePlanEnded == false)
        //   PlanWidget(
        //     index: 0,
        //     selectedIndex: selectedContainerIndex,
        //     title: 'تجربه مجانيه لمده 15 يوم',
        //     price: 'مجانا',
        //     onTap: _handleTap,
        //     unit: 'نصف شهر',
        //   ),
        //monthly
        PlanWidget(
          title: 'للاشتراك الشهري',
          price: '50',
          index: 1,
          selectedIndex: selectedContainerIndex,
          onTap: _handleTap,
          unit: 'شهر',
        ),
        //semi-anually
        PlanWidget(
          index: 2,
          selectedIndex: selectedContainerIndex,
          title: 'للاشتراك لمده ترم دراسي كامل',
          price: '80',
          onTap: _handleTap,
          unit: 'ترم',
        ),
        //anually
        PlanWidget(
          index: 3,
          selectedIndex: selectedContainerIndex,
          title: 'للاشتراك السنوي',
          price: '150',
          onTap: _handleTap,
          unit: 'سنه',
        ),
      ],
    );
  }

  void _handleTap(int containerIndex) {
    setState(() {
      selectedContainerIndex = containerIndex;
    });
    switch (selectedContainerIndex) {
      case 0:
        ref.read(planType.notifier).update((state) => PlanEnum.freeTrail);
        return;
      case 1:
        ref.read(planType.notifier).update((state) => PlanEnum.monthly);
        return;
      case 2:
        ref.read(planType.notifier).update((state) => PlanEnum.semiAnnually);
        return;
      case 3:
        ref.read(planType.notifier).update((state) => PlanEnum.annually);
        return;
      default:
        ref.read(planType.notifier).update((state) => PlanEnum.notSubscribed);
        return;
    }
  }
}
