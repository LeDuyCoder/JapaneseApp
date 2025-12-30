import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/service/FunctionService.dart';
import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/auth/presentation/pages/logout/logout_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  Future<bool> hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 3));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    emit(LogoutLoading());

    if (!await hasInternet()) {
      emit(LogoutNoInternet());
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final db = LocalDbService.instance;

      await FunctionService.synchronyData();
      await prefs.clear();
      await db.miscDao.clearAllData();
      await FirebaseAuth.instance.signOut();

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
