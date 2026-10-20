import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../services/audio_service.dart';
import 'quiz_screen.dart';

class LessonScreen extends StatefulWidget {
  final SoundLesson lesson;

  const LessonScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final LessonAudioService _audio = LessonAudioService();
  bool _playing = false;

  Future<void> _speakWord(String word) async {
    if (_playing) return;
    setState(() => _playing = true);
    try {
      await _audio.speakWord(word);
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

  Future<void> _playPhoneme() async {
    if (_playing) return;

    final asset = widget.lesson.phonemeAudioAsset;
    final url = widget.lesson.phonemeAudioUrl;

    if (asset == null && url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Аудиозапись этого звука пока не добавлена.')),
      );
      return;
    }

    setState(() => _playing = true);
    try {
      if (asset != null) {
        await _audio.playPhonemeAsset(asset);
      } else if (url != null) {
        await _audio.playPhonemeUrl(url);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось воспроизвести звук.')),
        );
      }
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Text(
                    lesson.grapheme,
                    style: const TextStyle(fontSize: 82, height: 1, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    lesson.phoneme,
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _playing ? null : _playPhoneme,
                    icon: Icon(_playing ? Icons.hourglass_top_rounded : Icons.volume_up_rounded),
                    label: Text(_playing ? 'Загрузка...' : 'Послушать звук'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              lesson.explanation,
              style: const TextStyle(fontSize: 18, height: 1.45, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            const Text(
              'Послушай слова',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...lesson.examples.map(
              (example) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Text(example.emoji, style: const TextStyle(fontSize: 38)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            example.word,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                          ),
                        ),
                        IconButton.filledTonal(
                          tooltip: 'Послушать ${example.word}',
                          onPressed: _playing ? null : () => _speakWord(example.word),
                          icon: const Icon(Icons.volume_up_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (lesson.audioCredit != null) ...[
              const SizedBox(height: 8),
              Text(
                'Аудио: ${lesson.audioCredit}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 17),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(lesson: lesson),
                  ),
                );
              },
              child: const Text('Проверить себя'),
            ),
          ],
        ),
      ),
    );
  }
}
