

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';

import 'package:video_player/video_player.dart';

class VideoFileWidget extends StatefulWidget {
  final File file;
  VideoFileWidget({Key? key, required this.file}) : super(key: key);

  @override
  State<VideoFileWidget> createState() => _VideoFileWidgetState();
}

class _VideoFileWidgetState extends State<VideoFileWidget> {
  ChewieController? _chewieController;
  VideoPlayerController? _playerController;
  Future? _inilizePlayerfuture;
  @override
  void initState() {
    _playerController = VideoPlayerController.file(widget.file);
    _inilizePlayerfuture = _playerController!.initialize().then(
          (value) => _chewieController = ChewieController(
            videoPlayerController: _playerController!,
            aspectRatio: _playerController!.value.aspectRatio,
            autoInitialize: true,
            looping: false,
            allowedScreenSleep: false,
            materialProgressColors: ChewieProgressColors(
              bufferedColor: Colors.grey,
              playedColor: Colors.red,
              handleColor: Colors.red,
            ),
          ),
        );

    super.initState();
  }

  @override
  void dispose() {
    _chewieController!.dispose();
    _playerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return FutureBuilder(
      future: _inilizePlayerfuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _playerController!.value.aspectRatio,
            child: Chewie(
              controller: _chewieController!,
            ),
          );
        } else {
          return AspectRatio(
            aspectRatio: _playerController!.value.aspectRatio,
            child: Container(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }
      },
    );
  }
}
