import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';
import 'package:japaneseapp/features/manager_topic/domain/repositories/folder_repository.dart';

class GetTopicsInFolder {
  final FolderRepository repository;

  GetTopicsInFolder(this.repository);

  Future<List<TopicEntity>> call(int folderId) {
    return repository.getTopics(folderId);
  }
}
