import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/learn_event.dart';
import 'package:japaneseapp/features/learn/bloc/learn_state.dart';
import 'package:japaneseapp/features/learn/data/repositories/learn_repository_impl.dart';
import 'package:japaneseapp/features/learn/domain/entities/character_entity.dart';
import 'package:japaneseapp/features/learn/domain/entities/test_entity.dart';

import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/domain/usecase/generate_test_usecase.dart';
import 'package:japaneseapp/features/learn/domain/usecase/load_characters_test_usecase.dart';
import 'package:japaneseapp/features/learn/presentation/pages/learn_page.dart';

class LearnBloc extends Bloc<LearnEvent, LearnState>{
  final LearnRepositoryImpl repository;

  LearnBloc(this.repository) : super(LearnInitial()) {
    on<StartLearningEvent>(_onStartLearn);
    on<StartLearningCharacterEvent>(_onStartLearnCharacter);
  }

  Future<void> _onStartLearn(StartLearningEvent event, Emitter emit) async {
    emit(LearnGeneratation());
    List<WordEntity> wordEntitiesData = await repository.loadWordsFromTopic(event.topicId);
    GenerateTestUsecase generateTestUsecase = GenerateTestUsecase(LearnPage.amountQuestion, wordEntities: List<WordEntity>.from(wordEntitiesData));
    List<TestEntity> listTest = await generateTestUsecase.generate(List<WordEntity>.from(wordEntitiesData));
    emit(LearnGenerated(listTest, wordEntitiesData));
  }

  Future<void> _onStartLearnCharacter(StartLearningCharacterEvent event, Emitter emit) async {
    emit(LearnGeneratation());
    LoadCharactersTesUsecase loadCharactersTesUsecase = LoadCharactersTesUsecase(type: event.type, setLevel: event.setLevel);
    List<CharacterEntity> listCharacters = loadCharactersTesUsecase.loadCharacters();
    List<WordEntity> listWordEntities = [];
    for(CharacterEntity characterEntity in listCharacters){
      listWordEntities.add(
          WordEntity(
              word: characterEntity.character,
              mean: characterEntity.romaji,
              wayread: characterEntity.romaji,
              topic: "topic",
              level: characterEntity.level,
              pathImage: characterEntity.pathImage,
              examples: characterEntity.examples
          )
      );
    }

    GenerateTestUsecase generateTestUsecase = GenerateTestUsecase(5, wordEntities: null);
    List<TestEntity> listTest = generateTestUsecase.generateOfCharacterTest(listCharacters);

    emit(LearnGenerated(listTest, listWordEntities));
  }
}