// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/repositories/admob_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobController {
  final AdmobRepo adRepo;
  AdmobController({
    required this.adRepo,
  });
  //initialize
  Future<InitializationStatus> get initialization => adRepo.initialization;
  String? get bannerAdUnitId => adRepo.bannerAdUnitId;
  BannerAdListener get bannerAdListener => adRepo.bannerAdListener;
}

final admobControllerProvider = Provider((ref) {
  final abmobRepo = ref.read(admibRepoProvider);
  return AdmobController(adRepo: abmobRepo);
});
