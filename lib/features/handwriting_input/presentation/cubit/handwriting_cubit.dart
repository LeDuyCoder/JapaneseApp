import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/handwriting_input/domain/repository/handwriting_repository.dart';
import 'package:japaneseapp/features/handwriting_input/domain/usecases/send_handwriting.dart';
import 'handwriting_state.dart';
import 'package:flutter/material.dart';

class HandwritingCubit extends Cubit<HandwritingState> {
  final SendHandwriting sendHandwritingUsecase;
  final HandwritingRepository repository;

  HandwritingCubit({
    required this.sendHandwritingUsecase,
    required this.repository,
  }) : super(const HandwritingState());

  void insertText(TextEditingController textEditingController, String text) {
    textEditingController.text = textEditingController.text + text;
  }

  void deleteText(TextEditingController textEditingController) {
    textEditingController.text =
        textEditingController.text.substring(
          0,
          textEditingController.text.length - 1,
        );
  }

  Future<void> sendHandwriting(List<List<Offset>> strokes) async {
    emit(state.copyWith(loading: true));
    final result = await sendHandwritingUsecase(strokes);
    emit(
      state.copyWith(
        candidates: result.candidates,
        loading: false,
      ),
    );
  }
}
