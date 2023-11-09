import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:videosdk/videosdk.dart';

class MeetingAppBar extends StatefulWidget {
  final String token;
  final Room meeting;
  final bool isFullScreen;
  const MeetingAppBar(
      {Key? key,
      required this.meeting,
      required this.token,
      required this.isFullScreen})
      : super(key: key);

  @override
  State<MeetingAppBar> createState() => MeetingAppBarState();
}

class MeetingAppBarState extends State<MeetingAppBar> {
  Timer? _timer;
  int _seconds = 0;
  String _displayText = '00:00:00';

  final Map<String, Participant> _participants = {};

  @override
  void initState() {
    _startTimer();

    _participants.putIfAbsent(widget.meeting.localParticipant.id,
        () => widget.meeting.localParticipant);
    _participants.addAll(widget.meeting.participants);

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: !widget.isFullScreen
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        secondChild: const SizedBox.shrink(),
        firstChild: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.meeting.id,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Icon(
                              Icons.copy,
                              color: Colors.green,
                              size: 16,
                            ),
                          ),
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: widget.meeting.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم نسخ كلمه مرور المكالمه'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    // VerticalSpacer(),
                    Text(
                      _displayText,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 2,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _seconds++;
          final hours = _seconds ~/ 3600;
          final minutes = (_seconds % 3600) ~/ 60;
          final seconds = _seconds % 60;
          _displayText =
              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        });
      },
    );
  }
}
