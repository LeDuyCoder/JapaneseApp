// dart
  // File: `lib/manual_test.dart`
  import 'dart:async';

  /// Domain entity
  class WordEntity {
    final String word;
    final String definitionVi;
    final String exampleVi;

    WordEntity({
      required this.word,
      required this.definitionVi,
      required this.exampleVi,
    });

    @override
    String toString() =>
        'Từ: $word\nĐịnh nghĩa (Tiếng Việt): $definitionVi\nVí dụ (Tiếng Việt): $exampleVi';
  }

  /// Data model (extends domain entity)
  class WordModel extends WordEntity {
    WordModel({
      required String word,
      required String definitionVi,
      required String exampleVi,
    }) : super(word: word, definitionVi: definitionVi, exampleVi: exampleVi);

    factory WordModel.fromJson(Map<String, dynamic> json) {
      return WordModel(
        word: json['word'] as String? ?? '',
        definitionVi: json['definition_vi'] as String? ?? '',
        exampleVi: json['example_vi'] as String? ?? '',
      );
    }

    Map<String, dynamic> toJson() => {
          'word': word,
          'definition_vi': definitionVi,
          'example_vi': exampleVi,
        };
  }

  /// Pure-Dart remote datasource (returns Vietnamese fields)
  class DictionaryRemoteDataSourceImpl {
    Future<Map<String, dynamic>?> searchWord(String word) async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (word.trim().isEmpty) return null;
      return {
        'word': word,
        'definition_vi': 'Định nghĩa mẫu cho "$word".',
        'example_vi': 'Ví dụ: Tôi đã dùng "$word" trong câu này.',
      };
    }
  }

  /// Repository interface (domain)
  abstract class DictionaryRepository {
    Future<WordEntity?> searchWord(String word);
  }

  /// Repository implementation (converts model -> entity)
  class DictionaryRepositoryImpl implements DictionaryRepository {
    final DictionaryRemoteDataSourceImpl remoteDataSource;

    DictionaryRepositoryImpl({required this.remoteDataSource});

    @override
    Future<WordEntity?> searchWord(String word) async {
      final Map<String, dynamic>? data = await remoteDataSource.searchWord(word);
      if (data == null) return null;
      return WordModel.fromJson(data); // WordModel extends WordEntity
    }
  }

  /// Usecase
  class SearchWord {
    final DictionaryRepository repository;

    SearchWord(this.repository);

    Future<WordEntity?> call(String word) => repository.searchWord(word);
  }

  /// BLoC states
  abstract class DictionaryState {}

  class DictionaryInitial extends DictionaryState {}

  class DictionaryLoading extends DictionaryState {}

  class DictionaryLoaded extends DictionaryState {
    final WordEntity word;
    DictionaryLoaded(this.word);
  }

  class DictionaryError extends DictionaryState {
    final String message;
    DictionaryError(this.message);
  }

  /// Simple BLoC-like class (pure Dart)
  class DictionaryBloc {
    final SearchWord _searchWord;
    final _controller = StreamController<DictionaryState>.broadcast();

    Stream<DictionaryState> get stream => _controller.stream;
    DictionaryState _current = DictionaryInitial();

    DictionaryBloc(this._searchWord) {
      _controller.add(_current);
    }

    Future<void> search(String word) async {
      _controller.add(DictionaryLoading());
      try {
        final result = await _searchWord.call(word);
        if (result == null) {
          _controller.add(DictionaryError('Không tìm thấy kết quả cho "$word".'));
        } else {
          _controller.add(DictionaryLoaded(result));
        }
      } catch (e) {
        _controller.add(DictionaryError('Lỗi: ${e.toString()}'));
      }
    }

    void dispose() {
      _controller.close();
    }
  }

  Future<void> main() async {
    final remote = DictionaryRemoteDataSourceImpl();
    final repo = DictionaryRepositoryImpl(remoteDataSource: remote);
    final usecase = SearchWord(repo);
    final bloc = DictionaryBloc(usecase);

    final sub = bloc.stream.listen((state) {
      if (state is DictionaryInitial) {
        print('Ready.');
      } else if (state is DictionaryLoading) {
        print('Đang tìm kiếm...');
      } else if (state is DictionaryLoaded) {
        print(state.word.toString());
      } else if (state is DictionaryError) {
        print(state.message);
      }
    });

    // Simulate searches
    await bloc.search('hello');
    await Future.delayed(const Duration(milliseconds: 300));
    await bloc.search(''); // empty -> not found
    await Future.delayed(const Duration(milliseconds: 300));

    await sub.cancel();
    bloc.dispose();
  }