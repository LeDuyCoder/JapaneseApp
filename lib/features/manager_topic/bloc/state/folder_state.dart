import 'package:japaneseapp/features/manager_topic/domain/entities/folder_entity.dart';

abstract class FolderState {}

class FolderInitial extends FolderState {}

class FolderLoading extends FolderState {}

class FolderLoaded extends FolderState {
  final List<FolderEntity> folders;
  FolderLoaded({required this.folders});
}

class FolderError extends FolderState {
  final String message;
  FolderError(this.message);
}