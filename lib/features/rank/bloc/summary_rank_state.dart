import 'package:japaneseapp/features/rank/domain/entities/summary_rank_entity.dart';

abstract class SummaryRankState{}

class LoadingSummaryRankState extends SummaryRankState{}

class LoadedSummaryRankState extends SummaryRankState{
  final SummaryRankEntity summaryRankEntity;

  LoadedSummaryRankState({required this.summaryRankEntity});
}

class RewardCompletedState extends SummaryRankState{}