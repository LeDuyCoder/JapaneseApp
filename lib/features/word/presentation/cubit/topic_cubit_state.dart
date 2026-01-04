import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:japaneseapp/features/word/domain/entities/word_entity.dart';

class TopicCubitState extends Equatable{
  final String nameTopic;
  final List<WordEntity> words;
  final PlatformFile? file;

  const TopicCubitState(this.file, {required this.nameTopic, required this.words});

  @override
  List<Object?> get props => [nameTopic, words, file];

  TopicCubitState copyWith({String? nameTopic, List<WordEntity>? words, PlatformFile? file}){
    return TopicCubitState(file ?? this.file, nameTopic: nameTopic ?? this.nameTopic, words: words ?? this.words);
  }
}