import '../models/blend_word.dart';

const _audio = 'audio';

const blendWords = <BlendWord>[
  BlendWord(
    word: 'cat',
    emoji: '🐱',
    chunks: ['c', 'a', 't'],
    phonemeAudioUrls: ['$_audio/phoneme_c.mp3', '$_audio/phoneme_a.mp3', '$_audio/phoneme_t.mp3'],
  ),
  BlendWord(
    word: 'pen',
    emoji: '🖊️',
    chunks: ['p', 'e', 'n'],
    phonemeAudioUrls: ['$_audio/phoneme_p.mp3', '$_audio/phoneme_e.mp3', '$_audio/phoneme_n.mp3'],
  ),
  BlendWord(
    word: 'pig',
    emoji: '🐷',
    chunks: ['p', 'i', 'g'],
    phonemeAudioUrls: ['$_audio/phoneme_p.mp3', '$_audio/phoneme_i.mp3', '$_audio/phoneme_g.mp3'],
  ),
  BlendWord(
    word: 'dog',
    emoji: '🐶',
    chunks: ['d', 'o', 'g'],
    phonemeAudioUrls: ['$_audio/phoneme_d.mp3', '$_audio/phoneme_o.mp3', '$_audio/phoneme_g.mp3'],
  ),
  BlendWord(
    word: 'sun',
    emoji: '☀️',
    chunks: ['s', 'u', 'n'],
    phonemeAudioUrls: ['$_audio/phoneme_s.mp3', '$_audio/phoneme_u.mp3', '$_audio/phoneme_n.mp3'],
  ),
  BlendWord(
    word: 'fish',
    emoji: '🐟',
    chunks: ['f', 'i', 'sh'],
    phonemeAudioUrls: ['$_audio/phoneme_f.mp3', '$_audio/phoneme_i.mp3', '$_audio/phoneme_sh.mp3'],
  ),
  BlendWord(
    word: 'ship',
    emoji: '🚢',
    chunks: ['sh', 'i', 'p'],
    phonemeAudioUrls: ['$_audio/phoneme_sh.mp3', '$_audio/phoneme_i.mp3', '$_audio/phoneme_p.mp3'],
  ),
  BlendWord(
    word: 'ring',
    emoji: '💍',
    chunks: ['r', 'i', 'ng'],
    phonemeAudioUrls: ['$_audio/phoneme_r.mp3', '$_audio/phoneme_i.mp3', '$_audio/phoneme_ng.mp3'],
  ),
];
