import 'package:japaneseapp/features/rank/domain/entities/rank_entity.dart';
import 'package:japaneseapp/features/rank/domain/entities/summary_rank_entity.dart';

abstract class RankRepository{
  Future<SummaryRankEntity> load(String userId);
}