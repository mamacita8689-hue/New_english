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
    await _selectPreferredBritishVoice();
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    _configured = true;
  }

  Future<void> _selectPreferredBritishVoice() async {
    try {
      final dynamic rawVoices = await _tts.getVoices;
      if (rawVoices is! List) return;

      Map<dynamic, dynamic>? firstBritish;
      Map<dynamic, dynamic>? preferred;

      for (final voice in rawVoices) {
        if (voice is! Map) continue;

        final localeRaw = '${voice['locale'] ?? ''}';
        final locale = localeRaw.replaceAll('_', '-').toLowerCase();
        if (locale != 'en-gb' && !locale.startsWith('en-gb')) continue;

        firstBritish ??= voice;

        final name = '${voice['name'] ?? ''}'.toLowerCase();
        final isStrongPreference =
            name.contains('google uk english female') ||
            name.contains('sonia') ||
            name.contains('libby') ||
            name.contains('natural');

        if (isStrongPreference) {
          preferred = voice;
          break;
        }
      }

      final selected = preferred ?? firstBritish;
      if (selected == null) return;

      final name = '${selected['name'] ?? ''}';
      final locale = '${selected['locale'] ?? 'en-GB'}';
      if (name.isEmpty) return;

      await _tts.setVoice({
        'name': name,
        'locale': locale,
      });
    } catch (_) {
      // Если устройство не сообщает список голосов, остаёмся на en-GB.
    }
  }

  Future<void> speakWord(String word) async {
    await _configureTts();
    await _tts.stop();
    await _player.stop();

    // Немного быстрее прежнего: на 0.38 некоторые короткие слова,
    // особенно queen, звучали слишком растянуто и неестественно.
    await _tts.setSpeechRate(0.45);
    await _tts.speak(word);
  }

  Future<void> speakLetterName(String letter) async {
    await _configureTts();
    await _tts.stop();
    await _player.stop();

    final normalized = letter.trim().toUpperCase();
    final spoken = _britishLetterNames[normalized] ?? normalized;

    await _tts.setSpeechRate(0.40);
    await _tts.speak(spoken);
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
