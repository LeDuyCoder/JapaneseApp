import 'package:intl/intl.dart';
import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/manager_topic/domain/entities/folder_entity.dart';
import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';
import 'package:japaneseapp/features/manager_topic/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  final LocalDbService db;

  FolderRepositoryImpl(this.db);

  @override
  Future<List<TopicEntity>> getTopics(int folderId) async {
    final result = await db.folderDao.getAllTopicInFolder(folderId);
    return result.map((e) => TopicEntity(id: e.id, name: e.name, owner: e.owner, count: e.count)).toList();
  }

  @override
  Future<void> removeTopic(int folderId, String topicId) {
    return db.folderDao.deleteTopicFromFolder(folderId, topicId);
  }

  @override
  Future<void> deleteFolder(int folderId) {
    return db.folderDao.deleteFolder(folderId);
  }

  @override
  Future<void> addTopicToFolder(int folderId, String topicId) async {
    await db.folderDao.addTopicToFolder(folderId, topicId);
  }

  @override
  Future<List<TopicEntity>> getAllTopics() async {
    final result = await db.topicDao.getAllTopics();
    final List<TopicEntity> topics = [];
    for (final e in result) {
      final words = await db.topicDao.getAllWordsByTopic(e["name"]);
      topics.add(
        TopicEntity(
          id: e["id"],
          name: e["name"],
          owner: e["user"],
          count: words.length,
        ),
      );
    }
    return topics;
  }

  @override
  Future<void> addFolder(String folderName) {
    return db.folderDao.insertFolder(folderName);
  }

  @override
  Future<bool> isFolderAlreadyExists(String folderName) {
    return db.folderDao.hasFolderName(folderName);
  }

  @override
  Future<List<FolderEntity>> getAllFolders() async {
    var foldersData = await db.folderDao.getAllFolders();
    final formatter = DateFormat('dd/MM/yyyy hh:mm a');
    List<FolderEntity> folders = [];
    for (var e in foldersData) {

      folders.add(
        FolderEntity(
          id: e["id"],
          name: e["namefolder"],
          createdAt: formatter.parse(e["datefolder"]),
          amountTopic: e["amountTopic"],
        ),
      );
    }
    return folders;
  }
}
