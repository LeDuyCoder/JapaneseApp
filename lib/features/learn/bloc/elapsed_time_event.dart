abstract class ElapsedTimeEvent {}

class StartTimer extends ElapsedTimeEvent {}

class StopTimer extends ElapsedTimeEvent {}

class ResetTimer extends ElapsedTimeEvent {}

class Tick extends ElapsedTimeEvent {}
