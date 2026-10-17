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
    await _player.stop();
    await _tts.speak(word);
  }

  Future<void> speakLetterName(String letter) async {
    await _configureTts();
    await _tts.stop();
    await _player.stop();
    await _tts.speak(letter);
  }

  Future<void> playPhonemeAsset(String assetPath) async {
    await _tts.stop();
    await _player.stop();
    final normalized = assetPath.startsWith('assets/')
        ? assetPath.substring('assets/'.length)
        : assetPath;
    await _player.play(AssetSource(normalized));
  }

  Future<void> playPhonemeUrl(String url) async {
    await _tts.stop();
    await _player.stop();
    await _player.play(UrlSource(url));
  }

  Future<void> playPhonemeUrls(List<String> urls) async {
    await _tts.stop();
    await _player.stop();
    for (final url in urls) {
      await _player.play(UrlSource(url));
      await _player.onPlayerComplete.first;
    }
  }

  Future<void> dispose() async {
    await _tts.stop();
    await _player.dispose();
  }
}
