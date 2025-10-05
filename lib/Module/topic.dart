import 'package:firebase_auth/firebase_auth.dart';

class topic{
  String? owner;
  int? count;
  final String id, name;
  topic({required this.id, required this.name, this.owner, this.count});

  factory topic.fromJson(Map<String, dynamic> json) {
    print(json);
    topic newTopic = topic(
      id: json['topic_id'] ?? json['id'],
      name: json['nameTopic'],
      owner: json['user_name'],
      count: (json['word_count'] is int)
          ? json['word_count'] as int
          : int.tryParse(json['word_count']?.toString() ?? '0') ?? 0,
    );

    return newTopic;

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,                // ID của topic
      'user_id': FirebaseAuth.instance.currentUser!.uid,        // Gửi owner sang server bằng tên user_id
      'nameTopic': name,
      'word_counts': "$count"
    };
  }

  @override
  String toString() {
    return 'Topic{id: $id, name: $name, owner: $owner, count: $count}';
  }


}