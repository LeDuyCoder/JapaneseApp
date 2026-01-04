import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/word/bloc/word_event.dart';
import 'package:japaneseapp/features/word/bloc/word_state.dart';
import 'package:japaneseapp/features/word/domain/repositories/word_repository.dart';

class WordBloc extends Bloc<WordEvent, WordState>{
  final WordRepository repository;

  WordBloc({required this.repository}) : super(IntitialWordState()){
    on<CreateTopicEvent>(_onCreateTopic);
  }

  Future<void> _onCreateTopic(CreateTopicEvent event, Emitter emit) async {
    emit(LoadingWordState());
    await repository.createTopic(event.topicEntity);
    emit(SuccessWordState());
  }

  Future<bool> isExistTopicName(String nameTopic){
    return repository.hasTopic(nameTopic);
  }
}