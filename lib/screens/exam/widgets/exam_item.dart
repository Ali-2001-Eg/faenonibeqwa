import 'package:faenonibeqwa/models/exam_model.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/solute_exam_screen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/screens/home/payment/subscription_screen.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/base/app_images.dart';
import '../../../utils/providers/app_providers.dart';
import '../../../utils/shared/widgets/small_text.dart';

class ExamItem extends ConsumerStatefulWidget {
  final ExamModel examModel;
  final WidgetRef ref;
  const ExamItem({
    super.key,
    required this.examModel,
    required this.ref,
  });

  @override
  ConsumerState<ExamItem> createState() => _ExamTileWidgetState();
}

class _ExamTileWidgetState extends ConsumerState<ExamItem> {
  @override
  Widget build(BuildContext context) {
    print('subscribtion ${ref.read(paymentControllerProvider).subscriptionEnded}');
    
    return GestureDetector(
      onTap: () async{
        await _checkSubscribtionAndEnterExam(context)?Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SoluteExamScreen(
          exam: widget.examModel,
        );
      })):
        Navigator.of(context).pushNamed(SubscriptionScreen.routeName);
      
      
        _storeExamData(
          ref,
          widget.examModel.id,
          widget.examModel.examTitle,
          widget.examModel.examDescription,
        );
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

  Future<bool> _checkSubscribtionAndEnterExam(BuildContext context) async{
    if (!await ref.read(paymentControllerProvider).subscriptionEnded) {

      
      return true;
    } else {
      ref.read(paymentControllerProvider).changePlanAfterEndDate;
       FirebaseMessaging.instance.unsubscribeFromTopic('premium');
      if (context.mounted) {
        AppHelper.customSnackbar(
          context: context,
          title: 'يجب تفعيل الاشتراك لتتمكن من دخول الاختبار',
        );
      }
     
      return false;
    }
  }

  Future<void> _storeExamData(
    WidgetRef ref,
    String examId,
    String examTitle,
    String examDescription,
  ) async {
    if (await ref
        .read(examControllerProvider)
        .checkUserHasTakenExam(examId: examId)) {
      if (!await ref
          .read(examControllerProvider)
          .checkUserHasTakenExam(examId: examId)) {
        ref.read(examControllerProvider).storeExamDataToUser(
              examId: examId,
              title: examTitle,
              description: examDescription,
            );
      }
    }
  }
}
