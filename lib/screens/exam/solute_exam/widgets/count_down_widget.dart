// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/base/app_helper.dart';
import '../../../../utils/providers/app_providers.dart';
import '../../../home/main_sceen.dart';

class CountdownWidget extends StatefulWidget {
  final int timeMinutes;
  final WidgetRef ref;
  final String examId;
  final int totalGrade;
  const CountdownWidget({
    Key? key,
    required this.timeMinutes,
    required this.ref,
    required this.examId,
    required this.totalGrade,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '0:00:00') {
      widget.ref
          .read(examControllerProvider)
          .submitExam(
            examId: widget.examId,
            totalGrade: widget.totalGrade,
          )
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.routeName, (route) => false))
          .catchError((err) {
            AppHelper.customSnackbar(
              context: context, title: err.toString());
          return err;
          });
    }
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.timeMinutes),
    );
    //to start timmer
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => SmallText(
        text: countText,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
