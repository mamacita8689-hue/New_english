import 'dart:math';

import 'package:flutter/material.dart';

import '../data/lessons.dart';
import '../models/lesson.dart';
import '../services/audio_service.dart';

enum SoundPracticeMode {
  hearAndChooseGrapheme,
  seeAndChooseSound,
}

class SoundPracticeScreen extends StatefulWidget {
  final SoundPracticeMode mode;

  const SoundPracticeScreen({
    super.key,
    required this.mode,
  });

  @override
  State<SoundPracticeScreen> createState() => _SoundPracticeScreenState();
}

class _PracticeQuestion {
  final SoundLesson target;
  final List<SoundLesson> options;

  const _PracticeQuestion({
    required this.target,
    required this.options,
  });
}

class _SoundPracticeScreenState extends State<SoundPracticeScreen> {
  static const int _questionCount = 10;

  final LessonAudioService _audio = LessonAudioService();
  final Random _random = Random();

  late List<_PracticeQuestion> _questions;
  int _index = 0;
  int _firstTryScore = 0;
  bool _answered = false;
  bool _mistake = false;
  bool _playing = false;
  bool _finished = false;
  final Set<String> _wrongIds = {};

  _PracticeQuestion get _question => _questions[_index];

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
  }

  List<_PracticeQuestion> _buildQuestions() {
    final pool = List<SoundLesson>.from(soundLessons)..shuffle(_random);
    final selected = pool.take(min(_questionCount, pool.length)).toList();

    return selected.map((target) {
      final distractors = soundLessons
          .where((lesson) =>
              lesson.id != target.id &&
              !(lesson.grapheme == target.grapheme &&
                  lesson.phoneme == target.phoneme))
          .toList()
        ..shuffle(_random);

      final options = <SoundLesson>[target, ...distractors.take(2)]
        ..shuffle(_random);

      return _PracticeQuestion(target: target, options: options);
    }).toList();
  }

  Future<void> _playSample(SoundLesson lesson) async {
    if (_playing || lesson.phonemeAudioUrl == null) return;
    setState(() => _playing = true);
    try {
      await _audio.playPhonemeUrl(lesson.phonemeAudioUrl!);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось воспроизвести аудиообразец.')),
        );
      }
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

  void _choose(SoundLesson option) {
    if (_answered) return;

    if (option.id == _question.target.id) {
      setState(() {
        _answered = true;
        if (!_mistake) _firstTryScore++;
      });
      return;
    }

    setState(() {
      _mistake = true;
      _wrongIds.add(option.id);
    });
  }

  void _next() {
    if (_index >= _questions.length - 1) {
      setState(() => _finished = true);
      return;
    }

    setState(() {
      _index++;
      _answered = false;
      _mistake = false;
      _wrongIds.clear();
    });
  }

  void _restart() {
    setState(() {
      _questions = _buildQuestions();
      _index = 0;
      _firstTryScore = 0;
      _answered = false;
      _mistake = false;
      _wrongIds.clear();
      _finished = false;
    });
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _buildResult();

    final listenMode = widget.mode == SoundPracticeMode.hearAndChooseGrapheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(listenMode ? 'Услышь сочетание' : 'Найди правильный звук'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(value: (_index + 1) / _questions.length),
              const SizedBox(height: 12),
              Text(
                'Задание ${_index + 1} из ${_questions.length}',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              if (listenMode) _buildListenPrompt() else _buildGraphemePrompt(),
              const SizedBox(height: 24),
              if (listenMode) _buildGraphemeOptions() else _buildSoundOptions(),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _answered
                    ? Column(
                        key: const ValueKey('correct'),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Верно! ⭐',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _next,
                            child: Text(
                              _index == _questions.length - 1
                                  ? 'Результат'
                                  : 'Следующее',
                            ),
                          ),
                        ],
                      )
                    : _mistake
                        ? Container(
                            key: const ValueKey('retry'),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Попробуй ещё раз. Можно снова послушать слово-образец.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListenPrompt() {
    final sampleWord = _question.target.examples.first.word;
    return Column(
      children: [
        const Text(
          'Послушай слово. Какое сочетание букв в нём слышится?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'Официальный образец Spotlight: $sampleWord',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          ),
          onPressed: _playing ? null : () => _playSample(_question.target),
          icon: Icon(_playing ? Icons.hourglass_top : Icons.volume_up_rounded),
          label: Text(
            _playing ? 'Слушаем…' : 'Послушать слово',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildGraphemePrompt() {
    final target = _question.target;
    return Column(
      children: [
        const Text(
          'Как звучит это сочетание?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 18),
        Container(
          width: 180,
          height: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Text(
            target.grapheme,
            style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Пример: ${target.examples.first.word}',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildGraphemeOptions() {
    return Row(
      children: _question.options.map((option) {
        final wrong = _wrongIds.contains(option.id);
        final correct = _answered && option.id == _question.target.id;
        final label = option.grapheme == 'TH'
            ? '${option.grapheme}\n${option.examples.first.word}'
            : option.grapheme;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Material(
              color: correct
                  ? Colors.green.shade100
                  : wrong
                      ? Colors.grey.shade200
                      : Colors.white,
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                onTap: wrong ? null : () => _choose(option),
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: option.grapheme.length > 2 ? 24 : 30,
                      fontWeight: FontWeight.w900,
                      color: wrong ? Colors.grey.shade500 : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSoundOptions() {
    return Column(
      children: _question.options.map((option) {
        final wrong = _wrongIds.contains(option.id);
        final correct = _answered && option.id == _question.target.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: correct
                ? Colors.green.shade100
                : wrong
                    ? Colors.grey.shade200
                    : Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    tooltip: 'Послушать ${option.examples.first.word}',
                    onPressed: _playing ? null : () => _playSample(option),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${option.phoneme}  (${option.examples.first.word})',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: wrong ? Colors.grey.shade500 : null,
                      ),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: wrong ? null : () => _choose(option),
                    child: const Text('Выбрать'),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResult() {
    return Scaffold(
      appBar: AppBar(title: const Text('Результат')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _firstTryScore >= 4 ? '🌟' : '👏',
                  style: const TextStyle(fontSize: 76),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Тренировка закончена!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Text(
                  'С первого раза: $_firstTryScore из ${_questions.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                FilledButton.icon(
                  onPressed: _restart,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Ещё раз'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Вернуться'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
