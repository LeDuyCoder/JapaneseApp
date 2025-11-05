import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/features/dashboard/domain/models/folder_model.dart';

class TabHomeLocalDataSource {
  final LocalDbService db = LocalDbService.instance;

  Future<List<FolderModel>> getFolders() async {
    final rows = await db.folderDao.getAllFolders();
    return rows.map((r) => FolderModel.fromMap(r)).toList();
  }

  Future<List<Map<String,dynamic>>> getTopics() async {
    return await db.topicDao.getAllTopics();
  }

  Future<bool> hasTopicName(String name) => db.topicDao.hasTopicName(name);

// methods to insert topic, folder etc moved here
}
