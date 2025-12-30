class ProgressEntity {
  final int level;
  final int exp;
  final int nextExp;

  const ProgressEntity({
    required this.level,
    required this.exp,
    required this.nextExp,
  });

  double get ratio => exp / nextExp;
}
