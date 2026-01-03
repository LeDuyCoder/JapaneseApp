import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/achivement/bloc/achivement_event.dart';
import 'package:japaneseapp/features/achivement/bloc/achivement_state.dart';
import 'package:japaneseapp/features/achivement/domain/repositories/achievement_repository.dart';

class AchivementBloc extends Bloc<AchivementEvent, AchivementState>{

  final AchievementRepository repository;

  AchivementBloc({required this.repository}) : super(LoadingAchivementState()) {
    on<LoadAchivementEvent>(_onLoadAchivements);
  }

  Future<void> _onLoadAchivements(LoadAchivementEvent event, Emitter emit) async {
    emit(LoadedAchivementState(achivementEntity: await repository.loadAchivements()));
  }

}