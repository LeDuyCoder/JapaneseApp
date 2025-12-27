abstract class LearnEvent {}

class StartLearningEvent extends LearnEvent {
  final String topicId;
  StartLearningEvent(this.topicId);
}