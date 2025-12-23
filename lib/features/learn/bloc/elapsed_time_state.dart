class ElapsedTimeState {
  final Duration elapsed;
  final bool isRunning;

  const ElapsedTimeState({
    required this.elapsed,
    required this.isRunning,
  });

  factory ElapsedTimeState.initial() {
    return const ElapsedTimeState(
      elapsed: Duration.zero,
      isRunning: false,
    );
  }

  ElapsedTimeState copyWith({
    Duration? elapsed,
    bool? isRunning,
  }) {
    return ElapsedTimeState(
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
