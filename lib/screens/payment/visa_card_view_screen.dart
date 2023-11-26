import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:paymob_payment/paymob_payment.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  PaymobResponse? response;

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paymob'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image.network('https://paymob.com/images/logoC.png'),
            const SizedBox(height: 24),
            CustomTextField(
              controller: nameController,
              hintText: 'Name',
            ),
            // if (response != null)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: [
            //       Text(
            //         "Success ==> ${response?.success}",
            //         style: const TextStyle(
            //           color: Colors.red,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         "Transaction ID ==> ${response?.transactionID}",
            //         style: const TextStyle(
            //           color: Colors.red,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         "Message ==> ${response?.message}",
            //         style: const TextStyle(
            //           color: Colors.red,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         "Response Code ==> ${response?.responseCode}",
            //         style: const TextStyle(
            //           color: Colors.red,
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //     ],
            //   ),

            ElevatedButton(
              child: const Text('Pay for 200 EGP'),
              onPressed: () {
                PaymobPayment.instance.pay(
                  context: context,
                  currency: "EGP",
                  amountInCents: "20000",
                  billingData: PaymobBillingData(),
                  onPayment: (responsedata) {
                    setState(() {
                      response = responsedata;
                    });
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
