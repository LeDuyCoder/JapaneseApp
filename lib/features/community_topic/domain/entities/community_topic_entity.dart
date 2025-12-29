import 'package:equatable/equatable.dart';

class CommunityTopicEntity extends Equatable {
  final String topicId;
  final String userId;
  final String userName;
  final String nameTopic;
  final int wordCount;
  final bool isExist;

  const CommunityTopicEntity({required this.topicId, required this.userId, required this.userName, required this.nameTopic, required this.wordCount, required this.isExist});

  @override
  List<Object?> get props => [topicId, userId, userName, nameTopic, wordCount];

  factory CommunityTopicEntity.fromJson(Map<String, dynamic> json) {
    return CommunityTopicEntity(
      topicId: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      nameTopic: json['nameTopic'],
      wordCount: json['word_count'],
      isExist: json["exist"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': topicId,
      'user_id': userId,
      'user_name': userName,
      'nameTopic': nameTopic,
      'word_count': wordCount,
    };
  }
}