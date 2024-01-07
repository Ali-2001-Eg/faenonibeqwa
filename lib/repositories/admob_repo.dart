import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobRepo {
  Future<InitializationStatus> initialization;
  AdmobRepo(this.initialization);

  String? get bannerAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-8174345989688428/2356101379';
      } else {
        print('release');
        return 'ca-app-pub-8174345989688428/2356101379';
      }
    }
    return null;
  }

  BannerAdListener get bannerAdListener => BannerAdListener(
        onAdLoaded: (ad) => print('ad loaded'),
        onAdClosed: (ad) => print('ad closed'),
        onAdFailedToLoad: (ad, err) {
          ad.dispose;
          print('ad failed to load $err');
        },
        onAdOpened: (ad)=>print('ad opened'),
      );
}

final admibRepoProvider = Provider<AdmobRepo>((ref) {
  Future<InitializationStatus> initialization = MobileAds.instance.initialize();
  return AdmobRepo(initialization);
});
