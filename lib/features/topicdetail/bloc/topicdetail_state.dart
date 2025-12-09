import 'package:japaneseapp/features/topicdetail/data/models/word_model.dart';

abstract class TopicDetailState {}

class TopicDetailInitial extends TopicDetailState {}
class TopicDetailLoading extends TopicDetailState {}
class TopicDetailLoaded extends TopicDetailState {
  final List<WordModel> words;
  TopicDetailLoaded({required this.words});
}
class TopicDetailError extends TopicDetailState {
  final String message;
  TopicDetailError({required this.message});
}