import 'package:flutter/material.dart';
import '../data/lessons.dart';
import 'lesson_screen.dart';

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
            _LessonCard(
              title: 'SH',
              subtitle: 'Звук ${shLesson.phoneme}',
              emoji: '🚢',
              enabled: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LessonScreen(lesson: shLesson),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            const _LessonCard(
              title: 'CH',
              subtitle: 'Следующий урок',
              emoji: '🪑',
              enabled: false,
            ),
            const SizedBox(height: 12),
            const _LessonCard(
              title: 'TH',
              subtitle: 'Скоро',
              emoji: '3️⃣',
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final bool enabled;
  final VoidCallback? onTap;

  const _LessonCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: enabled ? onTap : null,
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
                  color: enabled
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.grey.shade200,
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
                      title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              Icon(
                enabled ? Icons.arrow_forward_ios_rounded : Icons.lock_outline,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
