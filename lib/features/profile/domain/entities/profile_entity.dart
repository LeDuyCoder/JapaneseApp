import 'package:japaneseapp/features/profile/domain/entities/progress_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/statistic_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/streak_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/user_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/wallet_entity.dart';

class ProfileEntity {
  final UserEntity user;
  final ProgressEntity progress;
  final StreakEntity streak;
  final WalletEntity wallet;
  final StatisticEntity statistic;

  const ProfileEntity({
    required this.user,
    required this.progress,
    required this.streak,
    required this.wallet,
    required this.statistic,
  });
}
