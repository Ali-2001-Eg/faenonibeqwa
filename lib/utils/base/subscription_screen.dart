import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/base/app_images.dart';
import 'package:faenonibeqwa/utils/base/colors.dart';
import 'package:faenonibeqwa/utils/enums/plan_enum.dart';
import 'package:faenonibeqwa/utils/enums/toast_enum.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paymob_payment/paymob_payment.dart';
import '../providers/app_providers.dart';
import '../shared/widgets/big_text.dart';
import '../shared/widgets/plan_widget.dart';

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
        decoration: const BoxDecoration(
          // color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: CustomButton(
            onTap: () {
              switch (ref.watch(planType)) {
                case PlanEnum.notSubscribed:
                  // print('not subscribed');
                  break;
                case PlanEnum.freeTrail:
                  _freeTrailSubscribe(ref, context);
                  break;
                case PlanEnum.monthly:
                  _monthlyPlanSubscribe(context, ref);
                  break;
                case PlanEnum.semiAnnually:
                  _semiAnnuallyPlanSubscribe(context, ref);
                  break;
                case PlanEnum.annually:
                  _annuallyPlanSubscribe(context, ref);
                  break;
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
    if (ref.read(paymentControllerProvider).subscriptionEnded) {
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
}

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
        if (ref.watch(userDataProvider).value!.freePlanEnded == false)
          PlanWidget(
            index: 0,
            selectedIndex: selectedContainerIndex,
            title: 'تجربه مجانيه لمده 15 يوم',
            price: 'مجانا',
            onTap: _handleTap,
            unit: 'نصف شهر',
          ),
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
