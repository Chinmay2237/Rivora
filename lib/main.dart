import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  AudioPlayer.global.setAudioContext(
    AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: false,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: const {
          AVAudioSessionOptions.mixWithOthers,
        },
      ),
    ),
  );
  runApp(const RivoraApp());
}

