// dart
// File: lib/features/dictionary/data/repositories/dictionary_repository_impl.dart

import 'package:japaneseapp/features/dictionary/data/datasources/dictionary_remote_datasource.dart';
import 'package:japaneseapp/features/dictionary/data/models/word_model.dart';
import 'package:japaneseapp/features/dictionary/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/dictionary/domain/repositories/dictionary_repository.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryRemoteDataSourceImpl remoteDataSource;

  DictionaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WordEntity> searchWord(String word) async {
    final Map<String, dynamic>? data = await remoteDataSource.searchWord(word);
    if (data == null) {
      throw Exception('Word not found: $word');
    }
    return WordModel.fromJson(data);
  }

  @override
  Future<WordEntity> toggleBookmark(WordEntity word) async {
    return remoteDataSource.toggleBookmark(word);
  }
}