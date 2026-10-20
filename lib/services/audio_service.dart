import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LessonAudioService {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  bool _configured = false;

  static const String _spotlightAudioDir = 'audio/spotlight2_part1';

  static const Set<String> _blendWordsV5 = {
    'sheep', 'fish', 'ship',
    'chick', 'cheese',
    'photo', 'dolphin', 'elephant',
  };

  // TH words are intentionally spoken by one British TTS voice.
  // We no longer use cut fragments from the p.14 recording for these words,
  // because repeated manual checks showed that those fragments were not a
  // reliable one-word source in the app.
  static const Set<String> _thWords = {
    'thumb', 'thimble', 'the', 'this',
  };

  static const Map<String, String> _britishLetterNames = {
    'A': 'ay', 'B': 'bee', 'C': 'see', 'D': 'dee', 'E': 'ee', 'F': 'ef',
    'G': 'gee', 'H': 'aitch', 'I': 'eye', 'J': 'jay', 'K': 'kay', 'L': 'el',
    'M': 'em', 'N': 'en', 'O': 'oh', 'P': 'pee', 'Q': 'cue', 'R': 'are',
    'S': 'ess', 'T': 'tee', 'U': 'you', 'V': 'vee', 'W': 'double u',
    'X': 'ex', 'Y': 'why', 'Z': 'zed',
  };

  Future<void> _configureTts() async {
    if (_configured) return;

    await _tts.setLanguage('en-GB');
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    // Prefer a real en-GB voice when the browser exposes one.
    try {
      final dynamic voices = await _tts.getVoices;
      if (voices is List) {
        for (final dynamic rawVoice in voices) {
          if (rawVoice is Map) {
            final name = rawVoice['name']?.toString();
            final locale = rawVoice['locale']?.toString();
            if (name != null &&
                locale != null &&
                locale.toLowerCase().startsWith('en-gb')) {
              await _tts.setVoice({'name': name, 'locale': locale});
              break;
            }
          }
        }
      }
    } catch (_) {
      // setLanguage('en-GB') remains the fallback.
    }

    _configured = true;
  }

  String _safeName(String text) => text
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');

  Future<void> _playAsset(String assetPath) async {
    await _tts.stop();
    await _player.stop();
    final normalized = assetPath.startsWith('assets/')
        ? assetPath.substring('assets/'.length)
        : assetPath;
    await _player.play(AssetSource(normalized));
  }

  Future<bool> _tryPlayAsset(String assetPath) async {
    try {
      await _playAsset(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _speakBritishWord(String word) async {
    await _configureTts();
    await _player.stop();
    await _tts.stop();
    await _tts.setSpeechRate(0.32);
    await _tts.speak(word);
  }

  Future<void> speakWord(String word) async {
    final safe = _safeName(word);

    // Deterministic fix for the whole TH page: one exact word goes to TTS,
    // never to a cut Spotlight fragment.
    if (_thWords.contains(safe)) {
      await _speakBritishWord(word);
      return;
    }

    if (_blendWordsV5.contains(safe)) {
      if (await _tryPlayAsset('$_spotlightAudioDir/word_${safe}_v5.mp3')) return;
    } else {
      if (await _tryPlayAsset('$_spotlightAudioDir/word_$safe.mp3')) return;
    }

    if (await _tryPlayAsset('audio/word_$safe.mp3')) return;

    await _speakBritishWord(word);
  }

  Future<void> speakLetterName(String letter) async {
    final normalized = letter.trim().toUpperCase();
    final fileName = 'letter_$normalized.mp3';

    if (await _tryPlayAsset('$_spotlightAudioDir/$fileName')) return;
    if (await _tryPlayAsset('audio/$fileName')) return;

    await _configureTts();
    await _tts.stop();
    await _player.stop();
    await _tts.setSpeechRate(0.40);
    await _tts.speak(_britishLetterNames[normalized] ?? normalized);
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
    await playPhonemeAsset(source);
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

  Future<void> playSpotlightClip(String fileName) async {
    await _playAsset('$_spotlightAudioDir/$fileName');
  }

  Future<void> dispose() async {
    await _tts.stop();
    await _player.dispose();
  }
}
