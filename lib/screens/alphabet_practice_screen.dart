import 'dart:math';

import 'package:flutter/material.dart';

import '../data/alphabet.dart';
import '../models/letter_lesson.dart';
import '../services/audio_service.dart';

enum AlphabetPracticeMode {
  hearAndChooseLetter,
  seeAndChooseSound,
}

class AlphabetPracticeScreen extends StatefulWidget {
  final AlphabetPracticeMode mode;

  const AlphabetPracticeScreen({
    super.key,
    required this.mode,
  });

  @override
  State<AlphabetPracticeScreen> createState() => _AlphabetPracticeScreenState();
}

class _PracticeQuestion {
  final LetterLesson target;
  final List<LetterLesson> options;

  const _PracticeQuestion({
    required this.target,
    required this.options,
  });
}

class _AlphabetPracticeScreenState extends State<AlphabetPracticeScreen> {
  static const int _questionCount = 10;

  final LessonAudioService _audio = LessonAudioService();
  final Random _random = Random();

  late List<_PracticeQuestion> _questions;
  int _index = 0;
  int _firstTryScore = 0;
  bool _answered = false;
  bool _mistakeOnCurrent = false;
  bool _playing = false;
  bool _finished = false;
  final Set<String> _wrongSelections = {};

  _PracticeQuestion get _question => _questions[_index];

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
  }

  List<_PracticeQuestion> _buildQuestions() {
    final pool = widget.mode == AlphabetPracticeMode.hearAndChooseLetter
        ? _uniqueSoundLetters()
        : List<LetterLesson>.from(alphabetLessons);

    pool.shuffle(_random);
    final selected = pool.take(min(_questionCount, pool.length)).toList();

    return selected.map((target) {
      final distractors = alphabetLessons
          .where((letter) =>
              letter.upper != target.upper &&
              letter.phoneme != target.phoneme)
          .toList()
        ..shuffle(_random);

      final options = <LetterLesson>[
        target,
        ...distractors.take(2),
      ]..shuffle(_random);

      return _PracticeQuestion(target: target, options: options);
    }).toList();
  }

  List<LetterLesson> _uniqueSoundLetters() {
    final bySound = <String, LetterLesson>{};
    for (final letter in alphabetLessons) {
      bySound.putIfAbsent(letter.phoneme, () => letter);
    }
    return bySound.values.toList();
  }

  Future<void> _playSound(LetterLesson letter) async {
    if (_playing) return;
    setState(() => _playing = true);
    try {
      await _audio.playPhonemeUrls(letter.soundAudioUrls);
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

  void _choose(LetterLesson option) {
    if (_answered) return;

    if (option.upper == _question.target.upper) {
      setState(() {
        _answered = true;
        if (!_mistakeOnCurrent) {
          _firstTryScore++;
        }
      });
      return;
    }

    setState(() {
      _mistakeOnCurrent = true;
      _wrongSelections.add(option.upper);
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
      _mistakeOnCurrent = false;
      _wrongSelections.clear();
    });
  }

  void _restart() {
    setState(() {
      _questions = _buildQuestions();
      _index = 0;
      _firstTryScore = 0;
      _answered = false;
      _mistakeOnCurrent = false;
      _wrongSelections.clear();
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

    final listenMode =
        widget.mode == AlphabetPracticeMode.hearAndChooseLetter;

    return Scaffold(
      appBar: AppBar(
        title: Text(listenMode ? 'Услышь звук' : 'Найди звук буквы'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (_index + 1) / _questions.length,
              ),
              const SizedBox(height: 12),
              Text(
                'Задание ${_index + 1} из ${_questions.length}',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),
              if (listenMode) _buildListenPrompt() else _buildLetterPrompt(),
              const SizedBox(height: 26),
              if (listenMode) _buildLetterOptions() else _buildSoundOptions(),
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
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
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
                    : _mistakeOnCurrent
                        ? Container(
                            key: const ValueKey('try-again'),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Почти. Послушай ещё раз и попробуй другой вариант.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
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
    return Column(
      children: [
        const Text(
          'Какой букве соответствует этот звук?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          ),
          onPressed: _playing ? null : () => _playSound(_question.target),
          icon: Icon(_playing ? Icons.hourglass_top : Icons.volume_up_rounded),
          label: Text(
            _playing ? 'Слушаем…' : 'Послушать звук',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildLetterPrompt() {
    final target = _question.target;
    return Column(
      children: [
        const Text(
          'Какой звук чаще всего даёт эта буква?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 18),
        Container(
          width: 150,
          height: 130,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Text(
            '${target.upper}${target.lower}',
            style: const TextStyle(fontSize: 58, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildLetterOptions() {
    return Row(
      children: _question.options.map((option) {
        final wrong = _wrongSelections.contains(option.upper);
        final correct = _answered && option.upper == _question.target.upper;

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
                  padding: const EdgeInsets.symmetric(vertical: 26),
                  child: Text(
                    '${option.upper}${option.lower}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
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
        final wrong = _wrongSelections.contains(option.upper);
        final correct = _answered && option.upper == _question.target.upper;

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
                    tooltip: 'Послушать',
                    onPressed: _playing ? null : () => _playSound(option),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option.phoneme,
                      style: TextStyle(
                        fontSize: 28,
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
    final excellent = _firstTryScore >= 8;

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
                  excellent ? '🌟' : '👏',
                  style: const TextStyle(fontSize: 76),
                ),
                const SizedBox(height: 18),
                Text(
                  excellent ? 'Отличная работа!' : 'Хорошая тренировка!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
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
                  child: const Text('Вернуться к алфавиту'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
