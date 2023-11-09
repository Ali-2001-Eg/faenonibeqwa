import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:videosdk/videosdk.dart';

import 'full_screen_view.dart';

class ScreenShareView extends StatefulWidget {
  final Room meeting;
  final bool shareStreamEnabled = false;
  final void Function() onStopShareScreen;
  const ScreenShareView({
    Key? key,
    required this.meeting,
    required this.onStopShareScreen,
  }) : super(key: key);

  @override
  State<ScreenShareView> createState() => _ScreenShareViewState();
}

class _ScreenShareViewState extends State<ScreenShareView> {
  Participant? _presenterParticipant;
  Stream? shareStream;
  String? presenterId;
  bool isLocalScreenShare = false;

  @override
  void initState() {
    _presenterParticipant = widget.meeting.activePresenterId != null
        ? widget.meeting.participants.values.firstWhere(
            (element) => element.id == widget.meeting.activePresenterId)
        : null;

    if (widget.meeting.activePresenterId ==
        widget.meeting.localParticipant.id) {
      _presenterParticipant = widget.meeting.localParticipant;
      isLocalScreenShare = true;
      
    }

    presenterId = _presenterParticipant?.id;

    shareStream = _presenterParticipant?.streams.values
        .firstWhere((stream) => stream.kind == "share");
    setMeetingListeners(widget.meeting);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return shareStream != null
        ? Flexible(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    !isLocalScreenShare && shareStream != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: RTCVideoView(
                              shareStream?.renderer as RTCVideoRenderer,
                              objectFit: RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitContain,
                            ),
                          )
                        : Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Icon(
                                  Icons.screen_share,
                                  size: 40.h,
                                ),
                                SizedBox(height: 20.h),
                                const Text(
                                  "مشاركه شاشه العرض بواسطتك",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 20.h),
                                MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 30),
                                    color: Colors.purple,
                                    child: const Text("إنهاء العرض",
                                        style: TextStyle(fontSize: 16)),
                                    onPressed: () {
                                      widget.onStopShareScreen();
                                      //widget.meeting.disableScreenShare();
                                    })
                              ])),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black,
                        ),
                        child: Text(isLocalScreenShare
                            ? "شاشه العرض بواسطتك"
                            : "${_presenterParticipant!.displayName} بواسطه"),
                      ),
                    ),
                    if (!isLocalScreenShare && shareStream != null)
                      FullScreenView(shareStream: shareStream)
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  void setMeetingListeners(Room meeting) {
    meeting.localParticipant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == "share") {
        setState(() {
          isLocalScreenShare = true;
          shareStream = stream;
        });
      }
    });
    meeting.localParticipant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == "share") {
        setState(() {
          isLocalScreenShare = false;
          shareStream = null;
        });
      }
    });

    meeting.participants.forEach((key, value) {
      addParticipantListener(value);
    });
    // Called when presenter changes
    meeting.on(Events.presenterChanged, (presenterId) {
      Participant? presenterParticipant = presenterId != null
          ? widget.meeting.participants.values
              .firstWhere((element) => element.id == presenterId)
          : null;

      setState(() {
        _presenterParticipant = presenterParticipant;
        presenterId = presenterId;
      });
    });

    meeting.on(Events.participantJoined, (Participant participant) {
      log("${participant.displayName} JOINED");
      addParticipantListener(participant);
    });
  }

  addParticipantListener(Participant participant) {
    participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == "share") {
        setState(() {
          shareStream = stream;
        });
      }
    });
    participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == "share") {
        setState(() {
          shareStream = null;
        });
      }
    });
  }
}
