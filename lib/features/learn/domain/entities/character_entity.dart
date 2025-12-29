import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/learn/domain/entities/character_example.dart';

class CharacterEntity extends Equatable{
  final String character;
  final String romaji;
  final List<CharacterExample> examples;
  final String pathImage;
  final int level;

  const CharacterEntity({required this.character, required this.romaji, required this.examples, required this.pathImage, required this.level});

  @override
  List<Object?> get props => [character, romaji, examples, pathImage, level];
}