import 'package:japaneseapp/features/manager_topic/domain/repositories/folder_repository.dart';

class DeleteFolder {
  final FolderRepository repository;

  DeleteFolder(this.repository);

  Future<void> call(int folderId) {
    return repository.deleteFolder(folderId);
  }
}
