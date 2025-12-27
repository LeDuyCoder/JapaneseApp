import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';

abstract class CommunityTopicState {}

class CommunityTopicInitial extends CommunityTopicState {}

class CommunityTopicLoaded extends CommunityTopicState {
  final List<CommunityTopicEntity> topics;

  CommunityTopicLoaded({required this.topics});
}

class CommunityTopicLoading extends CommunityTopicState {}

class CommunityTopicError extends CommunityTopicState {
  final String message;

  CommunityTopicError(this.message);
}

class CommunityTopicNoFound extends CommunityTopicState{}