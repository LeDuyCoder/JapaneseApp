import 'package:audioplayers/audioplayers.dart';
import 'package:japaneseapp/core/Service/FunctionService.dart';

/// Interface định nghĩa các hành vi cơ bản
/// cho dịch vụ phát âm thanh trong ứng dụng.
///
/// Lớp này giúp tách biệt logic nghiệp vụ
/// khỏi thư viện audio cụ thể,
/// cho phép dễ dàng mock khi test
/// hoặc thay thế thư viện audio khác.
abstract class IAudioPlayerService {
  /// Phát một file âm thanh từ asset.
  ///
  /// [assetPath] là đường dẫn tới file audio
  /// được khai báo trong `pubspec.yaml`.
  Future<void> play(String assetPath);

  /// Dừng việc phát âm thanh hiện tại (nếu có).
  Future<void> stop();
}

/// Triển khai cụ thể của [IAudioPlayerService]
/// sử dụng thư viện `audioplayers`.
///
/// Lớp này chịu trách nhiệm:
/// - Tương tác trực tiếp với AudioPlayer
/// - Xử lý việc phát và dừng âm thanh từ asset
///
/// Nằm ở tầng **infrastructure / service**,
/// không chứa logic nghiệp vụ.
class AudioPlayerService implements IAudioPlayerService {
  /// Instance của AudioPlayer dùng để phát âm thanh
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Phát âm thanh từ asset.
  ///
  /// Nếu có lỗi xảy ra trong quá trình phát
  /// (ví dụ: file không tồn tại, lỗi engine audio),
  /// lỗi sẽ được bắt và bỏ qua để tránh crash ứng dụng.
  @override
  Future<void> play(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // Bỏ qua lỗi để đảm bảo ứng dụng không bị crash
      return;
    }
  }

  /// Dừng việc phát âm thanh hiện tại.
  ///
  /// Nếu không có âm thanh đang phát
  /// hoặc xảy ra lỗi, phương thức sẽ
  /// bắt lỗi và bỏ qua.
  @override
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      // Bỏ qua lỗi để đảm bảo ứng dụng không bị crash
      return;
    }
  }
}