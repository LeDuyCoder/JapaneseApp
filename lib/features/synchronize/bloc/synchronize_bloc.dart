import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/service/FunctionService.dart';
import 'package:japaneseapp/core/utils/network_utils.dart';
import 'package:japaneseapp/features/synchronize/bloc/synchronize_event.dart';
import 'package:japaneseapp/features/synchronize/bloc/synchronize_state.dart';

class SynchronizeBloc extends Bloc<SynchronizeEvent, SynchronizeState>{

  SynchronizeBloc() : super(IntitialSynchronizeState()) {
    on<PushSynchronizeEvent>(_onPushSynchronize);
    on<DownloadSynchronizeEvent>(_onDownloadSynchronize);
  }

  Future<void> _onPushSynchronize(PushSynchronizeEvent event, Emitter emit) async {
    emit(LoadingSynchronizeState());

    final hasInternet = await NetworkUtils.hasInternet();
    if (!hasInternet) {
      emit(ErrorSynchronizeState());
      return;
    }

    try {
      await Future.delayed(const Duration(seconds: 3));
      await FunctionService.synchronyData();
      emit(SuccessSynchronizeState());
    } catch (e) {
      emit(ErrorSynchronizeState());
    }
  }


  Future<void> _onDownloadSynchronize(DownloadSynchronizeEvent event, Emitter emit) async {
    emit(LoadingSynchronizeState());

    final hasInternet = await NetworkUtils.hasInternet();
    if (!hasInternet) {
      emit(ErrorSynchronizeState());
      return;
    }

    try {
      await Future.delayed(const Duration(seconds: 3));
      await FunctionService.asynchronyData();
      emit(SuccessSynchronizeState());
    } catch (e) {
      emit(ErrorSynchronizeState);
    }
  }

}