import 'package:japaneseapp/features/rank/domain/entities/summary_rank_entity.dart';

abstract class SummaryRankEvent{}

class LoadSummaryRankEvent extends SummaryRankEvent{
  final String userId;

  LoadSummaryRankEvent({required this.userId});
}

class RewardSummaryRankEvent extends SummaryRankEvent{
  final SummaryRankEntity summaryRankEntity;

  RewardSummaryRankEvent({required this.summaryRankEntity});
}