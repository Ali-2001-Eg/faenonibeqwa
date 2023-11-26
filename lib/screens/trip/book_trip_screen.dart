// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/controllers/trip_controller.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:faenonibeqwa/controllers/payment_controller.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:paymob_payment/paymob_payment.dart';

import '../../utils/shared/widgets/custom_text_field.dart';

class BookTripNow extends ConsumerStatefulWidget {
  final num price;
  const BookTripNow({super.key, required this.price});

  @override
  ConsumerState<BookTripNow> createState() => _BookTripNowState();
}

class _BookTripNowState extends ConsumerState<BookTripNow> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final numberOfPeopleController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // PaymobResponse? response;
  @override
  void initState() {
    ref.read(paymentControllerProvider).getPaymentAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const BigText(
          text: 'حجز رحلة',
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            children: [
              CustomTextField(
                controller: nameController,
                hintText: 'الاسم ثلاثي',
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'يرجي ادخال الاسم';
                  }
                  return null;
                },
              ),
              14.xSpace,
              CustomTextField(
                controller: phoneController,
                hintText: 'رقم التليفون',
                keyBoardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'يرجي ادخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              14.xSpace,
              CustomTextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                keyBoardType: TextInputType.phone,
                controller: numberOfPeopleController,
                hintText: 'عدد الأفراد',
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'يرجي ادخال عدد الأفراد';
                  }
                  return null;
                },
              ),
              14.xSpace,
              CustomButton(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    // ref.read(paymentControllerProvider).getOrderId(
                    //       context: context,
                    //       price: widget.price *
                    //           num.parse(numberOfPeopleController.text.trim())
                    //               .toDouble(),
                    //       phoneNumber: phoneController.text.trim(),
                    //     );
                    PaymobPayment.instance.pay(
                      context: context,
                      currency: "EGP",
                      amountInCents:
                          "${widget.price * num.parse(numberOfPeopleController.text.trim()).toDouble()}",
                      billingData: PaymobBillingData(),
                      onPayment: (responsedata) {
                        if (responsedata.success = true) {
                          ref.read(tripControllerProvider).saveTripPayment(
                                tripPrice: widget.price,
                                success: responsedata.success,
                                numberOfPeople: int.parse(
                                    numberOfPeopleController.text.trim()),
                                phoneNumber: phoneController.text.trim(),
                              );
                        }
                      },
                    );
                  }
                },
                text: 'تابع لأتمام عملية الحجز',
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
