import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';

abstract class AddTopicState {}

class AddTopicInitial extends AddTopicState {}

class AddTopicLoading extends AddTopicState {}

class LoadAllTopicsSuccess extends AddTopicState {
  final List<TopicEntity> topicsInFolder;
  final List<TopicEntity> topicsOutFolder;

  LoadAllTopicsSuccess(this.topicsInFolder, this.topicsOutFolder);
}