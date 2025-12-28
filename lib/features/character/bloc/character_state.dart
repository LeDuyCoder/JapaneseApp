import 'package:japaneseapp/features/character/domain/entity/character_collection_entity.dart';

abstract class CharacterState{}

class CharacterInitialState extends CharacterState{}

class LoadingCharacterState extends CharacterState{}

class LoadedCharacterState extends CharacterState{
  ///danh sách chữ cái load từ json data
  final CharacterCollectionEntity characterCollectionEntity;

  LoadedCharacterState({required this.characterCollectionEntity});
}

class ErrorCharracterState extends CharacterState{
  final String message;

  ErrorCharracterState({required this.message});
}