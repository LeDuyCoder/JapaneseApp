import '../entities/word_entity.dart';
import '../repositories/dictionary_repository.dart';

class SearchWord {
  final DictionaryRepository repo;
  SearchWord(this.repo);

  Future<WordEntity> call(String query) {
    return repo.searchWord(query);
  }
}
