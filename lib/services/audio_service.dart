import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LessonAudioService {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  bool _configured = false;

  Future<void> _configureTts() async {
    if (_configured) return;
    await _tts.setLanguage('en-GB');
    await _tts.setSpeechRate(0.38);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    _configured = true;
  }

  Future<void> speakWord(String word) async {
    await _configureTts();
    await _tts.stop();
    await _tts.speak(word);
  }

  Future<void> playPhonemeAsset(String assetPath) async {
    await _player.stop();
    final normalized = assetPath.startsWith('assets/')
        ? assetPath.substring('assets/'.length)
        : assetPath;
    await _player.play(AssetSource(normalized));
  }

  Future<void> dispose() async {
    await _tts.stop();
    await _player.dispose();
  }
}
