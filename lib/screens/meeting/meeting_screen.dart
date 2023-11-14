// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/controllers/meeting_controller.dart';
import 'package:faenonibeqwa/repositories/meeting_repo.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_app_bar.dart';
import 'package:faenonibeqwa/screens/meeting/participant_tile.dart';
import 'package:faenonibeqwa/screens/meeting/share_screen_view.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:videosdk/videosdk.dart';
import '../../utils/base/constants.dart';
import 'meetings_controls.dart';

final String userId = Random().nextInt(10000).toString();

class MeetingScreen extends ConsumerStatefulWidget {
  //secret key to enter the conference
  final String conferenceID;
  final String token;
  static const String routeName = '/meeting-screen';
  const MeetingScreen({
    Key? key,
    required this.conferenceID,
    required this.token,
  }) : super(key: key);

  @override
  ConsumerState<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends ConsumerState<MeetingScreen> {
  late Room _room;

  Map<String, Participant> participants = {};
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() async {
    // create room
    _room = VideoSDK.createRoom(
      roomId: widget.conferenceID,
      token: widget.token,
      displayName: await ref.read(authControllerProvider).getName,
      micEnabled: ref.read(micEnabled),
      camEnabled: ref.read(camEnabled),
      defaultCameraIndex:
          1, // Index of MediaDevices will be used to set default camera
    );
    _setMeetingEventListener();

    // Join room
    _room.join();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isMicEnabled = ref.watch(micEnabled.state).state;
    bool isCamEnabled = ref.watch(camEnabled.state).state;
    bool isShareScreenEnabled = ref.watch(shareScreenEnabled.state).state;
    //_room.end();

    return SafeArea(
        child: WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(context.screenWidth, 60.h),
          child: MeetingAppBar(
            meeting: _room,
            token: AppConstants.videosdkToken,
            isFullScreen: false,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                    child: OrientationBuilder(builder: (context, orientation) {
                  return Flex(
                    direction: orientation == Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal,
                    children: [
                      ScreenShareView(
                        meeting: _room,
                        onStopShareScreen: () async {
                          isShareScreenEnabled = false;

                          await _room.disableScreenShare();
                        },
                      ),
                    ],
                  );
                })),
              ),
              //render all participant

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 300,
                    ),
                    itemBuilder: (context, index) {
                      if (kDebugMode) {
                        print(
                            'participants number is ${participants.entries.map((e) => e.value)}');
                      }
                      return ParticipantTile(
                          key: Key(participants.values.elementAt(index).id),
                          participant: participants.values.elementAt(index));
                    },
                    itemCount: participants.length,
                  ),
                ),
              ),
              MeetingControls(
                onToggleMicButtonPressed: () {
                  isMicEnabled ? _room.muteMic() : _room.unmuteMic();
                  ref.read(meetingControllerProvider).toggleMicEnabled;
                },
                onToggleCameraButtonPressed: () {
                  isCamEnabled ? _room.disableCam() : _room.enableCam();
                  ref.read(meetingControllerProvider).toggleCamEnabled;
                },
                onLeaveButtonPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('مغادره المكالمه'),
                        content: const Text('تأكيد الخروج من المكالمه'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Close the dialog and navigate away
                              Navigator.of(context).pop();
                              _room.disableScreenShare();
                              isShareScreenEnabled = false;
                              //to ensure thet share screen is not enabled
                              Future.delayed(const Duration(seconds: 1),
                                  () => _room.leave());
                            },
                            child: const Text(
                              'تأكيد',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text('البقاء'),
                          ),
                        ],
                      );
                    }),
                onToggelShareScreenPressed: () {
                  if (ref.read(shareScreenEnabled)) {
                    _room.disableScreenShare();
                    isShareScreenEnabled = false;
                  } else {
                    _room.enableScreenShare();
                    isShareScreenEnabled = true;
                  }
                },
                isMicEnabled: isMicEnabled,
                isCamEnabled: isCamEnabled,
                isScreenShareEnabled: isShareScreenEnabled,
              ),
            ],
          ),
        ),
      ),
    ));
  }

// listening to meeting events
  void _setMeetingEventListener() {
    _room.on(Events.roomJoined, () {
      setState(() {
        participants.putIfAbsent(
            _room.localParticipant.id, () => _room.localParticipant);
      });
    });

    _room.on(
      Events.participantJoined,
      (Participant participant) {
        setState(
          () => participants.putIfAbsent(participant.id, () => participant),
        );
      },
    );

    _room.on(Events.participantLeft, (String participantId) {
      if (participants.containsKey(participantId)) {
        setState(
          () => participants.remove(participantId),
        );
      }
    });

    _room.on(Events.roomLeft, () {
      participants.clear();
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  Future<bool> _onWillPop() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('مغادره المكالمه'),
            content: const Text('تأكيد الخروج من المكالمه'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Close the dialog and navigate away
                  Navigator.of(context).pop();
                  _room.disableScreenShare();
                  ref.read(shareScreenEnabled.state).state = false;
                  //to ensure thet share screen is not enabled
                  Future.delayed(
                      const Duration(seconds: 1), () => _room.leave());
                },
                child: const Text(
                  'تأكيد',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('البقاء'),
              ),
            ],
          );
        });
    return true;
  }
}
