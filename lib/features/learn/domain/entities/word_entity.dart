import 'package:equatable/equatable.dart';

class WordEntity extends Equatable{
  final String word;
  final String mean;
  final String wayread;
  final String topic;
  final int level;

  WordEntity({
    required this.word,
    required this.mean,
    required this.wayread,
    required this.topic,
    required this.level,
  });

  @override
  List<Object> get props => [word, mean, wayread, topic, level];
}