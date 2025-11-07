import 'package:get_it/get_it.dart';
import 'package:japaneseapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:japaneseapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:japaneseapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:japaneseapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:japaneseapp/features/auth/domain/usecases/register_usecase.dart';
import 'package:japaneseapp/features/auth/presentation/bloc/auth_bloc.dart'; // 👈 THÊM DÒNG NÀY

final getIt = GetIt.instance;

void initAuthFeature() {
  // --- Data layer ---
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(),
  );

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remote: getIt()),
  );

  // --- Domain layer ---
  getIt.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
        () => RegisterUseCase(getIt<AuthRepository>()),
  );

  // --- Presentation layer (Bloc) ---
  getIt.registerFactory<AuthBloc>(
        () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
    ),
  );
}
