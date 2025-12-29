import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/manager_topic/bloc/event/folder_manager_event.dart';
import 'package:japaneseapp/features/manager_topic/bloc/state/folder_manager_state.dart';
import 'package:japaneseapp/features/manager_topic/domain/usecase/delete_folder.dart';
import 'package:japaneseapp/features/manager_topic/domain/usecase/get_topics_in_folder.dart';
import 'package:japaneseapp/features/manager_topic/domain/usecase/remove_topic_from_folder.dart';

class FolderManagerBloc
    extends Bloc<FolderManagerEvent, FolderManagerState> {
  final int folderId;
  final GetTopicsInFolder getTopics;
  final RemoveTopicFromFolder removeTopic;
  final DeleteFolder deleteFolder;

  FolderManagerBloc({
    required this.folderId,
    required this.getTopics,
    required this.removeTopic,
    required this.deleteFolder,
  }) : super(FolderManagerLoading()) {
    on<LoadTopics>(_onLoad);
    on<RemoveTopic>(_onRemoveTopic);
    on<DeleteFolderEvent>(_onDeleteFolder);
  }

  Future<void> _onLoad(
      LoadTopics event, Emitter emit) async {
    emit(FolderManagerLoading());
    try {
      final data = await getTopics(folderId);
      emit(FolderManagerLoaded(data));
    } catch (e) {
      emit(FolderManagerError(e.toString()));
    }
  }

  Future<void> _onRemoveTopic(
      RemoveTopic event, Emitter emit) async {
    await removeTopic(folderId, event.topicId);
    add(LoadTopics());
  }

  Future<void> _onDeleteFolder(
      DeleteFolderEvent event, Emitter emit) async {
    await deleteFolder(folderId);
  }
}
