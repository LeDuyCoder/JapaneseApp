import 'package:bloc/bloc.dart';
import 'package:japaneseapp/features/dashboard/data/repository/tabhome_repository_impl.dart';
import 'tabhome_event.dart';
import 'tabhome_state.dart';

class TabHomeBloc extends Bloc<TabHomeEvent, TabHomeState> {
  final TabHomeRepositoryImpl repository;

  TabHomeBloc({required this.repository}) : super(TabHomeInitial()) {
    on<FetchTabHomeData>((event, emit) async {
      emit(TabHomeLoading());
      try {
        final data = await repository.getTabHomeData();
        final userModel = await repository.getUserInfo();

        print(data);
        print(userModel);

        emit(TabHomeLoaded(
          topicsLocal: List<Map<String,dynamic>>.from(data['topic'] ?? []),
          folders: List<Map<String,dynamic>>.from(data['folder'] ?? []),
          topicServer: data['topicServer'] ?? [],
          userModel: userModel,
        ));
      } catch (e) {
        emit(TabHomeError(e.toString()));
      }
    });
  }
}
