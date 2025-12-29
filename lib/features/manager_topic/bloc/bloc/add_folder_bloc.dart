import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/manager_topic/bloc/event/add_folder_event.dart';
import 'package:japaneseapp/features/manager_topic/bloc/state/add_folder_state.dart';
import 'package:japaneseapp/features/manager_topic/domain/repositories/folder_repository.dart';

class AddFolderBloc extends Bloc<AddFolderEvent, AddFolderState>{

  final FolderRepository repository;

  AddFolderBloc({required this.repository}) : super(AddFolderInitial()) {
    on<AddFolder>(_onAddFolder);
  }

  Future<void> _onAddFolder(AddFolder event, Emitter emit) async {
    emit(AddFolderLoading());
    try {
      if(await repository.isFolderAlreadyExists(event.folderName)){
        emit(AddFolderAlready("tên folder này đã tồn tài"));
      }else{
        await repository.addFolder(event.folderName);
        emit(AddFolderSuccess(event.folderName));
      }
    } catch (e) {
      emit(AddFolderError(e.toString()));
    }
  }

}