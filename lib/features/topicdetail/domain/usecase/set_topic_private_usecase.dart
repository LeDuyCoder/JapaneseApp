

import 'package:japaneseapp/features/topicdetail/domain/repositories/topic_privacy_repository.dart';

class SetTopicPrivateUseCase {
  final TopicPrivacyRepository repository;

  SetTopicPrivateUseCase(this.repository);

  Future<void> call(String idTopic, String nameTopic) {
    return repository.setTopicPrivacy(idTopic, nameTopic, false);
  }
}