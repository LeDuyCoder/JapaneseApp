import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/manager_topic/presentation/cubit/all_folder_state.dart';

class AllFolderCubit extends Cubit<AllFolderState>{
  AllFolderCubit() : super(const AllFolderState(showedType: AllFolderShowedType.list));

  void changeShowedType(AllFolderShowedType type){
    emit(AllFolderState(showedType: type));
  }
}