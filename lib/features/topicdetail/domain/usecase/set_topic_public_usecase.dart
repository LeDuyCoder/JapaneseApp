import 'package:japaneseapp/features/topicdetail/domain/repositories/topic_privacy_repository.dart';

class SetTopicPublicUseCase {
  final TopicPrivacyRepository repository;

  SetTopicPublicUseCase(this.repository);

  Future<void> call(String topicId, String nameTopic) {
    return repository.setTopicPrivacy(topicId, nameTopic, true);
  }
}