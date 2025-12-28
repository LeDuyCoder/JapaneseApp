import 'package:equatable/equatable.dart';

/// `TopicEntity` đại diện cho một topic trên thiết bị.
///
/// Entity này chứa thông tin cơ bản của topic và
/// tiến độ học từ (percent) để hiển thị trong UI.
class TopicEntity extends Equatable{
  final String topicId;
  final String topicName;
  final String owner;
  final int amoutWord;
  final double percent;

  const TopicEntity({required this.topicId, required this.topicName, required this.owner, required this.amoutWord, required this.percent});

  factory TopicEntity.fromJson(Map<String, dynamic> json){
    return TopicEntity(
        topicId: json["id"],
        topicName: json["name"],
        owner: json["user"],
        amoutWord: json["amount"],
        percent: json["percent"] ?? 0.0
    );
  }

  @override
  List<Object?> get props => [topicId, topicName, owner, amoutWord, percent];
}