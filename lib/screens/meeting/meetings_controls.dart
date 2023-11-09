import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeetingControls extends StatelessWidget {
  final void Function() onToggleMicButtonPressed;
  final void Function() onToggleCameraButtonPressed;
  final void Function() onToggelShareScreenPressed;
  final void Function() onLeaveButtonPressed;

  final bool isMicEnabled, isCamEnabled, isScreenShareEnabled;
  const MeetingControls({
    super.key,
    required this.onToggleMicButtonPressed,
    required this.onToggleCameraButtonPressed,
    required this.onLeaveButtonPressed,
    required this.onToggelShareScreenPressed,
    required this.isMicEnabled,
    required this.isCamEnabled,
    required this.isScreenShareEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: context.screenWidth / 1.3,
        height: 40.h,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
                onTap: onLeaveButtonPressed,
                child: Icon(
                  Icons.call_end_outlined,
                  size: 20.h,
                  color: Colors.red,
                )),
            InkWell(
                onTap: onToggleMicButtonPressed,
                child: Icon(
                  isMicEnabled ? Icons.mic : Icons.mic_off,
                  size: 20.h,
                  color: isMicEnabled ? Colors.blue : Colors.grey,
                )),
            InkWell(
                onTap: onToggleCameraButtonPressed,
                child: Icon(
                  isCamEnabled ? Icons.videocam : Icons.videocam_off_outlined,
                  size: 20.h,
                  color: isCamEnabled ? Colors.blue : Colors.grey,
                )),
            InkWell(
                onTap: onToggelShareScreenPressed,
                child: Icon(Icons.screen_share_outlined,
                    size: 20.h,
                    color: isScreenShareEnabled ? Colors.blue : Colors.grey)),
          ],
        ),
      ),
    );
  }
}
