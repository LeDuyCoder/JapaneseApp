import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topicdetail_event.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topicdetail_state.dart';
import 'package:japaneseapp/features/topicdetail/data/repositories/Topicdetails_repository_impl.dart';

class TopicdetailBloc extends Bloc<TopicDetailEvent, TopicDetailState> {
  final TopicdetailsRepositoryImpl repo;

  TopicdetailBloc(this.repo) : super(TopicDetailInitial()) {
    on<LoadTopicDetailEvent>(_onLoad);
  }

  Future<void> _onLoad(LoadTopicDetailEvent event, Emitter emit) async {
    emit(TopicDetailLoading());
    await Future.delayed(const Duration(seconds: 2));
    final topicDetails = await repo.loadTopicDetails(event.nameTopic);
    emit(TopicDetailLoaded(words: topicDetails));
  }

}