abstract class AddFolderEvent {}

class AddFolder extends AddFolderEvent {
  final String folderName;
  AddFolder(this.folderName);
}