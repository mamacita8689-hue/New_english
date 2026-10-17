import 'package:flutter/material.dart';
import '../models/lesson.dart';

class QuizScreen extends StatefulWidget {
  final SoundLesson lesson;

  const QuizScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;

  QuizQuestion get _question => widget.lesson.quiz[_index];

  void _select(int optionIndex) {
    if (_selected != null) return;
    setState(() {
      _selected = optionIndex;
      if (optionIndex == _question.correctIndex) {
        _score++;
      }
    });
  }

  void _next() {
    if (_index >= widget.lesson.quiz.length - 1) {
      setState(() => _finished = true);
      return;
    }

    setState(() {
      _index++;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) {
      return Scaffold(
        appBar: AppBar(title: const Text('Результат')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 72)),
                const SizedBox(height: 18),
                const Text(
                  'Урок закончен!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  'Правильных ответов: $_score из ${widget.lesson.quiz.length}',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('На главную'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _question;

    return Scaffold(
      appBar: AppBar(title: Text('Задание ${_index + 1}/${widget.lesson.quiz.length}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(value: (_index + 1) / widget.lesson.quiz.length),
              const SizedBox(height: 30),
              Text(
                q.question,
                style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 24),
              ...List.generate(q.options.length, (i) {
                final selected = _selected == i;
                final correct = i == q.correctIndex;
                Color? background;

                if (_selected != null) {
                  if (correct) {
                    background = Colors.green.shade100;
                  } else if (selected) {
                    background = Colors.red.shade100;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: background ?? Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      onTap: () => _select(i),
                      borderRadius: BorderRadius.circular(18),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          q.options[i],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              if (_selected != null)
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                  ),
                  onPressed: _next,
                  child: Text(
                    _index == widget.lesson.quiz.length - 1
                        ? 'Показать результат'
                        : 'Дальше',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
