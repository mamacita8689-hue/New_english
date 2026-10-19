import '../models/blend_word.dart';

const _base = 'https://raw.githubusercontent.com/minormending/learn-letters/main/audio';

const blendWords = <BlendWord>[
  BlendWord(
    word: 'cat',
    emoji: '🐱',
    chunks: ['c', 'a', 't'],
    phonemeAudioUrls: ['$_base/c.mp3', '$_base/a.mp3', '$_base/t.mp3'],
  ),
  BlendWord(
    word: 'pen',
    emoji: '🖊️',
    chunks: ['p', 'e', 'n'],
    phonemeAudioUrls: ['$_base/p.mp3', '$_base/e.mp3', '$_base/n.mp3'],
  ),
  BlendWord(
    word: 'pig',
    emoji: '🐷',
    chunks: ['p', 'i', 'g'],
    phonemeAudioUrls: ['$_base/p.mp3', '$_base/i.mp3', '$_base/g.mp3'],
  ),
  BlendWord(
    word: 'dog',
    emoji: '🐶',
    chunks: ['d', 'o', 'g'],
    phonemeAudioUrls: ['$_base/d.mp3', '$_base/o.mp3', '$_base/g.mp3'],
  ),
  BlendWord(
    word: 'sun',
    emoji: '☀️',
    chunks: ['s', 'u', 'n'],
    phonemeAudioUrls: ['$_base/s.mp3', '$_base/u.mp3', '$_base/n.mp3'],
  ),
  BlendWord(
    word: 'fish',
    emoji: '🐟',
    chunks: ['f', 'i', 'sh'],
    phonemeAudioUrls: ['$_base/f.mp3', '$_base/i.mp3', '$_base/sh.mp3'],
  ),
  BlendWord(
    word: 'ship',
    emoji: '🚢',
    chunks: ['sh', 'i', 'p'],
    phonemeAudioUrls: ['$_base/sh.mp3', '$_base/i.mp3', '$_base/p.mp3'],
  ),
  BlendWord(
    word: 'ring',
    emoji: '💍',
    chunks: ['r', 'i', 'ng'],
    phonemeAudioUrls: ['$_base/r.mp3', '$_base/i.mp3', '$_base/ng.mp3'],
  ),
];
