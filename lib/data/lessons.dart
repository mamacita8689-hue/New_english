import '../models/lesson.dart';

const _spotlightAudio = 'audio/spotlight2_part1';
const _audioCredit =
    'Spotlight 2, часть 1 — официальное аудиоприложение «Просвещение»';

// ВАЖНО: в официальных дорожках 10–13 нет чистых изолированных записей
// SH/CH/PH. Там звучит инструкция "Listen and repeat", затем слова из
// учебника. Поэтому кнопка в уроке воспроизводит проверенное СЛОВО-ОБРАЗЕЦ,
// а не пытается вырезать фонему из инструкции.

const shLesson = SoundLesson(
  id: 'sh',
  title: 'Letter Blends • стр. 12',
  grapheme: 'SH',
  phoneme: '/ʃ/',
  explanation:
      'SH читается как /ʃ/. В официальной записи Spotlight 2 слушаем слова sheep, fish и ship. Образец для кнопки — слово sheep.',
  phonemeAudioUrl: '$_spotlightAudio/word_sheep.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'sheep', emoji: '🐑'),
    ExampleWord(word: 'fish', emoji: '🐟'),
    ExampleWord(word: 'ship', emoji: '🚢'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какое сочетание даёт звук /ʃ/?',
      options: ['CH', 'SH', 'TH'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Какое слово есть в упражнении Spotlight на SH?',
      options: ['sheep', 'chick', 'thumb'],
      correctIndex: 0,
    ),
  ],
);

const chLesson = SoundLesson(
  id: 'ch',
  title: 'Letter Blends • стр. 13',
  grapheme: 'CH',
  phoneme: '/tʃ/',
  explanation:
      'CH читается как /tʃ/. В официальной записи Spotlight 2 слушаем chick и cheese. Образец для кнопки — слово chick.',
  phonemeAudioUrl: '$_spotlightAudio/word_chick.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'chick', emoji: '🐥'),
    ExampleWord(word: 'cheese', emoji: '🧀'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какое сочетание даёт звук /tʃ/?',
      options: ['SH', 'CH', 'TH'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Какое слово есть в упражнении Spotlight на CH?',
      options: ['ship', 'chick', 'thumb'],
      correctIndex: 1,
    ),
  ],
);

const thVoicelessLesson = SoundLesson(
  id: 'th_voiceless',
  title: 'Letter Blends • стр. 14',
  grapheme: 'TH',
  phoneme: '/θ/',
  explanation:
      'В словах thumb и thimble сочетание TH произносится без голоса: /θ/. Образец для кнопки — слово thumb.',
  phonemeAudioUrl: '$_spotlightAudio/word_thumb.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'thumb', emoji: '👍'),
    ExampleWord(word: 'thimble', emoji: '🧵'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какой звук TH слышен в слове thumb?',
      options: ['/ʃ/', '/θ/', '/tʃ/'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Какое слово есть в Spotlight на глухой TH?',
      options: ['thumb', 'cheese', 'ship'],
      correctIndex: 0,
    ),
  ],
);

const thVoicedLesson = SoundLesson(
  id: 'th_voiced',
  title: 'Letter Blends • стр. 14',
  grapheme: 'TH',
  phoneme: '/ð/',
  explanation:
      'В словах the и this сочетание TH произносится с голосом: /ð/. Образец для кнопки — слово this.',
  phonemeAudioUrl: '$_spotlightAudio/word_this.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'the', emoji: '🔤'),
    ExampleWord(word: 'this', emoji: '👉'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какой звук TH слышен в слове this?',
      options: ['/ð/', '/θ/', '/ʃ/'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'Какое слово из Spotlight содержит звонкий TH?',
      options: ['thumb', 'this', 'fish'],
      correctIndex: 1,
    ),
  ],
);

const phLesson = SoundLesson(
  id: 'ph',
  title: 'Letter Blends • стр. 15',
  grapheme: 'PH',
  phoneme: '/f/',
  explanation:
      'PH читается как /f/. В официальной записи Spotlight 2 слушаем photo, dolphin и elephant. Образец для кнопки — слово photo.',
  phonemeAudioUrl: '$_spotlightAudio/word_photo.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'photo', emoji: '📷'),
    ExampleWord(word: 'dolphin', emoji: '🐬'),
    ExampleWord(word: 'elephant', emoji: '🐘'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Как звучит PH в слове photo?',
      options: ['/f/', '/p/', '/h/'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'В каком слове есть PH?',
      options: ['dolphin', 'ship', 'chick'],
      correctIndex: 0,
    ),
  ],
);

// В основном курсе оставляем только то, что действительно есть в Spotlight 2
// на страницах 12–15 и проверено по официальным дорожкам 10–13.
const soundLessons = [
  shLesson,
  chLesson,
  thVoicelessLesson,
  thVoicedLesson,
  phLesson,
];
