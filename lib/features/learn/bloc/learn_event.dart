abstract class LearnEvent {}

class StartLearningEvent extends LearnEvent {
  final String topicName;
  StartLearningEvent(this.topicName);
}