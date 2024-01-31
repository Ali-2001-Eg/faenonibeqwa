// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
// import 'package:better_player/better_player.dart';
import 'package:chewie/chewie.dart';
import 'package:faenonibeqwa/repositories/upload_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
// import 'package:video_player/video_player.dart';

class VideoViewWidget extends StatelessWidget {
  const VideoViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          final uploadRef = ref.watch(uploadVideoRepoProvider);
          final uploadRefState = ref.watch(videoProvider);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (uploadRefState == null)
                const Text('No video selected.')
              else
                VideoPlayerWidget(videoFile: uploadRefState),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  uploadRef.clearVideo();
                  uploadRef.pickVideo();
                },
                child: const Text('Pick Video'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadRef.uploadVideo,
                child: const Text('Upload Video'),
              ),
              ElevatedButton(
                onPressed: () async {
                  uploadRef.clearVideo();
                },
                child: const Text('Clear Video'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  const VideoPlayerWidget({super.key, required this.videoFile});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController controller;
  late ChewieController _chewieController;
  @override
  void initState() {
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
    _chewieController = ChewieController(videoPlayerController: controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _chewieController!.dispose();
    super.dispose();
  }
  // BetterPlayerController? betterPlayerController;

  // @override
  // void initState() {
  //   super.initState();
  //   BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
  //     BetterPlayerDataSourceType.network,
  //     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  //     // widget.videoFile.path,
  //   );
  //   betterPlayerController = BetterPlayerController(
  //     const BetterPlayerConfiguration(),
  //     betterPlayerDataSource: betterPlayerDataSource,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(controller: _chewieController),
        ),
      ),
    );
  }
}
