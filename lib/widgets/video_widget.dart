import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';

import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  VideoWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  ChewieController? _chewieController;
  VideoPlayerController? _playerController;
  Future? _inilizePlayerfuture;
  @override
  void initState() {
    super.initState();
    _playerController = VideoPlayerController.network(widget.url);
    _inilizePlayerfuture = _playerController!.initialize().then(
          (value) => _chewieController = ChewieController(
            videoPlayerController: _playerController!,
            aspectRatio: _playerController?.value.aspectRatio,
            autoInitialize: true,
            looping: false,
            allowedScreenSleep: false,
            materialProgressColors: ChewieProgressColors(
              bufferedColor: Colors.grey,
              playedColor: Colors.deepPurple.shade400,
              handleColor: Colors.deepPurple.shade400,
            ),
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController!.dispose();
    _playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.url.toUpperCase());
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
