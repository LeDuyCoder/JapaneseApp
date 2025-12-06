class WordEntity {
  final String word;
  final String meaning;
  final String reading;
  final List<String> anotherWord;
  final String tag;
  final bool isBookmarked;

  WordEntity({
    required this.word,
    required this.meaning,
    required this.reading,
    required this.anotherWord,
    required this.tag,
    this.isBookmarked = false,
  });

  @override
  String toString() {
    return "WordEntity(word: $word, meaning: $meaning, isBookmarked: $isBookmarked, anotherWord: $anotherWord, tag: $tag, reading: $reading)";
  }
}
