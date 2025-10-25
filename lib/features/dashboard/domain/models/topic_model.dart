import 'package:japaneseapp/core/Module/topic.dart';

class TopicModel {
  final String id;
  final String name;
  final String? owner;
  final int? count;

  TopicModel({required this.id, required this.name, this.owner, this.count});

  factory TopicModel.fromTopicModule(topic t) => TopicModel(id: t.id, name: t.name, owner: t.owner, count: t.count);
}
