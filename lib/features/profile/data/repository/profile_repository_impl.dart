import 'package:japaneseapp/features/profile/data/datasource/profile_local_datasource.dart';
import 'package:japaneseapp/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:japaneseapp/features/profile/domain/entities/profile_entity.dart';
import 'package:japaneseapp/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource local;
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.local, this.remote);

  @override
  Future<ProfileEntity> getProfile() async {
    final user = await remote.getUser();

    return ProfileEntity(
      user: user,
      progress: await local.getProgress(),
      streak: await local.getStreak(),
      wallet: await remote.getWallet(user.uid),
      statistic: await local.getStatistic(),
    );
  }
}
