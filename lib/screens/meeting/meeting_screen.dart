// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/controllers/meeting_controller.dart';
import 'package:faenonibeqwa/screens/home/main_sceen.dart';
import 'package:faenonibeqwa/utils/base/constants.dart';
import 'package:faenonibeqwa/utils/responsive/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import '../../utils/shared/widgets/custom_button.dart';
import 'chat_widget.dart';

class MeetingScreen extends ConsumerStatefulWidget {
  static const String routeName = '/meeting';
  final bool isBroadcaster;
  final String channelId;
  const MeetingScreen({
    Key? key,
    required this.isBroadcaster,
    required this.channelId,
  }) : super(key: key);

  @override
  ConsumerState<MeetingScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends ConsumerState<MeetingScreen> {
  late final RtcEngine _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool cameraDisabled = true;
  bool isMuted = false;
  bool isScreenSharing = false;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  void _initEngine() async {
    _engine =
        await RtcEngine.createWithContext(RtcEngineContext(AppConstants.appId));
    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  String baseUrl = AppConstants.baseUrl;

  String? token;

  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(
          '$baseUrl/rtc/${widget.channelId}/publisher/userAccount/${FirebaseAuth.instance.currentUser!.uid}/'),
    );

    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  void _addListeners() {
    _engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      debugPrint('joinChannelSuccess $channel $uid $elapsed');
    }, userJoined: (uid, elapsed) {
      debugPrint('userJoined $uid $elapsed');
      setState(() {
        remoteUid.add(uid);
      });
    }, userOffline: (uid, reason) {
      debugPrint('userOffline $uid $reason');
      setState(() {
        remoteUid.removeWhere((element) => element == uid);
      });
    }, leaveChannel: (stats) {
      debugPrint('leaveChannel $stats');
      setState(() {
        remoteUid.clear();
      });
    }, tokenPrivilegeWillExpire: (token) async {
      await getToken();
      await _engine.renewToken(token);
    }));
  }

  void _joinChannel() async {
    await getToken();
    if (token != null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await [Permission.microphone, Permission.camera].request();
      }
      await _engine.joinChannelWithUserAccount(
        token,
        widget.channelId,
        FirebaseAuth.instance.currentUser!.uid,
      );
    }
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      debugPrint('switchCamera $err');
    });
  }

  void _toggleCamera() {
    setState(() {
      cameraDisabled = !cameraDisabled;
    });

    _engine.enableLocalVideo(cameraDisabled);
  }

  void _onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.enableLocalAudio(isMuted);
  }

  _startScreenShare() async {
    final helper = await _engine.getScreenShareHelper(
        appGroup: kIsWeb || Platform.isWindows ? null : 'io.agora');
    await helper.disableAudio();
    await helper.enableVideo();
    await helper.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await helper.setClientRole(ClientRole.Broadcaster);
    var windowId = 0;
    var random = Random();
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isAndroid)) {
      final windows = _engine.enumerateWindows();
      if (windows.isNotEmpty) {
        final index = random.nextInt(windows.length - 1);
        debugPrint('Screensharing window with index $index');
        windowId = windows[index].id;
      }
    }
    await helper.startScreenCaptureByWindowId(windowId);
    setState(() {
      isScreenSharing = true;
    });
    await helper.joinChannelWithUserAccount(
      token,
      widget.channelId,
      ref.read(authControllerProvider).userInfo.uid,
    );
  }

  _stopScreenShare() async {
    final helper = await _engine.getScreenShareHelper();
    await helper.destroy().then((value) {
      setState(() {
        isScreenSharing = false;
      });
    }).catchError((err) {
      debugPrint('StopScreenShare $err');
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if ('${ref.read(authControllerProvider).userInfo.uid}${ref.read(authControllerProvider).userInfo.displayName}' ==
        widget.channelId) {
      await ref
          .read(meetingControllerProvider)
          .endMeeting(widget.channelId)
          .then((value) => (mounted)
              ? Navigator.pushReplacementNamed(context, MainScreen.routeName)
              : null);
    } else {
      await ref
          .read(meetingControllerProvider)
          .updateViewCount(widget.channelId, false)
          .then((value) => (mounted)
              ? Navigator.pushReplacementNamed(context, MainScreen.routeName)
              : null);
    }
  }

  void _toggleScreenSharing() {
    if (isScreenSharing) {
      _engine.stopScreenCapture();
    } else {
      // Example values, replace with your actual values
      int windowId = 0; // Replace with the ID of the window you want to capture
      Rect rect = Rect(
          left: 0,
          top: 0,
          right: 720,
          bottom: 1280); // Replace with the region to be captured
      int captureFreq = 15; // Replace with the desired frame rate
      int bitrate = 1200; // Replace with the desired bitrate

      _engine.startScreenCapture(windowId, captureFreq, rect, bitrate);
    }
    setState(() {
      isScreenSharing = !isScreenSharing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = ref.read(authControllerProvider).userInfo;
    print(user.email);
    return WillPopScope(
      onWillPop: () async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ResponsiveLayout(
            desktopBody: Row(
              children: [
                Column(
                  children: [
                    _renderVideo(user),
                    if ("${user.uid}${user.displayName}" == widget.channelId)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: _switchCamera,
                            child: const Text('Switch Camera'),
                          ),
                          InkWell(
                            onTap: _onToggleMute,
                            child: Text(isMuted ? 'Unmute' : 'Mute'),
                          ),
                          InkWell(
                            onTap: isScreenSharing
                                ? _stopScreenShare
                                : _startScreenShare,
                            child: Text(
                              isScreenSharing
                                  ? 'Stop ScreenSharing'
                                  : 'Start Screensharing',
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                ChatWidget(channelId: widget.channelId),
              ],
            ),
            mobileBody: Column(
              children: [
                /* SizedBox(
                  height: 500,
                  child: RtcLocalView.SurfaceView(
                    channelId: widget.channelId, // Replace with your channel ID
                  ),
                ), */
                _renderVideo(user),
                //_displayShareScreen(),
                if ("${user.uid}${user.displayName}" == widget.channelId)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: _onToggleMute,
                        child: Icon(isMuted ? Icons.mic_off : Icons.mic),
                      ),
                      InkWell(
                        onTap: _toggleCamera,
                        child: Icon(!cameraDisabled
                            ? Icons.videocam_off
                            : Icons.videocam),
                      ),
                      InkWell(
                        onTap: _switchCamera,
                        child: const Icon(Icons.switch_camera),
                      ),
                      InkWell(
                        onTap: _toggleScreenSharing,
                        child: Icon(
                          Icons.screen_share,
                          color: isScreenSharing ? Colors.blue : Colors.grey,
                        ),
                      ),
                      if (widget.isBroadcaster)
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.message,
                          ),
                        ),
                      InkWell(
                        onTap: _leaveChannel,
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: ChatWidget(
                    channelId: widget.channelId,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AspectRatio _renderVideo(User user) {
    return AspectRatio(
        aspectRatio: 16 / 16,
        child: "${user.uid}${user.displayName}" == widget.channelId
            ? isScreenSharing
                ? const RtcLocalView.TextureView.screenShare()
                : const RtcLocalView.SurfaceView(
                    zOrderMediaOverlay: true,
                    zOrderOnTop: true,
                  )
            : remoteUid.isNotEmpty
                ? RtcRemoteView.SurfaceView(
                    uid: remoteUid[0],
                    channelId: widget.channelId,
                  )
                : RtcRemoteView.TextureView(
                    uid: remoteUid[0],
                    channelId: widget.channelId,
                  ));
  }

  _displayShareScreen() {
    return AspectRatio(
      aspectRatio: 16 / 16,
      child: widget.isBroadcaster && isScreenSharing
          ? RtcLocalView.TextureView.screenShare()
          : remoteUid.isNotEmpty
              ? RtcRemoteView.SurfaceView(
                  uid: remoteUid[0], channelId: widget.channelId)
              : Container(),
    );
  }
}
