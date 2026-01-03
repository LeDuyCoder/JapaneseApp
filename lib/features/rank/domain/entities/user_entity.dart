import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String userId;
  final int score;
  final String userName;
  final int rank;

  const UserEntity({required this.userId, required this.score, required this.userName, required this.rank});

  @override
  List<Object?> get props => [userId, score, userName, rank];
}