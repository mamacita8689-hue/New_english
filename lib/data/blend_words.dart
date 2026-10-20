import '../models/blend_word.dart';

const _spotlight = 'audio/spotlight2_part1';
const _phonics = 'audio/phonics_reference';

// Здесь оставлены только слова, для которых у нас есть проверенное официальное
// произношение Spotlight и однозначная картинка. Звуки букв берём из тех же
// проверенных Spotlight-фрагментов; SH — из отдельной чистой phonics-записи.
const blendWords = <BlendWord>[
  BlendWord(
    word: 'cat',
    emoji: '🐱',
    chunks: ['c', 'a', 't'],
    phonemeAudioUrls: [
      '$_spotlight/phoneme_c.mp3',
      '$_spotlight/phoneme_a.mp3',
      '$_spotlight/phoneme_t.mp3',
    ],
  ),
  BlendWord(
    word: 'dog',
    emoji: '🐶',
    chunks: ['d', 'o', 'g'],
    phonemeAudioUrls: [
      '$_spotlight/phoneme_d.mp3',
      '$_spotlight/phoneme_o.mp3',
      '$_spotlight/phoneme_g.mp3',
    ],
  ),
  BlendWord(
    word: 'bed',
    emoji: '🛏️',
    chunks: ['b', 'e', 'd'],
    phonemeAudioUrls: [
      '$_spotlight/phoneme_b.mp3',
      '$_spotlight/phoneme_e.mp3',
      '$_spotlight/phoneme_d.mp3',
    ],
  ),
  BlendWord(
    word: 'pin',
    emoji: '📌',
    chunks: ['p', 'i', 'n'],
    phonemeAudioUrls: [
      '$_spotlight/phoneme_p.mp3',
      '$_spotlight/phoneme_i.mp3',
      '$_spotlight/phoneme_n.mp3',
    ],
  ),
  BlendWord(
    word: 'nest',
    emoji: '🪺',
    chunks: ['n', 'e', 's', 't'],
    phonemeAudioUrls: [
      '$_spotlight/phoneme_n.mp3',
      '$_spotlight/phoneme_e.mp3',
      '$_spotlight/phoneme_s.mp3',
      '$_spotlight/phoneme_t.mp3',
    ],
  ),
  BlendWord(
    word: 'zip',
    emoji: '🤐',
    chunks: ['z', 'i', 'p'],
    phonemeAudioUrls: [
      '$_spotlight/phoneme_z.mp3',
      '$_spotlight/phoneme_i.mp3',
      '$_spotlight/phoneme_p.mp3',
    ],
  ),
  BlendWord(
    word: 'fish',
    emoji: '🐟',
    chunks: ['f', 'i', 'sh'],
    phonemeAudioUrls: [
      '$_spotlight/phoneme_f.mp3',
      '$_spotlight/phoneme_i.mp3',
      '$_phonics/phoneme_sh.mp3',
    ],
  ),
  BlendWord(
    word: 'ship',
    emoji: '🚢',
    chunks: ['sh', 'i', 'p'],
    phonemeAudioUrls: [
      '$_phonics/phoneme_sh.mp3',
      '$_spotlight/phoneme_i.mp3',
      '$_spotlight/phoneme_p.mp3',
    ],
  ),
];
