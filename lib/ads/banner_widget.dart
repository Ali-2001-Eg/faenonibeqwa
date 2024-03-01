// // ignore_for_file: avoid_print

// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';


// class BannerWidget extends StatefulWidget {
//   const BannerWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<BannerWidget> createState() => _BannerWidgetState();
// }

// class _BannerWidgetState extends State<BannerWidget> {
//   BannerAd? banner;
//   @override
//   void initState() {
//     setState(() {
//       // MobileAds.instance.initialize();

//       banner = BannerAd(
//         adUnitId: 'ca-app-pub-8174345989688428/2356101379',
//         size: AdSize.banner,
//         request: const AdRequest(),
//         listener: bannerAdListener,
//       )..load();
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     banner!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return banner != null
//         ? SizedBox(height: 60, child: AdWidget(ad: banner!))
//         : SizedBox.square(
//             child: Container(color: Colors.black),
//           );
//   }

//   BannerAdListener get bannerAdListener => BannerAdListener(
//         onAdLoaded: (ad) => print('ad loaded'),
//         onAdClosed: (ad) => print('ad closed'),
//         onAdFailedToLoad: (ad, err) {
//           ad.dispose;
//         },
//         onAdOpened: (ad) => print('ad opened'),
//       );

//   String? get bannerAdUnitId {
//     if (kDebugMode) {
//       if (Platform.isAndroid) {
//         return 'ca-app-pub-8174345989688428/2356101379';
//       } else {
//         print('release');
//         return 'ca-app-pub-8174345989688428/2356101379';
//       }
//     }
//     return null;
//   }
// }
