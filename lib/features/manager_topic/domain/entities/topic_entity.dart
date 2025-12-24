import 'package:equatable/equatable.dart';

class TopicEntity extends Equatable {
  final String id;
  final String name;
  final String? owner;
  final int? count;

  TopicEntity({
    required this.id,
    required this.name,
    this.owner,
    this.count
  });

  @override
  List<Object?> get props => [id, name, owner, count];
}
