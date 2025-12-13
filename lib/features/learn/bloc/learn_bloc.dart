import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/learn_event.dart';
import 'package:japaneseapp/features/learn/bloc/learn_state.dart';
import 'package:japaneseapp/features/learn/data/repositories/learn_repository_impl.dart';
import 'package:japaneseapp/features/learn/domain/entities/test_entity.dart';

import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/domain/usecase/generate_test_usecase.dart';
import 'package:japaneseapp/features/learn/presentation/pages/learn_page.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';

class LearnBloc extends Bloc<LearnEvent, LearnState>{
  final LearnRepositoryImpl repository;

  LearnBloc(this.repository) : super(LearnInitial()) {
    on<StartLearningEvent>(_onStartLearn);
  }

  Future<void> _onStartLearn(StartLearningEvent event, Emitter emit) async {
    emit(LearnGeneratation());
    List<WordEntity> wordEntitiesData = await repository.loadWordsFromTopic(event.topicName);
    GenerateTestUsecase generateTestUsecase = GenerateTestUsecase(LearnPage.amountQuestion, wordEntities: List<WordEntity>.from(wordEntitiesData));
    List<TestEntity> listTest = generateTestUsecase.generate(List<WordEntity>.from(wordEntitiesData));
    emit(LearnGenerated(listTest, wordEntitiesData));
  }
}