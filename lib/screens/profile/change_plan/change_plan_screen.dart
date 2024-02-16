import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: 'تغيير خطه الدفع'),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BigText(fontSize: 18, text: 'ادخل قيمه الحجز الشهري '),
              10.hSpace,
              CustomTextField(
                controller: monthlyPrice,
                keyBoardType: TextInputType.number,
                hintText: '50 ج.م',
              ),
              10.hSpace,
              const BigText(fontSize: 18, text: 'ادخل قيمه الحجز نصف السنوي '),
              10.hSpace,
              CustomTextField(
                controller: monthlyPrice,
                keyBoardType: TextInputType.number,
                hintText: '80 ج.م',
              ),
              10.hSpace,
              const BigText(fontSize: 18, text: 'ادخل قيمه الحجز السنوي '),
              10.hSpace,
              CustomTextField(
                controller: monthlyPrice,
                keyBoardType: TextInputType.number,
                hintText: '100 ج.م',
              ),
              20.hSpace,
              Align(
                  alignment: Alignment.center,
                  child: CustomButton(onTap: () {}, text: ' إضافه الحجز'))
            ],
          ),
        ),
      ),
    );
  }
}
