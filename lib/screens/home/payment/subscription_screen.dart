import 'package:faenonibeqwa/utils/shared/widgets/shimmer_widget.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/base/colors.dart';
import 'package:faenonibeqwa/utils/enums/plan_enum.dart';
import 'package:faenonibeqwa/utils/enums/toast_enum.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paymob_payment/paymob_payment.dart';
import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/big_text.dart';
import 'widgets/payment_body.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});
  static const String routeName = 'suscribe';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 10,
                right: 15,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: context.screenHeight * 0.06,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: indicatorColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 50,
                            color: Colors.white,
                            spreadRadius: 30,
                            offset: Offset(0, -3),
                          )
                        ]),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                    top: context.screenHeight / 10,
                  )),
                  BigText(
                    text: 'اشترك الآن',
                    fontSize: 30.sp,
                  ),
                  15.hSpace,
                  BigText(
                    fontSize: 18.sp,
                    text:
                        'اختر خطه الدفع المناسبه لك لتتمتع بكافه مزايا البرنامج.',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.normal,
                  ),
                  if (ref.watch(isLoading)) const ShimmerWidget(),
                  const PaymentBody(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: context.screenHeight / 7,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        // color: Colors.transparent,

        child: CustomButton(
            onTap: () {
              if (ref.watch(isLoading)) {
                return;
              } else {
                // ref.watch(isLoading.notifier).update((state) => true);
                switch (ref.watch(planType)) {
                  case PlanEnum.notSubscribed:
                    // print('not subscribed');
                    break;
                  case PlanEnum.freeTrail:
                    _freeTrailSubscribe(ref, context);
                    break;
                  case PlanEnum.monthly:
                    _monthlyPlanSubscribe(context, ref);
                    // print(ref.watch(isLoading));
                    break;
                  case PlanEnum.semiAnnually:
                    _semiAnnuallyPlanSubscribe(context, ref);
                    break;
                  case PlanEnum.annually:
                    _annuallyPlanSubscribe(context, ref);
                    break;
                }
                ref.watch(isLoading.notifier).update((state) => false);
              }
            },
            text: 'اشتراك',
            fontSize: 20.sp),
      ),
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
    else if (!await ref.read(paymentControllerProvider).subscriptionEnded) {
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
            amountInCents: getPrices(PlanEnum.annually, ref),
            billingData: PaymobBillingData(),
            onPayment: (responsedata) async {
              if (responsedata.success == true) {
                ref
                    .read(paymentControllerProvider)
                    .subscibe(planType: PlanEnum.annually);
                await FirebaseMessaging.instance.subscribeToTopic('premium');

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
    else if (!await ref.read(paymentControllerProvider).subscriptionEnded) {
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
        amountInCents: getPrices(PlanEnum.semiAnnually, ref),
        billingData: PaymobBillingData(),
        onPayment: (responsedata) async {
          if (responsedata.success == true) {
            ref
                .read(paymentControllerProvider)
                .subscibe(planType: PlanEnum.semiAnnually);
            await FirebaseMessaging.instance.subscribeToTopic('premium');
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
    ref.read(isLoading.notifier).update((state) => true);
    //check plan type
    if (ref.read(paymentControllerProvider).planType == PlanEnum.monthly) {
      AppHelper.customSnackbar(
          context: context,
          title: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
          status: ToastStatus.success);
      return;
    }
    //check end date
    else if (!await ref.read(paymentControllerProvider).subscriptionEnded) {
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
      amountInCents: getPrices(PlanEnum.monthly, ref),
      billingData: PaymobBillingData(),
      onPayment: (responsedata) async {
        if (responsedata.success == true) {
          ref
              .read(paymentControllerProvider)
              .subscibe(planType: PlanEnum.monthly);
          await FirebaseMessaging.instance.subscribeToTopic('premium');
        } else {
          AppHelper.customSnackbar(
            context: context,
            title: 'هناك خطأ في العمليه ${responsedata.message}',
          );
        }
        ref.read(isLoading.notifier).update((state) => false);
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

  Future<void> _freeTrailSubscribe(WidgetRef ref, BuildContext context) async {
    //check plan type
    if (await ref.read(paymentControllerProvider).subscriptionEnded) {
      AppHelper.customSnackbar(
          context: context,
          title: 'الاشتراك جاري بالفعل حاول الاشتراك في برنامج آخر',
          status: ToastStatus.success);
      return;
    }
    //check end date
    else if (!await ref.read(paymentControllerProvider).subscriptionEnded) {
      AppHelper.customSnackbar(
          context: context,
          title: ' الاشتراك جاري بالفعل باقي ${_reminingDays(ref)} يوما',
          status: ToastStatus.success);
      return;
    } else {
      await FirebaseMessaging.instance.subscribeToTopic('premium');

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

  String getPrices(PlanEnum planType, WidgetRef ref) {
    return ref.read(planPricesStreamProvider(planType)).when(data: (data) {
      return data;
    }, error: (error, sta) {
      throw error;
    }, loading: () {
      return '';
    });
  }
}
