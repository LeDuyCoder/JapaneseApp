import 'package:equatable/equatable.dart';

class UserLeaderboardEnity extends Equatable{
  final String userId;
  final String userName;
  final int score;
  final String urlFrameAvater;
  final String urlAvatar;

  const UserLeaderboardEnity({required this.userId, required this.userName, required this.score, required this.urlFrameAvater, required this.urlAvatar});

  @override
  List<Object?> get props => [userId, userName, score, urlAvatar, urlFrameAvater];
}