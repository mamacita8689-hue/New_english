import '../models/lesson.dart';

const _audio = 'audio';
const _audioCredit = 'UK phonics-аудионабор — minormending/learn-letters';

const shLesson = SoundLesson(
  id: 'sh',
  title: 'Урок 1',
  grapheme: 'SH',
  phoneme: '/ʃ/',
  explanation:
      'Буквы S и H вместе часто дают один звук. Послушай примеры и запомни сочетание SH.',
  phonemeAudioUrl: '$_audio/phoneme_sh.mp3',
  audioCredit: _audioCredit,
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
  explanation:
      'Буквы C и H вместе часто дают звук /tʃ/. Послушай слова и найди сочетание CH.',
  phonemeAudioUrl: '$_audio/phoneme_ch.mp3',
  audioCredit: _audioCredit,
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
  explanation:
      'В некоторых словах TH произносится без голоса: /θ/. Кончик языка слегка находится между зубами.',
  phonemeAudioUrl: '$_audio/phoneme_th_thing.mp3',
  audioCredit: _audioCredit,
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
  explanation:
      'В других словах TH произносится с голосом: /ð/. Положение языка похоже на /θ/, но голосовые связки работают.',
  phonemeAudioUrl: '$_audio/phoneme_th_that.mp3',
  audioCredit: _audioCredit,
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

const ngLesson = SoundLesson(
  id: 'ng',
  title: 'Урок 5',
  grapheme: 'NG',
  phoneme: '/ŋ/',
  explanation:
      'Сочетание NG часто даёт носовой звук /ŋ/. Язык не касается передних зубов — звук получается глубже.',
  phonemeAudioUrl: '$_audio/phoneme_ng.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'sing', emoji: '🎵'),
    ExampleWord(word: 'ring', emoji: '💍'),
    ExampleWord(word: 'king', emoji: '👑'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какое сочетание часто даёт звук /ŋ/?',
      options: ['NG', 'SH', 'EE'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'В каком слове есть NG?',
      options: ['boat', 'sing', 'rain'],
      correctIndex: 1,
    ),
  ],
);

const eeLesson = SoundLesson(
  id: 'ee',
  title: 'Урок 6',
  grapheme: 'EE',
  phoneme: '/iː/',
  explanation:
      'Две буквы E вместе часто дают долгий звук /iː/. Улыбнись немного и протяни звук.',
  phonemeAudioUrl: '$_audio/phoneme_ee.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'see', emoji: '👀'),
    ExampleWord(word: 'green', emoji: '🟢'),
    ExampleWord(word: 'feet', emoji: '🦶'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какой звук часто даёт EE?',
      options: ['/iː/', '/eɪ/', '/ʊ/'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'В каком слове есть EE?',
      options: ['green', 'boat', 'book'],
      correctIndex: 0,
    ),
  ],
);

const ooLongLesson = SoundLesson(
  id: 'oo_long',
  title: 'Урок 7',
  grapheme: 'OO',
  phoneme: '/uː/',
  explanation:
      'В словах вроде moon сочетание OO даёт долгий звук /uː/. Этот звук можно немного протянуть.',
  phonemeAudioUrl: '$_audio/phoneme_oo_moon.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'moon', emoji: '🌙'),
    ExampleWord(word: 'food', emoji: '🍲'),
    ExampleWord(word: 'room', emoji: '🚪'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Как звучит OO в слове moon?',
      options: ['/uː/', '/ʊ/', '/əʊ/'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'Где OO звучит как в moon?',
      options: ['food', 'book', 'rain'],
      correctIndex: 0,
    ),
  ],
);

const ooShortLesson = SoundLesson(
  id: 'oo_short',
  title: 'Урок 8',
  grapheme: 'OO',
  phoneme: '/ʊ/',
  explanation:
      'Но OO бывает и коротким: в слове book оно звучит /ʊ/. Это отдельный вариант, его важно слышать.',
  phonemeAudioUrl: '$_audio/phoneme_oo_book.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'book', emoji: '📖'),
    ExampleWord(word: 'look', emoji: '👀'),
    ExampleWord(word: 'foot', emoji: '🦶'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Как звучит OO в слове book?',
      options: ['/ʊ/', '/uː/', '/iː/'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'Где OO звучит как в book?',
      options: ['moon', 'look', 'boat'],
      correctIndex: 1,
    ),
  ],
);

const aiLesson = SoundLesson(
  id: 'ai',
  title: 'Урок 9',
  grapheme: 'AI',
  phoneme: '/eɪ/',
  explanation:
      'Сочетание AI часто даёт звук /eɪ/, как в слове rain. Услышь плавный переход внутри звука.',
  phonemeAudioUrl: '$_audio/phoneme_ai.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'rain', emoji: '🌧️'),
    ExampleWord(word: 'train', emoji: '🚆'),
    ExampleWord(word: 'tail', emoji: '🐕'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какой звук часто даёт AI?',
      options: ['/eɪ/', '/iː/', '/əʊ/'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'В каком слове есть AI?',
      options: ['rain', 'green', 'moon'],
      correctIndex: 0,
    ),
  ],
);

const oaLesson = SoundLesson(
  id: 'oa',
  title: 'Урок 10',
  grapheme: 'OA',
  phoneme: '/əʊ/',
  explanation:
      'Сочетание OA часто даёт британский звук /əʊ/, как в слове boat.',
  phonemeAudioUrl: '$_audio/phoneme_oa.mp3',
  audioCredit: _audioCredit,
  examples: [
    ExampleWord(word: 'boat', emoji: '⛵'),
    ExampleWord(word: 'coat', emoji: '🧥'),
    ExampleWord(word: 'road', emoji: '🛣️'),
  ],
  quiz: [
    QuizQuestion(
      question: 'Какой звук часто даёт OA?',
      options: ['/əʊ/', '/eɪ/', '/ŋ/'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: 'В каком слове есть OA?',
      options: ['book', 'boat', 'green'],
      correctIndex: 1,
    ),
  ],
);

const soundLessons = [
  shLesson,
  chLesson,
  thVoicelessLesson,
  thVoicedLesson,
  ngLesson,
  eeLesson,
  ooLongLesson,
  ooShortLesson,
  aiLesson,
  oaLesson,
];
