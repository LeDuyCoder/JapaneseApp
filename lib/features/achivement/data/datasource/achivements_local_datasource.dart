import 'package:japaneseapp/features/achivement/domain/entities/achivement_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchivementsLocalDatasource{
  Future<AchivementEntity> loadAchivements() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return AchivementEntity(achivemenetsOpened: sharedPreferences.getStringList("achivement") ?? []);
  }
}