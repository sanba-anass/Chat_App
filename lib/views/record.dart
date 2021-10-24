import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_sound_lite/flutter_sound.dart';

class AudioComp extends StatefulWidget {
  final String url;
  const AudioComp({
    Key? key,
    required this.url,
  }) : super(key: key);
  @override
  _AudioCompState createState() => _AudioCompState();
}

class _AudioCompState extends State<AudioComp> {
  bool _isplaying = false;
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = Duration();
  Duration position = Duration();

  @override
  void initState() {
    super.initState();

    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(() {
        duration = dd;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      setState(() {
        position = dd;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                _isplaying = !_isplaying;
              });

              getAudio();
            },
            child: Icon(
              _isplaying ? Icons.pause : Icons.play_arrow,
              size: 28,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 6),
              trackHeight: 3,
            ),
            child: Container(
              width: 200,
              child: Column(
                children: [
                  SizedBox(
                    height: 13,
                  ),
                  slider(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTimeString(position.inMilliseconds),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        getTimeString(duration.inMilliseconds),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void getAudio() async {
    if (_isplaying) {
      await audioPlayer.play(widget.url);
      /*  Future.delayed(duration).whenComplete(() {
        setState(() {
          _isplaying = false;
          position = Duration.zero;
        });
      }); */
    } else {
      audioPlayer.pause();
    }
  }

  String getTimeString(int milliseconds) {
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds';
  }

  Slider slider() {
    return Slider(
      activeColor: Colors.white,
      inactiveColor: Colors.grey,
      value: position.inSeconds.toDouble(),
      onChanged: (value) {
        setState(() {
          audioPlayer.seek(
            Duration(
              seconds: value.toInt(),
            ),
          );
        });
      },
      max: duration.inSeconds.toDouble(),
      min: 0.0,
    );
  }
}
