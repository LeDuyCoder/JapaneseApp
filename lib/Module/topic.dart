class topic{
  String? owner;
  int? count;
  final String id, name;
  topic({required this.id, required this.name, this.owner, this.count});

  factory topic.fromJson(Map<String, dynamic> json) {
    return topic(
      id: json['id'],
      name: json['nameTopic'], // ⚠️ API trả về nameTopic
      owner: json['owner'],
      count: json['word_count']
    );
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