// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VisaCardView extends StatefulWidget {
  final String finalToken;
  const VisaCardView({
    Key? key,
    required this.finalToken,
  }) : super(key: key);

  @override
  State<VisaCardView> createState() => _VisaCardViewState();
}

class _VisaCardViewState extends State<VisaCardView> {
  final controller = WebViewController();
  Future<void> getUrl(String token) async {
    if (kDebugMode) {
      print('final token is ${widget.finalToken}');
    }
    String portraitUrl =
        'https://accept.paymob.com/api/acceptance/iframes/787144?payment_token=$token';
    String landscapeUrl =
        'https://accept.paymob.com/api/acceptance/iframes/787143?payment_token=$token';
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(landscapeUrl));
  }

  // @override
  // void initState() {
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    getUrl(widget.finalToken);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: controller,
        layoutDirection: TextDirection.rtl,
      ),
    );
  }
}
