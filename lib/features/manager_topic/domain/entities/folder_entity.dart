import 'package:equatable/equatable.dart';

class FolderEntity extends Equatable{
  final int id;
  final String name;
  final DateTime createdAt;
  final int amountTopic;

  const FolderEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.amountTopic,
  });

  @override
  List<Object?> get props => [id, name, createdAt, amountTopic];

  factory FolderEntity.fromMap(Map<String, dynamic> map) {
    return FolderEntity(
      id: map['id'],
      name: map['namefolder'] ?? '',
      createdAt: DateTime.parse(map['datefolder'] ?? DateTime.now().toIso8601String()),
      amountTopic: map['amountTopic'] ?? 0,
    );
  }
}