import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';

/// Base state cho **Community Topic Bloc/Cubit**.
///
/// Tất cả các state liên quan đến Community Topic
/// đều phải kế thừa từ lớp này.
abstract class CommunityTopicState {}

/// State khởi tạo ban đầu.
///
/// Thường được emit khi Bloc/Cubit vừa được tạo
/// và chưa thực hiện hành động nào.
class CommunityTopicInitial extends CommunityTopicState {}

/// State đang tải dữ liệu Community Topic.
///
/// Được emit khi đang gọi API hoặc xử lý dữ liệu.
class CommunityTopicLoaded extends CommunityTopicState {
  final List<CommunityTopicEntity> topics;

  CommunityTopicLoaded({required this.topics});
}

/// State tải dữ liệu Community Topic thành công.
///
/// Chứa danh sách [CommunityTopicEntity] đã được load.
class CommunityTopicLoading extends CommunityTopicState {}

/// State xảy ra lỗi khi tải hoặc xử lý Community Topic.
///
/// [message] dùng để mô tả nguyên nhân lỗi,
/// có thể hiển thị trực tiếp lên UI.
class CommunityTopicError extends CommunityTopicState {
  final String message;

  CommunityTopicError(this.message);
}

/// State không tìm thấy dữ liệu Community Topic.
///
/// Thường được sử dụng khi:
/// - Kết quả tìm kiếm rỗng
/// - Server không trả về dữ liệu phù hợp
class CommunityTopicNoFound extends CommunityTopicState{}