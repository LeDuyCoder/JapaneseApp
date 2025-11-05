class Word {
  final String word;
  final String mean;
  final String wayread;
  final int level;
  final String topicID;

  Word({
    required this.word,
    required this.mean,
    required this.wayread,
    required this.level,
    required this.topicID,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      mean: json['mean'],
      wayread: json['wayread'],
      level: int.tryParse(json['level'].toString()) ?? 0,
      topicID: json['topicID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'mean': mean,
      'wayread': wayread,
      'level': level,
      'topicID': topicID,
    };
  }
}
