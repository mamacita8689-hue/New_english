import 'package:flutter/material.dart';
import '../data/lessons.dart';
import '../models/lesson.dart';
import 'alphabet_screen.dart';
import 'blending_screen.dart';
import 'lesson_screen.dart';
import 'sound_practice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Английский • 2 класс'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Учимся читать по звукам',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Буквы → звуки → сочетания → простые слова',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AlphabetScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text('Aa', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Алфавит и звуки', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
                            SizedBox(height: 3),
                            Text('A–Z • название буквы • основной звук', style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BlendingScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text('c-a-t', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Складываем слова', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
                            SizedBox(height: 3),
                            Text('Слушаем звуки → соединяем → читаем слово', style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Сочетания букв',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '🎯 Тренировка сочетаний',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Spotlight 2, стр. 12–15: SH, CH, TH, PH',
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SoundPracticeScreen(
                              mode: SoundPracticeMode.hearAndChooseGrapheme,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.hearing_rounded),
                      label: const Text('Послушай слово → выбери сочетание'),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SoundPracticeScreen(
                              mode: SoundPracticeMode.seeAndChooseSound,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.volume_up_rounded),
                      label: const Text('Увидь сочетание → выбери звук'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...soundLessons.asMap().entries.map((entry) {
              final index = entry.key;
              final lesson = entry.value;
              final emoji = switch (lesson.id) {
                'sh' => '🐑',
                'ch' => '🐥',
                'th_voiceless' => '👍',
                'th_voiced' => '👉',
                'ph' => '📷',
                _ => '🔤',
              };

              return Padding(
                padding: EdgeInsets.only(bottom: index == soundLessons.length - 1 ? 0 : 12),
                child: _LessonCard(
                  lesson: lesson,
                  emoji: emoji,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LessonScreen(lesson: lesson),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final SoundLesson lesson;
  final String emoji;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 34)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.grapheme,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '${lesson.title} • ${lesson.phoneme}',
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
