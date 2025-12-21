class WordEntity {
  final String word;
  final String mean;
  final String wayread;
  final String topic;
  final int level;

  WordEntity({
    required this.word,
    required this.mean,
    required this.wayread,
    required this.topic,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      "word": word,
      "mean": mean,
      "wayread": wayread,
      "topic": topic,
      "level": level
    };
  }

  factory WordEntity.fromJson(Map<String, dynamic> json) {
    return WordEntity(
      word: json['word'],
      mean: json['mean'],
      wayread: json['wayread'],
      topic: json['topic'],
      level: json['level'],
    );
  }
}