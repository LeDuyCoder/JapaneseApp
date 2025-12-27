import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/community_topic/bloc/dowload_topic_event.dart';
import 'package:japaneseapp/features/community_topic/bloc/dowload_topic_state.dart';
import 'package:japaneseapp/features/community_topic/domain/repositories/dowload_topic_repository.dart';

class DowloadTopicBloc extends Bloc<DowloadTopicEvent, DowloadTopicState>{
  final DowloadTopicRepository repository;

  DowloadTopicBloc(this.repository) : super(DowloadTopicWaiting()) {
    on<DowloadTopicLoad>(_onLoad);
    on<DowloadTopic>(_onDowload);
  }

  Future<void> _onLoad(DowloadTopicLoad event, Emitter<DowloadTopicState> emit) async {
    try{
      await repository.loadData(event.topicId).then((feachData){
        emit(DowloadTopicLoadState(dowloadTopicEntity: feachData));
      }).catchError((e){
        emit(DowloadTopicError(message: e.toString()));
      });
    }catch (e){
      emit(DowloadTopicError(message: e.toString()));
    }
  }

  Future<void> _onDowload(DowloadTopic event, Emitter<DowloadTopicState> emit) async {
    emit(DowloadingTopic());
    try {
      await Future.delayed(const Duration(seconds: 3));
      await repository.dowload(event.dowloadTopicEntity);
      emit(DowloadTopicSucces());
    } catch (e) {
      emit(DowloadTopicError(message: e.toString()));
    }
  }

}