import 'package:faenonibeqwa/models/exam_model.dart';
import 'package:faenonibeqwa/repositories/admob_repo.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/solute_exam_screen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/screens/home/payment/subscription_screen.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/base/app_images.dart';
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

class _ExamTileWidgetState extends ConsumerState<ExamTileWidget> {
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
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                blurRadius: 50,
                spreadRadius: 10,
                color: Colors.white,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              const CircleAvatar(
                backgroundImage: AssetImage(AppImages.logo),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(
                        text: 'الاختبار / ${widget.examModel.examTitle}',
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        fontWeight: FontWeight.bold,
                      ),
                      10.hSpace,
                      SmallText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: 'الوصف / ${widget.examModel.examDescription}',
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      10.hSpace,
                      SmallText(
                        fontSize: 10.sp,
                        text:
                            'مده الاختبار / ${widget.examModel.timeMinutes} دقيقه',
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future<void> _checkSubscribtionAndEnterExam(BuildContext context) async {
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
      await FirebaseMessaging.instance.unsubscribeFromTopic('premium');
      if (context.mounted) {
        AppHelper.customSnackbar(
          context: context,
          title: 'يجب تفعيل الاشتراك لتتمكن من دخول الاختبار',
        );
      }
      Navigator.of(context).pushNamed(SubscriptionScreen.routeName);
    }
  }
}
