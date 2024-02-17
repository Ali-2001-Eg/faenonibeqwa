import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePlanScreen extends StatefulWidget {
  const ChangePlanScreen({super.key});

  @override
  State<ChangePlanScreen> createState() => _ChangePlanScreenState();
}

class _ChangePlanScreenState extends State<ChangePlanScreen> {
  final TextEditingController monthlyPrice = TextEditingController(),
      semiAnnuallyPrice = TextEditingController(),
      annuallyPrice = TextEditingController();
  @override
  void dispose() {
    annuallyPrice.dispose();
    semiAnnuallyPrice.dispose();
    monthlyPrice.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: 'تغيير خطه الدفع'),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BigText(fontSize: 18, text: 'ادخل قيمه الحجز الشهري '),
                10.hSpace,
                CustomTextField(
                  controller: monthlyPrice,
                  keyBoardType: TextInputType.number,
                  hintText: '50 ج.م',
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'أضف قيمه الاشتراك';
                    } else if (!validatePrice(value)) {
                      return 'ادخل قيمه الاشتراك بطريقه صحيحه';
                    }
                    return null;
                  },
                ),
                10.hSpace,
                const BigText(
                    fontSize: 18, text: 'ادخل قيمه الحجز نصف السنوي '),
                10.hSpace,
                CustomTextField(
                  controller: semiAnnuallyPrice,
                  keyBoardType: TextInputType.number,
                  hintText: '80 ج.م',
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'أضف قيمه الاشتراك';
                    } else if (!validatePrice(value)) {
                      return 'ادخل قيمه الاشتراك بطريقه صحيحه';
                    }
                    return null;
                  },
                ),
                10.hSpace,
                const BigText(fontSize: 18, text: 'ادخل قيمه الحجز السنوي '),
                10.hSpace,
                CustomTextField(
                  controller: annuallyPrice,
                  keyBoardType: TextInputType.number,
                  hintText: '100 ج.م',
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'أضف قيمه الاشتراك';
                    } else if (!validatePrice(value)) {
                      return 'ادخل قيمه الاشتراك بطريقه صحيحه';
                    }
                    return null;
                  },
                ),
                20.hSpace,
                Align(
                    alignment: Alignment.center,
                    child: Consumer(
                      builder: (context, ref, child) {
                        if (ref.watch(isLoading)) {
                          return const CustomIndicator();
                        } else {
                          return CustomButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .watch(paymentControllerProvider)
                                    .changePlansAmount(
                                      monthPlanPrice: monthlyPrice.text.trim(),
                                      semiAnnuallPlanPrice:
                                          semiAnnuallyPrice.text.trim(),
                                      annuallPlanPrice:
                                          annuallyPrice.text.trim(),
                                    );
                              }
                            },
                            text: ' إضافه الحجز',
                          );
                        }
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validatePrice(String value) {
    if (value.isEmpty) {
      return false;
    } else {
      final numberRegex = RegExp(r'^[0-9]+$');
      return numberRegex.hasMatch(value);
    }
  }
}
