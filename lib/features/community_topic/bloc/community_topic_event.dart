/// Base event cho **Community Topic Bloc**.
///
/// Tất cả các event liên quan đến Community Topic
/// đều phải kế thừa từ lớp này.
abstract class CommynityTopicEvent {}

/// Event dùng để tải danh sách topic cộng đồng.
///
/// Khi event này được dispatch:
/// - Bloc sẽ gọi use case / repository
/// - Lấy danh sách topic theo [limit]
class LoadTopics extends CommynityTopicEvent {
  final int limit;

  LoadTopics({required this.limit});
}

/// Event dùng để tìm kiếm topic cộng đồng theo tên.
///
/// Khi event này được dispatch:
/// - Bloc sẽ thực hiện tìm kiếm topic
/// - Trả về danh sách topic phù hợp với [nameTopic]
class searchTopics extends CommynityTopicEvent {
  final String nameTopic;

  searchTopics({required this.nameTopic});
}