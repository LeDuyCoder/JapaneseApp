import 'package:equatable/equatable.dart';

class UserLeaderboardEnity extends Equatable{
  final String userId;
  final String userName;
  final int score;

  const UserLeaderboardEnity({required this.userId, required this.userName, required this.score});

  @override
  List<Object?> get props => [userId, userName, score];
}