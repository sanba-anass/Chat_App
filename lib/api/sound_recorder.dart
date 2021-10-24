import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isinit = false;
  init() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openAudioSession();
    _isinit = true;
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone Permssion dinied');
    }
  }

  void dispose() {
    if (!_isinit) return;
    _audioRecorder!.closeAudioSession();
    _isinit = false;
    _audioRecorder = null;
  }

  final path = 'audio.aac';
  Future<void> _record() async {
    if (!_isinit) return;
    await _audioRecorder!.startRecorder(toFile: path);
  }

  Future<void> _stop() async {
    await _audioRecorder!.stopRecorder();
  }

  Future<void> togglerecording() async {
    if (!_isinit) return;
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
