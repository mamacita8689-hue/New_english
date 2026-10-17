class LetterLesson {
  final String upper;
  final String lower;
  final String phoneme;
  final String example;
  final String emoji;
  final List<String> soundAudioUrls;
  final String note;

  const LetterLesson({
    required this.upper,
    required this.lower,
    required this.phoneme,
    required this.example,
    required this.emoji,
    required this.soundAudioUrls,
    this.note = '',
  });
}
