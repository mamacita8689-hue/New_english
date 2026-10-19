import '../models/letter_lesson.dart';

const _audio = 'audio';

const alphabetLessons = <LetterLesson>[
  LetterLesson(upper: 'A', lower: 'a', phoneme: '/æ/', example: 'apple', emoji: '🍎', soundAudioUrls: ['$_audio/phoneme_a.mp3']),
  LetterLesson(upper: 'B', lower: 'b', phoneme: '/b/', example: 'bag', emoji: '🎒', soundAudioUrls: ['$_audio/phoneme_b.mp3']),
  LetterLesson(upper: 'C', lower: 'c', phoneme: '/k/', example: 'cat', emoji: '🐱', soundAudioUrls: ['$_audio/phoneme_c.mp3'], note: 'В некоторых словах C может звучать иначе. Пока учим самый частый начальный звук /k/.'),
  LetterLesson(upper: 'D', lower: 'd', phoneme: '/d/', example: 'dog', emoji: '🐶', soundAudioUrls: ['$_audio/phoneme_d.mp3']),
  LetterLesson(upper: 'E', lower: 'e', phoneme: '/e/', example: 'egg', emoji: '🥚', soundAudioUrls: ['$_audio/phoneme_e.mp3']),
  LetterLesson(upper: 'F', lower: 'f', phoneme: '/f/', example: 'fish', emoji: '🐟', soundAudioUrls: ['$_audio/phoneme_f.mp3']),
  LetterLesson(upper: 'G', lower: 'g', phoneme: '/g/', example: 'go', emoji: '🚦', soundAudioUrls: ['$_audio/phoneme_g.mp3'], note: 'Позже встретим и мягкое звучание G.'),
  LetterLesson(upper: 'H', lower: 'h', phoneme: '/h/', example: 'hat', emoji: '🎩', soundAudioUrls: ['$_audio/phoneme_h.mp3']),
  LetterLesson(upper: 'I', lower: 'i', phoneme: '/ɪ/', example: 'in', emoji: '📥', soundAudioUrls: ['$_audio/phoneme_i.mp3']),
  LetterLesson(upper: 'J', lower: 'j', phoneme: '/dʒ/', example: 'jam', emoji: '🍓', soundAudioUrls: ['$_audio/phoneme_j.mp3']),
  LetterLesson(upper: 'K', lower: 'k', phoneme: '/k/', example: 'kid', emoji: '🧒', soundAudioUrls: ['$_audio/phoneme_c.mp3']),
  LetterLesson(upper: 'L', lower: 'l', phoneme: '/l/', example: 'leg', emoji: '🦵', soundAudioUrls: ['$_audio/phoneme_l.mp3']),
  LetterLesson(upper: 'M', lower: 'm', phoneme: '/m/', example: 'mum', emoji: '👩', soundAudioUrls: ['$_audio/phoneme_m.mp3']),
  LetterLesson(upper: 'N', lower: 'n', phoneme: '/n/', example: 'net', emoji: '🥅', soundAudioUrls: ['$_audio/phoneme_n.mp3']),
  LetterLesson(upper: 'O', lower: 'o', phoneme: '/ɒ/', example: 'on', emoji: '🔛', soundAudioUrls: ['$_audio/phoneme_o.mp3']),
  LetterLesson(upper: 'P', lower: 'p', phoneme: '/p/', example: 'pen', emoji: '🖊️', soundAudioUrls: ['$_audio/phoneme_p.mp3']),
  LetterLesson(upper: 'Q', lower: 'q', phoneme: '/kw/', example: 'queen', emoji: '👑', soundAudioUrls: ['$_audio/phoneme_c.mp3', '$_audio/phoneme_w.mp3'], note: 'Q почти всегда встречается вместе с U: qu → /kw/.'),
  LetterLesson(upper: 'R', lower: 'r', phoneme: '/r/', example: 'red', emoji: '🔴', soundAudioUrls: ['$_audio/phoneme_r.mp3']),
  LetterLesson(upper: 'S', lower: 's', phoneme: '/s/', example: 'sun', emoji: '☀️', soundAudioUrls: ['$_audio/phoneme_s.mp3']),
  LetterLesson(upper: 'T', lower: 't', phoneme: '/t/', example: 'ten', emoji: '🔟', soundAudioUrls: ['$_audio/phoneme_t.mp3']),
  LetterLesson(upper: 'U', lower: 'u', phoneme: '/ʌ/', example: 'up', emoji: '⬆️', soundAudioUrls: ['$_audio/phoneme_u.mp3']),
  LetterLesson(upper: 'V', lower: 'v', phoneme: '/v/', example: 'van', emoji: '🚐', soundAudioUrls: ['$_audio/phoneme_v.mp3']),
  LetterLesson(upper: 'W', lower: 'w', phoneme: '/w/', example: 'web', emoji: '🕸️', soundAudioUrls: ['$_audio/phoneme_w.mp3']),
  LetterLesson(upper: 'X', lower: 'x', phoneme: '/ks/', example: 'box', emoji: '📦', soundAudioUrls: ['$_audio/phoneme_c.mp3', '$_audio/phoneme_s.mp3'], note: 'X обычно передаёт два звука подряд: /k/ + /s/.'),
  LetterLesson(upper: 'Y', lower: 'y', phoneme: '/j/', example: 'yes', emoji: '✅', soundAudioUrls: ['$_audio/phoneme_y.mp3']),
  LetterLesson(upper: 'Z', lower: 'z', phoneme: '/z/', example: 'zoo', emoji: '🦓', soundAudioUrls: ['$_audio/phoneme_z.mp3']),
];
