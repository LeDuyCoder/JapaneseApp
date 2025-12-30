class StreakEntity {
  final List<String> history;
  final List<String> lastHistoryStreak;
  final String lastHistory;
  final int streak;

  const StreakEntity(this.history, this.lastHistoryStreak, this.lastHistory, this.streak);

  int get count => history.length;

  StreakEntity copyWith({List<String>? history, List<String>? lastHistoryStreak, String? lastHistory, int? streak}){
    return StreakEntity(
        history??this.history,
        lastHistoryStreak??this.lastHistoryStreak,
        lastHistory??this.lastHistory,
        streak??this.streak
    );
  }
}
