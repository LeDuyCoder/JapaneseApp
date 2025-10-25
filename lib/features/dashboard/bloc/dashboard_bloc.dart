import 'package:bloc/bloc.dart';
import 'package:japaneseapp/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepositoryImpl repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<FetchDashboardData>((event, emit) async {
      emit(DashboardLoading());
      try {
        final data = await repository.getDashboardData();
        final userModel = await repository.getUserInfo();

        print(data);
        print(userModel);

        emit(DashboardLoaded(
          topicsLocal: List<Map<String,dynamic>>.from(data['topic'] ?? []),
          folders: List<Map<String,dynamic>>.from(data['folder'] ?? []),
          topicServer: data['topicServer'] ?? [],
          userModel: userModel,
        ));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
