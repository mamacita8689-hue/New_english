import '../models/lesson.dart';

const shLesson = SoundLesson(
  id: 'sh',
  title: 'Урок 1',
  grapheme: 'SH',
  phoneme: '/ʃ/',
  explanation: 'Буквы S и H вместе часто дают один звук. Послушай примеры и запомни сочетание SH.',
  phonemeAudioUrl: 'https://raw.githubusercontent.com/minormending/learn-letters/main/audio/sh.mp3',
  audioCredit: 'UK phonics-аудионабор — minormending/learn-letters',
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

const chLesson = SoundLesson(
  id: 'ch',
  title: 'Урок 2',
  grapheme: 'CH',
  phoneme: '/tʃ/',
  explanation: 'Буквы C и H вместе часто дают звук /tʃ/. Послушай слова и найди сочетание CH.',
  phonemeAudioUrl: 'https://raw.githubusercontent.com/minormending/learn-letters/main/audio/ch-chair.mp3',
  audioCredit: 'UK phonics-аудионабор — minormending/learn-letters',
  examples: [
    ExampleWord(word: 'chair', emoji: '🪑'),
    ExampleWord(word: 'chicken', emoji: '🐔'),
    ExampleWord(word: 'cheese', emoji: '🧀'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какое сочетание даёт звук /tʃ/?',
      options: ['SH', 'CH', 'TH'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'В каком слове есть CH?',
      options: ['chair', 'ship', 'three'],
      correctIndex: 0,
    ),
  ],
);

const thVoicelessLesson = SoundLesson(
  id: 'th_voiceless',
  title: 'Урок 3',
  grapheme: 'TH',
  phoneme: '/θ/',
  explanation: 'В некоторых словах TH произносится без голоса: /θ/. Кончик языка слегка находится между зубами.',
  phonemeAudioUrl: 'https://raw.githubusercontent.com/minormending/learn-letters/main/audio/th-thing.mp3',
  audioCredit: 'UK phonics-аудионабор — minormending/learn-letters',
  examples: [
    ExampleWord(word: 'three', emoji: '3️⃣'),
    ExampleWord(word: 'think', emoji: '💭'),
    ExampleWord(word: 'bath', emoji: '🛁'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какой звук изучаем в этом уроке?',
      options: ['/ʃ/', '/θ/', '/tʃ/'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'В каком слове TH произносится как /θ/?',
      options: ['three', 'ship', 'chair'],
      correctIndex: 0,
    ),
  ],
);

const thVoicedLesson = SoundLesson(
  id: 'th_voiced',
  title: 'Урок 4',
  grapheme: 'TH',
  phoneme: '/ð/',
  explanation: 'В других словах TH произносится с голосом: /ð/. Положение языка похоже на /θ/, но голосовые связки работают.',
  phonemeAudioUrl: 'https://raw.githubusercontent.com/minormending/learn-letters/main/audio/th-that.mp3',
  audioCredit: 'UK phonics-аудионабор — minormending/learn-letters',
  examples: [
    ExampleWord(word: 'this', emoji: '👉'),
    ExampleWord(word: 'mother', emoji: '👩'),
    ExampleWord(word: 'father', emoji: '👨'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какой звук изучаем в этом уроке?',
      options: ['/ð/', '/θ/', '/ʃ/'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'В каком слове TH произносится как /ð/?',
      options: ['three', 'this', 'chair'],
      correctIndex: 1,
    ),
  ],
);

const soundLessons = [
  shLesson,
  chLesson,
  thVoicelessLesson,
  thVoicedLesson,
];
