import 'package:japaneseapp/features/rank/data/datasource/rank_datasource.dart';
import 'package:japaneseapp/features/rank/domain/entities/rank_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/summary_rank_entity.dart';
import 'package:japaneseapp/features/rank/domain/repositories/rank_repository.dart';

class RankRepositoryImpl implements RankRepository{
  final RankDatasource datasource;

  RankRepositoryImpl({required this.datasource});

  @override
  Future<SummaryRankEntity> load(String userId) {
    return datasource.load(userId);
  }

}