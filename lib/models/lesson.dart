class ExampleWord {
  final String word;
  final String emoji;

  const ExampleWord({
    required this.word,
    required this.emoji,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class SoundLesson {
  final String id;
  final String title;
  final String grapheme;
  final String phoneme;
  final String explanation;
  final String? phonemeAudioAsset;
  final List<ExampleWord> examples;
  final List<QuizQuestion> quiz;

  const SoundLesson({
    required this.id,
    required this.title,
    required this.grapheme,
    required this.phoneme,
    required this.explanation,
    required this.examples,
    required this.quiz,
    this.phonemeAudioAsset,
  });
}
