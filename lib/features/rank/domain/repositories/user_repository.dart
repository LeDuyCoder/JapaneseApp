import 'package:japaneseapp/features/rank/domain/entities/user_entity.dart';

abstract class UserRepository{
  Future<UserEntity> load(String userId);
}