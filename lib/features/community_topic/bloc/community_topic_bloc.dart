import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/community_topic/bloc/community_topic_event.dart';
import 'package:japaneseapp/features/community_topic/bloc/community_topic_state.dart';

import 'package:japaneseapp/features/community_topic/domain/repositories/community_topic_repository.dart';

class CommunityTopicBloc extends Bloc<CommynityTopicEvent, CommunityTopicState> {
  final CommunityTopicRepository repository;

  CommunityTopicBloc(this.repository) : super(CommunityTopicInitial()) {
    on<searchTopics>(_onSearchTopics);
    on<LoadTopics>(_onLoadTopics);
  }

  void _onSearchTopics(searchTopics event, Emitter<CommunityTopicState> emit) async {
    emit(CommunityTopicLoading());
    try{
      await repository.searchTopics(event.nameTopic).then((fetchedTopics){
        if(fetchedTopics.isEmpty){
          emit(CommunityTopicNoFound());
        }else {
          emit(CommunityTopicLoaded(topics: fetchedTopics));
        }
      }).catchError((e){
        emit(CommunityTopicNoFound());
      });
    }catch(e){
      emit(CommunityTopicError(e.toString()));
    }
  }

  void _onLoadTopics(LoadTopics event, Emitter<CommunityTopicState> emit) async {
    emit(CommunityTopicLoading());
    try {
      await repository.loadCommunityTopics(event.limit).then((fetchedTopics) {
        emit(CommunityTopicLoaded(topics: fetchedTopics));
      }).catchError((e) {
        emit(CommunityTopicError(e.toString()));
      });
    } catch (e) {
      emit(CommunityTopicError(e.toString()));
    }
  }
}