import 'package:japaneseapp/features/rank/data/datasource/leaderboard_datasource.dart';
import 'package:japaneseapp/features/rank/domain/entities/leaderboard_entity.dart';
import 'package:japaneseapp/features/rank/domain/repositories/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderBoardRepository{
  final LeaderboardDatasource datasource;

  LeaderboardRepositoryImpl({required this.datasource});

  @override
  Future<LeaderboardEntity> load() {
    return datasource.load(10);
  }

}