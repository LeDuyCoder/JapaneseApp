/// Base event cho các sự kiện liên quan đến
/// việc load topic trên thiết bị.
abstract class AllTopicEvent{}

/// Sự kiện dùng để load **toàn bộ danh sách topic**.
///
/// Được sử dụng khi cần hiển thị tất cả topic
/// mà không phân trang.
class LoadAllTopicEvent extends AllTopicEvent{}

/// Sự kiện dùng để load topic **theo dạng phân trang**.
///
/// [pageSize] xác định số lượng topic
/// trong mỗi trang.
class LoadAllTopicByPageEvent extends AllTopicEvent{
  final int pageSize;

  LoadAllTopicByPageEvent({required this.pageSize});
}