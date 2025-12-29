import 'package:japaneseapp/features/congratulation/domain/repositories/vocabulary_repository.dart';

import 'package:japaneseapp/features/congratulation/domain/entities/word_entity.dart';

/// UseCase dùng để **cập nhật tiến trình học từ vựng**
/// sau khi người dùng hoàn thành một bài học / bài kiểm tra.
///
/// Luồng xử lý:
/// - Duyệt qua danh sách các [WordEntity]
/// - Tăng level của từng từ vựng lên `1`
/// - Level tối đa được giới hạn ở `28`
///
/// UseCase này chỉ chứa logic nghiệp vụ,
/// không quan tâm dữ liệu được lưu ở đâu
/// (database, API, local storage, v.v),
/// và tương tác với dữ liệu thông qua [VocabularyRepository].
class UpdateVocabularyProgressUseCase {
  /// Repository quản lý dữ liệu từ vựng
  final VocabularyRepository repository;

  /// Khởi tạo [UpdateVocabularyProgressUseCase]
  /// với một [VocabularyRepository].
  UpdateVocabularyProgressUseCase(this.repository);

  /// Thực thi use case cập nhật level từ vựng.
  ///
  /// Với mỗi từ trong [words]:
  /// - Nếu `level < 28` → tăng level lên `1`
  /// - Nếu `level >= 28` → giữ nguyên level hiện tại
  ///
  /// Thường được gọi sau khi người dùng
  /// hoàn thành bài học hoặc bài kiểm tra.
  Future<void> execute(List<WordEntity> words) async {
    for (final word in words) {
      final nextLevel = word.level < 28 ? word.level + 1 : word.level;

      await repository.updateWordLevel(
        word: word.word,
        topic: word.topic,
        level: nextLevel,
      );
    }
  }
}
