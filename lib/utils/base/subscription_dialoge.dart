import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/controllers/payment_controller.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/enums/plan_enum.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../shared/widgets/big_text.dart';
import '../shared/widgets/plan_widget.dart';

class SubscriptionDialog extends ConsumerWidget {
  const SubscriptionDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      width: context.screenWidth,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        const BigText(text: 'اشترك الان لتحصل علي ميزات خاصه'),
        const SmallText(
            text: 'كل الخدمات ستكون متاحه من فيديوهات و بث مباشر و ملخصات'),
        //free trail
        PlanWidget(
          title: 'تجربه مجانيه لمده 15 يوم',
          btnText: 'مجانا',
          onTap: () => _freeTrailSubscribe(ref, context),
        ),
        //monthly
        PlanWidget(
          title: 'للاشتراك الشهري',
          btnText: '50 EGP/month',
          onTap: () => _monthlyPlanSubscribe(context, ref),
        ),
        //semi-anually
        PlanWidget(
            title: 'للاشتراك لمده ترم دراسي كامل',
            btnText: '80/term',
            onTap: () => _semiAnnuallyPlanSubscribe(context, ref)),
        //anually
        PlanWidget(
            title: 'للاشتراك السنوي',
            btnText: '150 EGP/year',
            onTap: () => _annuallyPlanSubscribe(context, ref)),
      ]),
    );
  }

  Future<void> _annuallyPlanSubscribe(
      BuildContext context, WidgetRef ref) async {
    //check plan type
    if (ref.read(paymentControllerProvider).planType == PlanEnum.annually) {
      AppHelper.customSnackbar(
        context: context,
        text: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
        color: context.theme.appBarTheme.backgroundColor!,
      );
      return;
    }
    //check end date
    else if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      AppHelper.customSnackbar(
        context: context,
        text:
            'باقي الاشتراك جاري بالفعل باقي ${timeago.format(ref.read(userDataProvider).value!.timeToFinishSubscribtion!)}',
        color: context.theme.appBarTheme.backgroundColor!,
      );
      return;
    } else {
      return PaymobPayment.instance
          .pay(
            context: context,
            currency: "EGP",
            amountInCents: "15000",
            billingData: PaymobBillingData(),
            onPayment: (responsedata) {
              if (responsedata.success == true) {
                ref
                    .read(paymentControllerProvider)
                    .subscibe(planType: PlanEnum.annually);
              } else {
                AppHelper.customSnackbar(
                  context: context,
                  text: 'هناك خطأ في العمليه ${responsedata.message}',
                );
              }
            },
          )
          .then(
            (value) => AppHelper.customSnackbar(
              context: context,
              color: context.theme.appBarTheme.backgroundColor!,
              text: 'تم الاشتراك المجاني لمده العام الدراسي بالكامل',
            ),
          );
    }
  }

  Future<void> _semiAnnuallyPlanSubscribe(
      BuildContext context, WidgetRef ref) async {
    //check plan type
    if (ref.read(paymentControllerProvider).planType == PlanEnum.semiAnnually) {
      AppHelper.customSnackbar(
        context: context,
        text: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
        color: context.theme.appBarTheme.backgroundColor!,
      );
      return;
    }
    //check end date
    else if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      AppHelper.customSnackbar(
        context: context,
        text:
            'باقي الاشتراك جاري بالفعل باقي ${timeago.format(ref.read(userDataProvider).value!.timeToFinishSubscribtion!)}',
        color: context.theme.appBarTheme.backgroundColor!,
      );
      return;
    } else {
      return PaymobPayment.instance
          .pay(
            context: context,
            currency: "EGP",
            amountInCents: "8000",
            billingData: PaymobBillingData(),
            onPayment: (responsedata) {
              if (responsedata.success == true) {
                ref
                    .read(paymentControllerProvider)
                    .subscibe(planType: PlanEnum.semiAnnually);
              } else {
                AppHelper.customSnackbar(
                  context: context,
                  text: 'هناك خطأ في العمليه ${responsedata.message}',
                );
              }
            },
          )
          .then(
            (value) => AppHelper.customSnackbar(
              context: context,
              color: context.theme.appBarTheme.backgroundColor!,
              text: 'تم الاشتراك المجاني لمده ترم دراسي كامل من الان',
            ),
          );
    }
  }

  Future<void> _monthlyPlanSubscribe(
      BuildContext context, WidgetRef ref) async {
    //check plan type
    if (ref.read(paymentControllerProvider).planType == PlanEnum.monthly) {
      AppHelper.customSnackbar(
        context: context,
        text: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
        color: context.theme.appBarTheme.backgroundColor!,
      );
      return;
    }
    //check end date
    else if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      print('subscriotion');
      AppHelper.customSnackbar(
        context: context,
        text:
            'باقي الاشتراك جاري بالفعل باقي ${timeago.format(ref.read(userDataProvider).value!.timeToFinishSubscribtion!)}',
        color: context.theme.appBarTheme.backgroundColor!,
      );
      return;
    }
    return PaymobPayment.instance
        .pay(
          context: context,
          currency: "EGP",
          amountInCents: "5000",
          billingData: PaymobBillingData(),
          onPayment: (responsedata) {
            if (responsedata.success == true) {
              ref
                  .read(paymentControllerProvider)
                  .subscibe(planType: PlanEnum.monthly);
            } else {
              AppHelper.customSnackbar(
                context: context,
                text: 'هناك خطأ في العمليه ${responsedata.message}',
              );
            }
          },
        )
        .then(
          (value) => AppHelper.customSnackbar(
            context: context,
            color: context.theme.appBarTheme.backgroundColor!,
            text: 'تم الاشتراك المجاني لمده 30 يوما من الان',
          ),
        );
  }

  Future _freeTrailSubscribe(WidgetRef ref, BuildContext context) async {
    //check plan type
    if (ref.read(paymentControllerProvider).planType == PlanEnum.freeTrail) {
      AppHelper.customSnackbar(
        context: context,
        text: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
        color: context.theme.appBarTheme.backgroundColor!,
      );
      return;
    }
    //check end date
    else if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      AppHelper.customSnackbar(
        context: context,
        text:
            'باقي الاشتراك جاري بالفعل باقي ${timeago.format(ref.read(userDataProvider).value!.timeToFinishSubscribtion!)}',
        color: context.theme.appBarTheme.backgroundColor!,
      );
      return;
    } else {
      return ref
          .read(paymentControllerProvider)
          .subscibe(planType: PlanEnum.freeTrail)
          .then(
            (value) => AppHelper.customSnackbar(
              context: context,
              color: context.theme.appBarTheme.backgroundColor!,
              text: 'تم الاشتراك المجاني لمده 15 يوما من الان',
            ),
          );
    }
  }
}
