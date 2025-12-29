import 'package:japaneseapp/features/manager_topic/domain/repositories/folder_repository.dart';

class RemoveTopicFromFolder {
  final FolderRepository repository;

  RemoveTopicFromFolder(this.repository);

  Future<void> call(int folderId, String topicId) {
    return repository.removeTopic(folderId, topicId);
  }
}
