import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<UserEntity> call({required String email, required String password, String? name}) {
    return repository.register(email: email, password: password, name: name);
  }
}
