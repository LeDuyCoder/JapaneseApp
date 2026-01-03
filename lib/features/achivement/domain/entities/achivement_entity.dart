import 'package:equatable/equatable.dart';
import 'package:japaneseapp/core/Config/achivementJson.dart';

class AchivementEntity extends Equatable{
  final List<String> achivemenetsOpened;
  final dynamic achivements = achivementJson.instance.data;


  AchivementEntity({required this.achivemenetsOpened});

  @override
  List<Object?> get props => [achivemenetsOpened];
}