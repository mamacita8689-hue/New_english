import '../models/lesson.dart';

const shLesson = SoundLesson(
  id: 'sh',
  title: 'Урок 1',
  grapheme: 'SH',
  phoneme: '/ʃ/',
  explanation: 'Буквы S и H вместе часто дают один звук. Послушай примеры и запомни сочетание SH.',
  phonemeAudioAsset: null,
  examples: [
    ExampleWord(word: 'ship', emoji: '🚢'),
    ExampleWord(word: 'fish', emoji: '🐟'),
    ExampleWord(word: 'shop', emoji: '🏪'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какое сочетание букв мы изучаем?',
      options: ['CH', 'SH', 'TH'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'В каком слове есть SH?',
      options: ['cat', 'ship', 'dog'],
      correctIndex: 1,
    ),
  ],
);
