import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../repositories/admob_repo.dart';

class InterstitialWidget {
 final WidgetRef ref;

  static InterstitialAd? interstitialAd;
  InterstitialWidget({required this.ref});

   void showInterstatialAd() {
    if (interstitialAd != null) {
      interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (Ad ad) {
        ad.dispose();
        createInterstatialAd();
      }, onAdFailedToShowFullScreenContent: (Ad ad, err) {
        ad.dispose();
        createInterstatialAd();
      });
      interstitialAd!.show();
    
        interstitialAd = null;
     
    }
  }

   void createInterstatialAd() {
    InterstitialAd.load(
      adUnitId: ref.read(admobRepoProvider).interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
      
          interstitialAd = ad;
        
      }, onAdFailedToLoad: (adErr) {
      }),
    );
  }
}
