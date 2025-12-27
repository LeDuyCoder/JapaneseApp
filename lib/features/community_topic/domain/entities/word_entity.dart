import 'package:equatable/equatable.dart';

class WordEntity extends Equatable{
  final String word;
  final String mean;
  final String wayread;

  const WordEntity({required this.word, required this.mean, required this.wayread});

  @override
  List<Object?> get props => [word, mean, wayread];
}