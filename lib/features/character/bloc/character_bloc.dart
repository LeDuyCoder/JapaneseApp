import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/character/bloc/character_event.dart';
import 'package:japaneseapp/features/character/bloc/character_state.dart';
import 'package:japaneseapp/features/character/domain/entity/character_collection_entity.dart';
import 'package:japaneseapp/features/character/domain/repositories/character_repository.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState>{
  final CharacterRepository repo;

  CharacterBloc({required this.repo}) : super(LoadingCharacterState()) {
    on<LoadCharacterEvent>(_onLoadCharacter);
  }

  Future<void> _onLoadCharacter(LoadCharacterEvent event, Emitter<CharacterState> emit) async {
    try{
      CharacterCollectionEntity data = await repo.loadCharacters(type: event.type, rawData: event.rowData);
      emit(LoadedCharacterState(characterCollectionEntity: data));
    }catch(e){
      emit(ErrorCharracterState(message: e.toString()));
    }
  }
}