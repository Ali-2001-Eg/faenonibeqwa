import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../controllers/admob_controller.dart';
import '../repositories/admob_repo.dart';

class BannerWidget extends StatefulWidget {
  final WidgetRef ref;
  const BannerWidget({
    Key? key,
    required this.ref,
  }) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  BannerAd? banner;
  @override
  void didChangeDependencies() {
    widget.ref.read(admobControllerProvider).initialization.then((value) {
      banner = BannerAd(
        adUnitId: widget.ref.read(admobControllerProvider).bannerAdUnitId!,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: widget.ref.read(admibRepoProvider).bannerAdListener,
      )..load();
      setState(() {});
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return banner != null
        ? SizedBox(
            height: 60,
            child: AdWidget(ad: banner!),
          )
        : const SizedBox.shrink();
  }
}
