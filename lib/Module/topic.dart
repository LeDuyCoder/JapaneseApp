class topic{
  String? owner;
  int? count;
  final String id, name;
  topic({required this.id, required this.name, this.owner, this.count});

  factory topic.fromJson(Map<String, dynamic> json) {
    topic newTopic = topic(
      id: json['id'],
      name: json['nameTopic'],
      owner: json['owner'],
      count: (json['word_count'] is int)
          ? json['word_count'] as int
          : int.tryParse(json['word_count']?.toString() ?? '0') ?? 0,
    );

    return newTopic;

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameTopic': name,
      'owner': owner,
      'word_counts': "$count"
    };
  }
}