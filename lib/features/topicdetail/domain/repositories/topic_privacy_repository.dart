abstract class TopicPrivacyRepository {
  Future<bool> isTopicPrivate(String idTopic);
  Future<void> setTopicPrivacy(String idTopic, String nameTopic, bool isPrivate);
}