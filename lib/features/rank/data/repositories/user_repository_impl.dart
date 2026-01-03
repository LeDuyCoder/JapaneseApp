import 'package:japaneseapp/features/rank/domain/entities/user_entity.dart';
import 'package:japaneseapp/features/rank/data/datasource/user_datasource.dart';
import 'package:japaneseapp/features/rank/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository{
  final UserDatasource datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  Future<UserEntity> load(String userId) {
    return datasource.load(userId);
  }

}