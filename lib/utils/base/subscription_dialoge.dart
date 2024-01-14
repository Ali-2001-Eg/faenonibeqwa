import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/controllers/payment_controller.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/enums/plan_enum.dart';
import 'package:faenonibeqwa/utils/enums/toast_enum.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paymob_payment/paymob_payment.dart';
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
        if (ref.read(userDataProvider).value!.freePlanEnded == false)
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
        title: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
        status: ToastStatus.success,
        snackbarPosition: ToastGravity.TOP,
      );
      return;
    }
    //check end date
    else if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      AppHelper.customSnackbar(
        context: context,
        title: ' الاشتراك جاري بالفعل باقي ${_reminingDays(ref)} يوما',
        status: ToastStatus.success,
        snackbarPosition: ToastGravity.TOP,
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
                if (ref.read(userDataProvider).value!.planEnum ==
                    PlanEnum.annually) {
                  Future.delayed(
                      const Duration(seconds: 1),
                      () => AppHelper.customSnackbar(
                            context: context,
                            status: ToastStatus.success,
                            snackbarPosition: ToastGravity.TOP,
                            title:
                                'تم الاشتراك المجاني لمده العام الدراسي بالكامل',
                          ));
                }
              } else {
                AppHelper.customSnackbar(
                  context: context,
                  title: 'هناك خطأ في العمليه ${responsedata.message}',
                );
              }
            },
          )
          .then(
            (value) {},
          );
    }
  }

  Future<void> _semiAnnuallyPlanSubscribe(
      BuildContext context, WidgetRef ref) async {
    //check plan type
    if (ref.read(paymentControllerProvider).planType == PlanEnum.semiAnnually) {
      AppHelper.customSnackbar(
        context: context,
        title: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
        status: ToastStatus.success,
        snackbarPosition: ToastGravity.TOP,
      );
      return;
    }
    //check end date
    else if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      AppHelper.customSnackbar(
        context: context,
        title: ' الاشتراك جاري بالفعل باقي ${_reminingDays(ref)} يوما',
        status: ToastStatus.success,
        snackbarPosition: ToastGravity.TOP,
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
              title: 'هناك خطأ في العمليه ${responsedata.message}',
            );
          }
        },
      )
          .then(
        (value) {
          if (ref.read(userDataProvider).value!.planEnum ==
              PlanEnum.semiAnnually) {
            AppHelper.customSnackbar(
              context: context,
              status: ToastStatus.success,
              snackbarPosition: ToastGravity.TOP,
              title: 'تم الاشتراك المجاني لمده ترم دراسي كامل من الان',
            );
          }
        },
      );
    }
  }

  Future<void> _monthlyPlanSubscribe(
      BuildContext context, WidgetRef ref) async {
    //check plan type
    if (ref.read(paymentControllerProvider).planType == PlanEnum.monthly) {
      AppHelper.customSnackbar(
          context: context,
          title: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
          status: ToastStatus.success);
      return;
    }
    //check end date
    else if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      AppHelper.customSnackbar(
          context: context,
          title: ' الاشتراك جاري بالفعل باقي ${_reminingDays(ref)} يوما',
          status: ToastStatus.success);
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
            title: 'هناك خطأ في العمليه ${responsedata.message}',
          );
        }
      },
    )
        .then(
      (value) {
        if (ref.read(userDataProvider).value!.planEnum == PlanEnum.monthly) {
          AppHelper.customSnackbar(
            context: context,
            status: ToastStatus.success,
            snackbarPosition: ToastGravity.TOP,
            title: 'تم الاشتراك المجاني لمده 30 يوما من الان',
          );
        }
      },
    );
  }

  int _reminingDays(WidgetRef ref) => ref
      .read(userDataProvider)
      .value!
      .timeToFinishSubscribtion!
      .difference(DateTime.now())
      .inDays;

  Future _freeTrailSubscribe(WidgetRef ref, BuildContext context) async {
    //check plan type
    if (ref.read(paymentControllerProvider).planType == PlanEnum.freeTrail) {
      AppHelper.customSnackbar(
          context: context,
          title: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
          status: ToastStatus.success);
      return;
    }
    //check end date
    else if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      AppHelper.customSnackbar(
          context: context,
          title: ' الاشتراك جاري بالفعل باقي ${_reminingDays(ref)} يوما',
          status: ToastStatus.success);
      return;
    } else {
      return ref
          .read(paymentControllerProvider)
          .subscibe(planType: PlanEnum.freeTrail)
          .then(
            (value) => AppHelper.customSnackbar(
              context: context,
              status: ToastStatus.success,
              snackbarPosition: ToastGravity.TOP,
              title: 'تم الاشتراك المجاني لمده 15 يوما من الان',
            ),
          );
    }
  }
}
