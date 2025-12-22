import 'package:japaneseapp/core/Service/Local/dao/VocabularyDao.dart';
import 'package:japaneseapp/features/congratulation/data/repositories/vocabulary_repository.dart';

/// Triển khai (implementation) của [VocabularyRepository].
///
/// Lớp này nằm ở **tầng data**, chịu trách nhiệm
/// tương tác trực tiếp với tầng lưu trữ cục bộ
/// thông qua [VocabularyDao].
///
/// [VocabularyRepositoryImpl] chuyển các yêu cầu
/// từ domain layer thành các thao tác cụ thể
/// trên cơ sở dữ liệu (ví dụ: SQLite).
class VocabularyRepositoryImpl implements VocabularyRepository {

  /// DAO dùng để thao tác dữ liệu từ vựng trong database
  final VocabularyDao dao;

  /// Khởi tạo [VocabularyRepositoryImpl] với
  /// một instance của [VocabularyDao].
  VocabularyRepositoryImpl(this.dao);

  /// Cập nhật level của một từ vựng trong cơ sở dữ liệu.
  ///
  /// Phương thức này sẽ:
  /// - Xác định từ vựng theo [word] và [topic]
  /// - Cập nhật giá trị `level` mới
  ///
  /// Việc xác định điều kiện cập nhật
  /// được thực hiện ở tầng data,
  /// domain layer không cần quan tâm chi tiết này.
  @override
  Future<void> updateWordLevel({
    required String word,
    required String topic,
    required int level,
  }) {
    return dao.update(
      "words",
      {"level": level},
      "word = '$word' AND topic = '$topic'",
    );
  }
}
