import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:japaneseapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:japaneseapp/features/auth/domain/usecases/register_usecase.dart';
import 'package:japaneseapp/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        loginUseCase: GetIt.I<LoginUseCase>(),
        registerUseCase: GetIt.I<RegisterUseCase>(),
      ),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: LoginForm()),
      ),
    );
  }
}
