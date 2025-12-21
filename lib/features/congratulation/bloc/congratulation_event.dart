abstract class CongratulationEvent {}

class CongratulationStarted extends CongratulationEvent {
  final int correctAnswers;
  final int incorrectAnsers;

  CongratulationStarted(this.correctAnswers, this.incorrectAnsers);
}