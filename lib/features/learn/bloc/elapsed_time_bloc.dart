import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/elapsed_time_event.dart';
import 'package:japaneseapp/features/learn/bloc/elapsed_time_state.dart';

class ElapsedTimeBloc extends Bloc<ElapsedTimeEvent, ElapsedTimeState> {
  late final Stopwatch _stopwatch;
  Timer? _timer;

  ElapsedTimeBloc() : super(ElapsedTimeState.initial()) {
    _stopwatch = Stopwatch();

    on<StartTimer>(_onStart);
    on<Tick>(_onTick);
    on<StopTimer>(_onStop);
    on<ResetTimer>(_onReset);
  }

  void _onStart(StartTimer event, Emitter emit) {
    if (state.isRunning) return;

    _stopwatch.start();

    _timer ??= Timer.periodic(
      const Duration(milliseconds: 500),
          (_) => add(Tick()),
    );

    emit(state.copyWith(isRunning: true));
  }

  void _onTick(Tick event, Emitter emit) {
    emit(state.copyWith(elapsed: _stopwatch.elapsed));
  }

  void _onStop(StopTimer event, Emitter emit) {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;

    emit(state.copyWith(isRunning: false));
  }

  void _onReset(ResetTimer event, Emitter emit) {
    _stopwatch
      ..stop()
      ..reset();

    _timer?.cancel();
    _timer = null;

    emit(ElapsedTimeState.initial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
