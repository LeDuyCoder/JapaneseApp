class UserProgress {
  final int level;
  final int exp;
  final int nextExp;


  const UserProgress({
    required this.level,
    required this.exp,
    required this.nextExp,
  });


  UserProgress copyWith({
    int? level,
    int? exp,
    int? nextExp,
  }) {
    return UserProgress(
      level: level ?? this.level,
      exp: exp ?? this.exp,
      nextExp: nextExp ?? this.nextExp,
    );
  }
}