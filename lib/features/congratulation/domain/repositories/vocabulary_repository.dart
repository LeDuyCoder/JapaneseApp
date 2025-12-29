/// Repository định nghĩa các hành vi liên quan đến
/// **quản lý và cập nhật tiến trình học từ vựng**.
///
/// Lớp này nằm ở **tầng domain**, chỉ mô tả contract
/// cho việc thao tác dữ liệu từ vựng,
/// không quan tâm dữ liệu được lưu ở đâu
/// (local database, remote API, file, v.v).
///
/// Các lớp triển khai (implementation) của repository
/// sẽ chịu trách nhiệm xử lý chi tiết
/// ở tầng data.
abstract class VocabularyRepository {
  /// Cập nhật level của một từ vựng.
  ///
  /// Thường được gọi sau khi người dùng
  /// trả lời đúng / sai hoặc hoàn thành
  /// một bài học liên quan đến từ vựng này.
  ///
  /// Tham số:
  /// - [word]: Nội dung từ vựng cần cập nhật
  /// - [topic]: Chủ đề của từ vựng
  /// - [level]: Level mới của từ vựng
  Future<void> updateWordLevel({
    required String word,
    required String topic,
    required int level,
  });
}
