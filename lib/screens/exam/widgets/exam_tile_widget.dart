import 'package:faenonibeqwa/models/exam_model.dart';
import 'package:faenonibeqwa/repositories/admob_repo.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/solute_exam_screen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/base/subscription_dialoge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/custom_button.dart';
import '../../../utils/shared/widgets/small_text.dart';

class ExamTileWidget extends ConsumerStatefulWidget {
  final ExamModel examModel;
  final WidgetRef ref;
  const ExamTileWidget({
    super.key,
    required this.examModel,
    required this.ref,
  });

  @override
  ConsumerState<ExamTileWidget> createState() => _ExamTileWidgetState();
}

InterstitialAd? _interstitial;

class _ExamTileWidgetState extends ConsumerState<ExamTileWidget> {
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: ref.read(admobRepoProvider).interstitialAdUnitId!,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitial = ad;
          });
        }, onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _interstitial = null;
          });
        }));
  }

  // ignore: unused_element
  Future<void> _showInterstitialAd() async {
    if (_interstitial != null) {
      _interstitial!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        if (kDebugMode) {
          print('ad is  ${ad.adUnitId}');
        }

        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        if (kDebugMode) {
          print('failed to show $error');
        }
        ad.dispose();
        _createInterstitialAd();
      });
      setState(() {
        _interstitial!.show();
        _interstitial = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('subscribtion ${ref.read(paymentControllerProvider).subscriptionEnded}');
    if (kDebugMode) {
      print(
        'time to be changed in firestore ${DateTime.now().add(const Duration(seconds: 30)).millisecondsSinceEpoch}');
    }
    return GestureDetector(
      onTap: () {
        _checkSubscribtionAndEnterExam(context);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10, left: 0, right: 0),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.examModel.examImageUrl,
                height: 120.h,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SmallText(
                      text: 'اسم الاختبار / ${widget.examModel.examTitle}',
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SmallText(
                    text:
                        'مده الاختبار / ${widget.examModel.timeMinutes} دقيقه',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SmallText(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                text: 'الوصف / ${widget.examModel.examDescription}',
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: CustomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SoluteExamScreen(
                            exam: widget.examModel,
                          );
                        },
                      ),
                    );
                  },
                  text: 'ادخل الآن',
                  textColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void _checkSubscribtionAndEnterExam(BuildContext context) {
    if (ref.read(paymentControllerProvider).subscriptionEnded) {
      ref.read(paymentControllerProvider).changePlanAfterEndDate;
    }
    if (!ref.read(paymentControllerProvider).subscriptionEnded) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SoluteExamScreen(
          exam: widget.examModel,
        );
      }));
    } else {
      AppHelper.customSnackbar(
        context: context,
        title: 'يجب تفعيل الاشتراك لتتمكن من دخول الاختبار',
      );
      Future.delayed(
          const Duration(seconds: 1),
          () => showModalBottomSheet(
              context: context,
              builder: (context) {
                return const SubscriptionDialog();
              }));
    }
  }
}
