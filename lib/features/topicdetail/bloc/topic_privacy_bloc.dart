import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topic_privacy_event.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topic_privacy_state.dart';
import 'package:japaneseapp/features/topicdetail/data/repositories/topic_privacy_repository.dart';

class TopicPrivacyBloc extends Bloc<TopicPrivacyEvent, topicPrivacyState> {
  final TopicPrivacyRepositoryImpl repository;

  TopicPrivacyBloc(this.repository) : super(TopicPrivacyInitial()) {
    on<LoadTopicPrivacyEvent>(_onLoad);
    on<SetTopicPrivateEvent>(_onSetPrivacy);
  }

  Future<void> _onLoad(LoadTopicPrivacyEvent event, Emitter emit) async {
    emit(TopicPrivacyLoading());
    final isPrivate = await repository.isTopicPrivate(event.idTopic);
    if(isPrivate) {
      emit(TopicPrivacyPrivate());
    } else {
      emit(TopicPrivacyPublic());
    }
  }

  Future<void> _onSetPrivacy(SetTopicPrivateEvent event, Emitter emit) async {
    emit(TopicPrivacyLoading());
    final isPrivate = await repository.isTopicPrivate(event.idTopic);
    await repository.setTopicPrivacy(event.idTopic, event.nameTopic, !isPrivate);
    if(!isPrivate) {
      emit(TopicPrivacyPrivate());
    } else {
      emit(TopicPrivacyPublic());
    }
  }
}