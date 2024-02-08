import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:faenonibeqwa/utils/extensions/string_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool fromNetwotk;
  const VideoPlayerWidget(
      {super.key, required this.videoPath, required this.fromNetwotk});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    _initcontrollers();

    super.initState();
  }

  Future<void> _initcontrollers() async {
    _videoPlayerController = widget.fromNetwotk
        ? VideoPlayerController.networkUrl(widget.videoPath.toUri)
        : VideoPlayerController.file(File(widget.videoPath));
    _videoPlayerController
        .initialize()
        .then((_) => setState(() => _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              aspectRatio: 16 / 9,
              autoInitialize: true,
              autoPlay: widget.fromNetwotk ? false : true,
              placeholder: const CircularProgressIndicator(color: Colors.amber),
              zoomAndPan: true,
            )));
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoPlayerController.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: Chewie(controller: _chewieController),
      );
    } else {
      return const SizedBox.shrink();
      // Shimmer.fromColors(
      //   baseColor: Colors.grey[300]!,
      //   highlightColor: Colors.grey[100]!,
      //   child: const AspectRatio(
      //     aspectRatio: 16 / 19,
      //     child: SizedBox(),
      //   ),
      // );
    }
  }
}
