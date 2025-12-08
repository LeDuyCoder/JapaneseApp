import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl({required this.remote});

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    final userModel = await remote.login(email: email, password: password);
    return userModel;
  }

  @override
  Future<UserEntity> register({required String email, required String password, String? name}) async {
    final userModel = await remote.register(email: email, password: password, name: name);
    return userModel;
  }
}
