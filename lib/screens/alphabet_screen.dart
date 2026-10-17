import 'package:flutter/material.dart';
import '../data/alphabet.dart';
import '../models/letter_lesson.dart';
import '../services/audio_service.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  final LessonAudioService _audio = LessonAudioService();
  String? _playingKey;

  Future<void> _playName(LetterLesson letter) async {
    final key = '${letter.upper}-name';
    if (_playingKey != null) return;
    setState(() => _playingKey = key);
    try {
      await _audio.speakLetterName(letter.upper);
    } finally {
      if (mounted) setState(() => _playingKey = null);
    }
  }

  Future<void> _playSound(LetterLesson letter) async {
    final key = '${letter.upper}-sound';
    if (_playingKey != null) return;
    setState(() => _playingKey = key);
    try {
      await _audio.playPhonemeUrls(letter.soundAudioUrls);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось воспроизвести звук.')),
        );
      }
    } finally {
      if (mounted) setState(() => _playingKey = null);
    }
  }

  Future<void> _playExample(LetterLesson letter) async {
    final key = '${letter.upper}-example';
    if (_playingKey != null) return;
    setState(() => _playingKey = key);
    try {
      await _audio.speakWord(letter.example);
    } finally {
      if (mounted) setState(() => _playingKey = null);
    }
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Алфавит и звуки')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Сначала послушай название буквы, потом её основной звук.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Важно: название буквы и звук — не одно и то же.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 18),
            ...alphabetLessons.map(_buildLetterCard),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterCard(LetterLesson letter) {
    final namePlaying = _playingKey == '${letter.upper}-name';
    final soundPlaying = _playingKey == '${letter.upper}-sound';
    final examplePlaying = _playingKey == '${letter.upper}-example';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      '${letter.upper}${letter.lower}',
                      style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Основной звук ${letter.phoneme}',
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${letter.emoji} ${letter.example}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _playingKey == null ? () => _playName(letter) : null,
                    icon: Icon(namePlaying ? Icons.hourglass_top : Icons.record_voice_over),
                    label: const Text('Название буквы'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: _playingKey == null ? () => _playSound(letter) : null,
                    icon: Icon(soundPlaying ? Icons.hourglass_top : Icons.volume_up),
                    label: const Text('Звук'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _playingKey == null ? () => _playExample(letter) : null,
                    icon: Icon(examplePlaying ? Icons.hourglass_top : Icons.play_arrow),
                    label: const Text('Слово'),
                  ),
                ],
              ),
              if (letter.note.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  letter.note,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
