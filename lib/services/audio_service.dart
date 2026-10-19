import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LessonAudioService {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  bool _configured = false;

  static const Map<String, String> _britishLetterNames = {
    'A': 'ay',
    'B': 'bee',
    'C': 'see',
    'D': 'dee',
    'E': 'ee',
    'F': 'ef',
    'G': 'gee',
    'H': 'aitch',
    'I': 'eye',
    'J': 'jay',
    'K': 'kay',
    'L': 'el',
    'M': 'em',
    'N': 'en',
    'O': 'oh',
    'P': 'pee',
    'Q': 'cue',
    'R': 'are',
    'S': 'ess',
    'T': 'tee',
    'U': 'you',
    'V': 'vee',
    'W': 'double u',
    'X': 'ex',
    'Y': 'why',
    'Z': 'zed',
  };

  Future<void> _configureTts() async {
    if (_configured) return;
    await _tts.setLanguage('en-GB');
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    _configured = true;
  }

  String _safeName(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  Future<void> _playAsset(String assetPath) async {
    await _tts.stop();
    await _player.stop();
    final normalized = assetPath.startsWith('assets/')
        ? assetPath.substring('assets/'.length)
        : assetPath;
    await _player.play(AssetSource(normalized));
  }

  Future<void> speakWord(String word) async {
    final asset = 'audio/word_${_safeName(word)}.mp3';
    try {
      await _playAsset(asset);
      return;
    } catch (_) {
      // В режиме разработки без сгенерированных assets остаётся запасной TTS.
    }

    await _configureTts();
    await _tts.stop();
    await _player.stop();
    await _tts.setSpeechRate(0.45);
    await _tts.speak(word);
  }

  Future<void> speakLetterName(String letter) async {
    final normalized = letter.trim().toUpperCase();
    try {
      await _playAsset('audio/letter_$normalized.mp3');
      return;
    } catch (_) {
      // Запасной вариант только для разработки.
    }

    await _configureTts();
    await _tts.stop();
    await _player.stop();
    final spoken = _britishLetterNames[normalized] ?? normalized;
    await _tts.setSpeechRate(0.40);
    await _tts.speak(spoken);
  }

  Future<void> playPhonemeAsset(String assetPath) async {
    await _playAsset(assetPath);
  }

  Future<void> playPhonemeUrl(String source) async {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      await _tts.stop();
      await _player.stop();
      await _player.play(UrlSource(source));
      return;
    }
    await _playAsset(source);
  }

  Future<void> playPhonemeUrls(List<String> sources) async {
    await _tts.stop();
    await _player.stop();
    for (final source in sources) {
      if (source.startsWith('http://') || source.startsWith('https://')) {
        await _player.play(UrlSource(source));
      } else {
        final normalized = source.startsWith('assets/')
            ? source.substring('assets/'.length)
            : source;
        await _player.play(AssetSource(normalized));
      }
      await _player.onPlayerComplete.first;
    }
  }

  Future<void> dispose() async {
    await _tts.stop();
    await _player.dispose();
  }
}
