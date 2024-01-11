import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobRepo {
  Future<InitializationStatus> initialization;
  AdmobRepo(this.initialization);

  String? get interstitialAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-8174345989688428/2328181214';
      } else {
        print('release');
        return 'ca-app-pub-8174345989688428/2328181214';
      }
    }
    return null;
  }
  String? get rewardAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-8174345989688428/4600472404';
      } else {
        print('release');
        return 'ca-app-pub-8174345989688428/4600472404';
      }
    }
    return null;
  }

 
}

final admobRepoProvider = Provider<AdmobRepo>((ref) {
  Future<InitializationStatus> initialization = MobileAds.instance.initialize();
  return AdmobRepo(initialization);
});
