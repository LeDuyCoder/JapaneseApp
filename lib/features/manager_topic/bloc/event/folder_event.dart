abstract class FolderEvent {}

class FolderInitialEvent extends FolderEvent {}

class FolderOpened extends FolderEvent {
  final int folderId;

  FolderOpened(this.folderId);
}