
import 'package:japaneseapp/features/congratulation/domain/entities/character_example.dart';

/// Entity đại diện cho **một từ vựng** trong ứng dụng.
///
/// [WordEntity] được sử dụng ở tầng **domain** để mô tả
/// thông tin cốt lõi của một từ vựng, bao gồm:
/// - Nội dung từ
/// - Nghĩa của từ
/// - Cách đọc
/// - Chủ đề
/// - Level (mức độ ghi nhớ / học tập)
///
/// Entity này là đối tượng bất biến (immutable),
/// không phụ thuộc vào database, API hay UI.
class WordEntity {
  /// Nội dung từ vựng
  final String word;

  /// Nghĩa của từ
  final String mean;

  /// Cách đọc của từ
  final String wayread;

  /// Chủ đề mà từ vựng thuộc về
  final String topic;

  /// Level hiện tại của từ vựng
  final int level;

  final List<CharacterExample>? examples;
  final String? pathImage;

  /// Khởi tạo một [WordEntity] với đầy đủ thông tin.
  WordEntity({
    required this.word,
    required this.mean,
    required this.wayread,
    required this.topic,
    required this.level,
    this.examples,
    this.pathImage
  });

  /// Chuyển [WordEntity] thành Map (JSON).
  ///
  /// Thường được sử dụng khi:
  /// - Lưu dữ liệu vào database
  /// - Gửi dữ liệu qua API
  Map<String, dynamic> toJson() {
    return {
      "word": word,
      "mean": mean,
      "wayread": wayread,
      "topic": topic,
      "level": level,
    };
  }

  /// Tạo một [WordEntity] từ Map (JSON).
  ///
  /// Thường được sử dụng khi:
  /// - Đọc dữ liệu từ database
  /// - Parse response từ API
  factory WordEntity.fromJson(Map<String, dynamic> json) {
    return WordEntity(
      word: json['word'],
      mean: json['mean'],
      wayread: json['wayread'],
      topic: json['topic'],
      level: json['level'],
    );
  }
}