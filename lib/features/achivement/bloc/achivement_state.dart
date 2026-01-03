import 'package:japaneseapp/features/achivement/domain/entities/achivement_entity.dart';

abstract class AchivementState{}

class LoadingAchivementState extends AchivementState{}

class LoadedAchivementState extends AchivementState{
  final AchivementEntity achivementEntity;

  LoadedAchivementState({required this.achivementEntity});

}

class ErrorAchivementState extends AchivementState{
  final String msg;

  ErrorAchivementState(this.msg);
}