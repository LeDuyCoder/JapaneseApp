import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/manager_topic/bloc/event/folder_event.dart';
import 'package:japaneseapp/features/manager_topic/bloc/state/folder_state.dart';
import 'package:japaneseapp/features/manager_topic/domain/repositories/folder_repository.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final FolderRepository repository;

  FolderBloc({required this.repository}) : super(FolderInitial()) {
    on<FolderInitialEvent>((event, emit) async {
      emit(FolderLoading());
      try {
        final data = await repository.getAllFolders();
        await Future.delayed(const Duration(milliseconds: 500));
        emit(FolderLoaded(
          folders: data,
        ));
      } catch (e) {
        emit(FolderError(e.toString()));
      }
    });
  }
}