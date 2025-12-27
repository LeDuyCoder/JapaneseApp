import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';

/// Lớp cơ sở (abstract) cho tất cả các event
/// liên quan đến chức năng **download topic**.
///
/// Các event kế thừa từ lớp này sẽ được
/// [DowloadTopicBloc] lắng nghe và xử lý.
abstract class DowloadTopicEvent{}

/// Sự kiện dùng để **load dữ liệu chi tiết của topic**
/// dựa trên `topicId`.
///
/// Event này thường được gọi trước khi thực hiện
/// download topic để lấy đầy đủ thông tin cần thiết.
class DowloadTopicLoad extends DowloadTopicEvent{
  final String topicId;

  DowloadTopicLoad({required this.topicId});
}

/// Sự kiện dùng để **thực hiện download topic**.
///
/// Event này chứa toàn bộ dữ liệu cần thiết
/// để lưu topic về thiết bị hoặc database local.
class DowloadTopic extends DowloadTopicEvent{
  final DowloadTopicEntity dowloadTopicEntity;

  DowloadTopic({required this.dowloadTopicEntity});
}

