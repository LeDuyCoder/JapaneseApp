abstract class RankEvent{}

class LoadRankEvent extends RankEvent{
  final String userId;

  LoadRankEvent({required this.userId});
}