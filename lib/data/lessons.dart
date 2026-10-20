import '../models/lesson.dart';

const _phonicsAudio = 'audio/phonics_reference';
const _audioCredit =
    'Фонема — чистая UK phonics-запись; слова — официальное аудиоприложение Spotlight 2, часть 1 («Просвещение»)';

const shLesson = SoundLesson(
  id: 'sh',
  title: 'Letter Blends • стр. 12',
  grapheme: 'SH',
  phoneme: '/ʃ/',
  explanation:
      'SH читается как /ʃ/. Сначала послушай сам звук, затем слова Spotlight 2: sheep, fish и ship.',
  phonemeAudioAsset: '$_phonicsAudio/phoneme_sh.mp3',
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
      'CH читается как /tʃ/. Сначала послушай сам звук, затем слова Spotlight 2: chick и cheese.',
  phonemeAudioAsset: '$_phonicsAudio/phoneme_ch.mp3',
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
      'В словах thumb и thimble сочетание TH произносится без голоса: /θ/. Сначала послушай сам звук.',
  phonemeAudioAsset: '$_phonicsAudio/phoneme_th_thing.mp3',
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
      'В словах the и this сочетание TH произносится с голосом: /ð/. Сначала послушай сам звук.',
  phonemeAudioAsset: '$_phonicsAudio/phoneme_th_that.mp3',
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
      'PH читается как /f/. Сначала послушай сам звук, затем слова Spotlight 2: photo, dolphin и elephant.',
  phonemeAudioAsset: '$_phonicsAudio/phoneme_f.mp3',
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

const soundLessons = [
  shLesson,
  chLesson,
  thVoicelessLesson,
  thVoicedLesson,
  phLesson,
];
