import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopicModule extends Equatable {
  String? owner;
  int? count;
  final String id, name;

  TopicModule({required this.id, required this.name, this.owner, this.count});

  @override
  List<Object?> get props => [id, name, owner, count];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner': owner,
      'count': count,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': FirebaseAuth.instance.currentUser!.uid,
      'nameTopic': name,
      'word_counts': "$count"
    };
  }

  factory TopicModule.fromJson(Map<String, dynamic> json) {
    return TopicModule(
      id: json['topic_id'] ?? json['id'],
      name: json['nameTopic'] ?? json["name"],
      owner: json['user_name'] ?? json["owner"],
      count: json['word_count'] ?? json["count"],
    );
  }


}