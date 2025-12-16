import 'package:japaneseapp/features/topicdetail/domain/repositories/topic_privacy_repository.dart';

class CheckTopicExistUseCase {
  final TopicPrivacyRepository repository;

  CheckTopicExistUseCase(this.repository);

  Future<bool> call(String topicId) async {
    return await repository.isTopicPrivate(topicId);
  }
}