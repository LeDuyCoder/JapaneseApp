abstract class AddFolderState{}

class AddFolderInitial extends AddFolderState{}

class AddFolderLoading extends AddFolderState{}

class AddFolderAlready extends AddFolderState{
  final String message;
  AddFolderAlready(this.message);
}

class AddFolderSuccess extends AddFolderState{
  final String message;
  AddFolderSuccess(this.message);
}

class AddFolderError extends AddFolderState{
  final String message;
  AddFolderError(this.message);
}