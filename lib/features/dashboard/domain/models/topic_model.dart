import 'package:equatable/equatable.dart';

class TopicEntity extends Equatable {
  String? owner;
  int? count;
  final String id, name;

  TopicEntity({required this.id, required this.name, this.owner, this.count});

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

  factory TopicEntity.fromJson(Map<String, dynamic> json) {
    return TopicEntity(
      id: json['id'],
      name: json['name'] ?? json['nameTopic'],
      owner: json['owner'],
      count: json['count'] ?? json['word_count'],
    );
  }

}