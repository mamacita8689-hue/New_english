import 'package:flutter/material.dart';

import '../data/blend_words.dart';
import '../models/blend_word.dart';
import '../services/audio_service.dart';

class BlendingScreen extends StatefulWidget {
  const BlendingScreen({super.key});

  @override
  State<BlendingScreen> createState() => _BlendingScreenState();
}

class _BlendingScreenState extends State<BlendingScreen> {
  final LessonAudioService _audio = LessonAudioService();
  int _index = 0;
  bool _playing = false;

  BlendWord get _word => blendWords[_index];

  Future<void> _playParts() async {
    if (_playing) return;
    setState(() => _playing = true);
    try {
      await _audio.playPhonemeUrls(_word.phonemeAudioUrls);
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

  Future<void> _playWholeWord() async {
    if (_playing) return;
    setState(() => _playing = true);
    try {
      await _audio.speakWord(_word.word);
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

  void _next() {
    setState(() => _index = (_index + 1) % blendWords.length);
  }

  void _previous() {
    setState(() => _index = (_index - 1 + blendWords.length) % blendWords.length);
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = _word;

    return Scaffold(
      appBar: AppBar(title: const Text('Складываем слово')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Слово ${_index + 1} из ${blendWords.length}',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 18),
              const Text(
                'Послушай звуки по отдельности, потом соедини их в слово.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: word.chunks.map((chunk) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      chunk,
                      style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: _playing ? null : _playParts,
                icon: const Icon(Icons.hearing_rounded),
                label: const Text('Послушать по звукам'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: _playing ? null : _playWholeWord,
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text('Послушать целое слово'),
              ),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Text(word.emoji, style: const TextStyle(fontSize: 72)),
                    const SizedBox(height: 8),
                    Text(
                      word.word,
                      style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previous,
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Назад'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _next,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Дальше'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
