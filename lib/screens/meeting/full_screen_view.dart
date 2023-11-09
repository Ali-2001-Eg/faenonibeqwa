
import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

class FullScreenView extends StatelessWidget {
  const FullScreenView({
    super.key,
    required this.shareStream,
  });

  final Stream? shareStream;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 10,
        right: 10,
        child: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) {
              return AspectRatio(
                aspectRatio: 1 / 1,
                child: RTCVideoView(
                  shareStream?.renderer as RTCVideoRenderer,
                  objectFit: RTCVideoViewObjectFit
                      .RTCVideoViewObjectFitContain,
                ),
              );
            }));
          },
          icon: const Icon(Icons.fullscreen),
        ));
  }
}
