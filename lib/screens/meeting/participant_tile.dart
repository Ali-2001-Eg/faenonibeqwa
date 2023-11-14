import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:videosdk/videosdk.dart';

import '../../controllers/auth_controller.dart';

class ParticipantTile extends ConsumerStatefulWidget {
  final Participant participant;

  const ParticipantTile({super.key, required this.participant});

  @override
  ConsumerState<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends ConsumerState<ParticipantTile> {
  Stream? videoStream;
  Stream? audioStream;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // initial video stream for the participant
    widget.participant.streams.forEach((key, Stream stream) {
      setState(() {
        if (stream.kind == 'video') {
          videoStream = stream;
        } else if (stream.kind == 'audio') {
          audioStream = stream;
        }
      });
    });
    _initStreamListeners();
    super.initState();
  }

  _initStreamListeners() {
    widget.participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = stream);
      } else if (stream.kind == 'audio') {
        setState(() => audioStream = stream);
      }
    });

    widget.participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = null);
      } else if (stream.kind == 'audio') {
        setState(() => audioStream = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.participant.displayName;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: videoStream != null
          ? RTCVideoView(
              videoStream?.renderer as RTCVideoRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: context.theme.cardColor,
              ),
              child: FutureBuilder<String>(
                  future: ref.read(authControllerProvider).getPhotoUrl,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    if (snapshot.data == '') {
                      return Container();
                    }
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!),
                    );
                  }),
            ),
    );
  }
}
