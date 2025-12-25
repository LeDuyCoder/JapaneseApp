import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';

abstract class FolderRepository {
  Future<List<TopicEntity>> getTopics(int folderId);
  Future<List<TopicEntity>> getAllTopics();
  Future<void> removeTopic(int folderId, String topicId);
  Future<void> deleteFolder(int folderId);
  Future<void> addTopicToFolder(int folderId, String topicId);
  Future<void> addFolder(String folderName);
  Future<bool> isFolderAlreadyExists(String folderName);
}
