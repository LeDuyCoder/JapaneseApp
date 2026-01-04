import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/word/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/word/presentation/cubit/topic_cubit_state.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class TopicCubit extends Cubit<TopicCubitState>{
  TopicCubit() : super(const TopicCubitState(null, nameTopic: '', words: []));

  Future<void> addWord(WordEntity word) async {
    final updatedWords = List<WordEntity>.from(state.words)
      ..add(word);

    emit(
      state.copyWith(
        words: updatedWords,
      ),
    );
  }

  Future<void> deleteWord(WordEntity word) async {
    final updatedWords = List<WordEntity>.from(state.words)
      ..remove(word);

    emit(
      state.copyWith(
        words: updatedWords,
      ),
    );
  }


  bool isWord(WordEntity word){
    return state.words.contains(word);
  }

  Future<void> addListWord(List<WordEntity> words) async {
    words.addAll(words);
  }

  Future<void> pickExcelFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
        allowMultiple: false,
      );

      if (result == null) {
        print("null");
      }

      print(result?.files.first);

      emit(state.copyWith(
        file: result?.files.first
      ));

    } catch (e) {
      print('Pick excel error: $e');
    }
  }

  Future<bool> addWordFromFile(PlatformFile file) async {
    try {
      if (file.path == null) return false;

      final bytes = File(file.path!).readAsBytesSync();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);

      final List<WordEntity> importedWords = [];

      for (final table in decoder.tables.keys) {
        final sheet = decoder.tables[table]!;

        for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
          final row = sheet.rows[rowIndex];

          final vocab = row.isNotEmpty ? row[0]?.toString().trim() : '';
          final mean  = row.length > 1 ? row[1]?.toString().trim() : '';
          final read  = row.length > 2 ? row[2]?.toString().trim() : '';

          // row trống → bỏ
          if (vocab!.isEmpty && mean!.isEmpty && read!.isEmpty) continue;

          // chỉ 1 dòng lỗi → fail
          if (vocab.isEmpty || mean!.isEmpty) return false;

          final isExist = state.words.any(
                (e) =>
            e.word.trim().toLowerCase() == vocab.trim().toLowerCase() &&
                e.mean.trim().toLowerCase() == mean.trim().toLowerCase(),
          );

          if (!isExist) {
            importedWords.add(
              WordEntity(
                word: vocab,
                mean: mean,
                wayread: read ?? '',
              ),
            );
          }
        }
      }

      if (importedWords.isEmpty) return false;

      emit(
        state.copyWith(
          words: [...state.words, ...importedWords],
        ),
      );

      return true;
    } catch (e) {
      debugPrint('Import excel error: $e');
      return false;
    }
  }


}