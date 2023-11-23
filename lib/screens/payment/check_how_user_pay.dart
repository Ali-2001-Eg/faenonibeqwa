// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/screens/payment/payment_text_field_widget.dart';
import 'package:flutter/material.dart';

class CheckHowUserWillPay extends StatefulWidget {
  // final CartCubit cartCubit;
  const CheckHowUserWillPay({
    Key? key,
    // required this.cartCubit,
  }) : super(key: key);

  @override
  State<CheckHowUserWillPay> createState() => _CheckHowUserWillPayState();
}

class _CheckHowUserWillPayState extends State<CheckHowUserWillPay> {
  final phoneController = TextEditingController();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  String payWithoutVisa = 'الدفع عند الاستلام';
  String payByVisa = 'الدفع اونلاين';
  String? pay;

  // @override
  // void dispose() {
  //   phoneController.dispose();
  //   priceController.dispose();
  //   phoneController.dispose();
  //   streetController.dispose();
  //   super.dispose();
  // }
  @override
  void initState() {
    // context.read<PaymentCubit>().getAuthPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final totalPrice =
    //           widget.cartCubit.totalPrice(widget.cartCubit.cart) + 5;
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              PaymentTextFormFieldWidget(
                controller: nameController,
                hintText: 'الاسم',
              ),
              PaymentTextFormFieldWidget(
                controller: phoneController,
                hintText: 'الهاتف',
              ),
              PaymentTextFormFieldWidget(
                controller: streetController,
                hintText: 'المكان',
              ),
              // PaymentTextFormField(
              //   controller: priceController,
              //   hintText: totalPrice.toString(),
              // ),
              RadioListTile(
                value: payWithoutVisa,
                groupValue: pay,
                title: Text(payWithoutVisa),
                onChanged: (v) {
                  setState(() {
                    pay = v!;
                  });
                },
              ),
              RadioListTile(
                title: Text(payByVisa),
                value: payByVisa,
                groupValue: pay,
                onChanged: (v) {
                  setState(() {
                    pay = v!;
                  });
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.deepOrange),
              //     onPressed: pay == null
              //         ? () {
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               const SnackBar(
              //                 content: Text('يرجي اختيار وسيلة الدفع'),
              //               ),
              //             );
              //           }
              //         : () async {
              //             if (pay == payByVisa) {
              //               // await payment.getOrderId(
              //               //   price: totalPrice.toString(),
              //               //   // email: streetController.text,
              //               //   // name: nameController.text,
              //               //   // phone: phoneController.text,
              //               // );
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const PaymentView(),
              //               //   ),
              //               // );
              //             } else {
              //               // Navigator.pushAndRemoveUntil(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const NavBarScreen(),
              //               //   ),
              //               //   (route) => false,
              //               // );
              //             }
              //           },
              //     child: state is GetOrderIdLoading
              //         ? const Center(
              //             child: CircularProgressIndicator(
              //             color: Colors.white,
              //           ))
              //         : Text(
              //             'استكمال الطلب',
              //             style: Styles.style18.copyWith(color: Colors.white),
              //           ),
              //   ),
              // ),
            ],
          ),
        )

        //  BlocConsumer<PaymentCubit, PaymentState>(
        //   listener: (context, state) {
        //     // if (state is GetPaymentRequestSuccess) {
        //     //   Navigator.push(
        //     //     context,
        //     //     MaterialPageRoute(
        //     //       builder: (context) => VisaCardView(
        //     //         finalToken: context.read<PaymentCubit>().finalToken,
        //     //       ),
        //     //     ),
        //     //   );
        //     // }
        //   },
        //   builder: (context, state) {
        //     // final payment = context.read<PaymentCubit>();

        //   },
        // ),
        );
  }
}
