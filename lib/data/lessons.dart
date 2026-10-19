import '../models/lesson.dart';

const _audio = 'audio';
const _spotlightAudio = 'audio/spotlight2_part1';
const _audioCredit = 'Spotlight 2, часть 1 — официальное аудиоприложение «Просвещение»';
const _fallbackCredit = 'UK phonics-аудионабор — minormending/learn-letters';

const shLesson = SoundLesson(
  id: 'sh',
  title: 'Letter Blends • стр. 12',
  grapheme: 'SH',
  phoneme: '/ʃ/',
  explanation:
      'В Spotlight 2 сочетание SH учим по словам sheep, fish и ship. Послушай официальный образец и повтори.',
  phonemeAudioUrl: '$_spotlightAudio/phoneme_sh.mp3',
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
      'В Spotlight 2 сочетание CH закрепляется словами chick и cheese. Слушай официальный образец и повторяй.',
  phonemeAudioUrl: '$_spotlightAudio/phoneme_ch.mp3',
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
      'В словах thumb и thimble сочетание TH произносится без голоса: /θ/. Кончик языка слегка между зубами.',
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
      'В словах the и this сочетание TH произносится с голосом: /ð/. Положение языка такое же, но голосовые связки работают.',
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
      'В Spotlight 2 сочетание PH встречается в словах photo, dolphin и elephant и звучит как /f/.',
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

const ngLesson = SoundLesson(
  id: 'ng',
  title: 'Дополнительный урок',
  grapheme: 'NG',
  phoneme: '/ŋ/',
  explanation:
      'Сочетание NG часто даёт носовой звук /ŋ/. Язык не касается передних зубов — звук получается глубже.',
  phonemeAudioUrl: '$_audio/phoneme_ng.mp3',
  audioCredit: _fallbackCredit,
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
  title: 'Дополнительный урок',
  grapheme: 'EE',
  phoneme: '/iː/',
  explanation:
      'Две буквы E вместе часто дают долгий звук /iː/. Улыбнись немного и протяни звук.',
  phonemeAudioUrl: '$_audio/phoneme_ee.mp3',
  audioCredit: _fallbackCredit,
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
  title: 'Дополнительный урок',
  grapheme: 'OO',
  phoneme: '/uː/',
  explanation:
      'В словах вроде moon сочетание OO даёт долгий звук /uː/. Этот звук можно немного протянуть.',
  phonemeAudioUrl: '$_audio/phoneme_oo_moon.mp3',
  audioCredit: _fallbackCredit,
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
  title: 'Дополнительный урок',
  grapheme: 'OO',
  phoneme: '/ʊ/',
  explanation:
      'Но OO бывает и коротким: в слове book оно звучит /ʊ/. Это отдельный вариант, его важно слышать.',
  phonemeAudioUrl: '$_audio/phoneme_oo_book.mp3',
  audioCredit: _fallbackCredit,
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
  title: 'Дополнительный урок',
  grapheme: 'AI',
  phoneme: '/eɪ/',
  explanation:
      'Сочетание AI часто даёт звук /eɪ/, как в слове rain. Услышь плавный переход внутри звука.',
  phonemeAudioUrl: '$_audio/phoneme_ai.mp3',
  audioCredit: _fallbackCredit,
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
  title: 'Дополнительный урок',
  grapheme: 'OA',
  phoneme: '/əʊ/',
  explanation:
      'Сочетание OA часто даёт британский звук /əʊ/, как в слове boat.',
  phonemeAudioUrl: '$_audio/phoneme_oa.mp3',
  audioCredit: _fallbackCredit,
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
  phLesson,
  ngLesson,
  eeLesson,
  ooLongLesson,
  ooShortLesson,
  aiLesson,
  oaLesson,
];
