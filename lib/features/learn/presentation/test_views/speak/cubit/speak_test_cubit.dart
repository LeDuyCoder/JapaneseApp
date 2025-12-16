import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/speak/cubit/speak_test_state.dart';
import 'package:japaneseapp/features/learn/presentation/widget/result_popup_widget.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeakTestCubit extends Cubit<SpeakTestState> {
  final int maxListenTime = 3;

  Timer? _timer;
  Timer? _recognizeTimer;
  final Stopwatch _stopwatch = Stopwatch();

  final SpeechToText _speech = SpeechToText();
  final KanaKit kanaKit = KanaKit();

  final VoidCallback onComplete;

  SpeakTestCubit(WordEntity wordEntity, this.onComplete)
      : super(SpeakTestState.initial(wordEntity));

  /* ================= START LISTEN ================= */

  void startListening(BuildContext context) {
    _stopwatch
      ..reset()
      ..start();

    emit(state.copyWith(
      isListening: true,
      timeDisplay: "00:00",
      userAnswer: "",
      confidence: 0,
    ));

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed = _stopwatch.elapsed.inSeconds;

      if (elapsed >= maxListenTime) {
        stopListening(context, handled: true);
      } else {
        emit(state.copyWith(
          timeDisplay: _formatTime(_stopwatch.elapsed),
        ));
      }
    });

    _listen(context);
  }

  /* ================= STOP LISTEN ================= */

  Future<void> stopListening(BuildContext context, {bool handled = true}) async {
    _timer?.cancel();
    _stopwatch.stop();
    _speech.stop();

    emit(state.copyWith(
      isListening: false,
      timeDisplay: "00:00",
    ));

    if (handled) {
      await handleAnswer(context);
    }
  }

  /* ================= LISTEN ================= */

  Future<void> _listen(BuildContext context) async {
    bool available = await _speech.initialize(
      onStatus: (val) => print("Status: $val"),
      onError: (val) => print("Error: $val"),
    );

    if (!available) {
      stopListening(context);
      return;
    }

    _speech.listen(
      localeId: "ja-JP",
      onResult: (val) {
        emit(state.copyWith(
          userAnswer: val.recognizedWords,
          confidence: val.hasConfidenceRating ? val.confidence : 0,
        ));
      },
    );
  }

  /* ================= HANDLE ANSWER ================= */

  Future<void> handleAnswer(BuildContext context) async {
    String userAnswer = toRomaji(state.userAnswer);
    String correctKana = toRomaji(state.wordEntity.wayread ?? "");
    String correctWord = toRomaji(state.wordEntity.word ?? "");

    bool isCorrect =
        userAnswer == correctKana || userAnswer == correctWord;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // để custom full UI
      builder: (sheetContext) {
        return ResultPopupWidget(
            isCorrect: isCorrect,
            wordEntity: state.wordEntity,
            onPressButton: (){
              onComplete();
            },
            tryAgain: false
        );
      },
    );
  }

  /* ================= SPEAK TIMER ================= */

  void speak(BuildContext context, {int timeSpeak = 2}) {
    startListening(context);
    emit(state.copyWith(speaking: true));

    _recognizeTimer?.cancel();
    _recognizeTimer = Timer(
      Duration(seconds: timeSpeak),
          () {
        _speech.stop();
        emit(state.copyWith(speaking: false));
      },
    );
  }

  /* ================= UTILS ================= */

  String toRomaji(String text) {
    return kanaKit.toRomaji(text).trim().toLowerCase();
  }

  String _formatTime(Duration duration) {
    final seconds = duration.inSeconds;
    return "00:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _recognizeTimer?.cancel();
    _speech.stop();
    return super.close();
  }
}
