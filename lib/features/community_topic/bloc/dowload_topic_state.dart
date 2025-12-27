import 'package:japaneseapp/features/community_topic/domain/entities/dowload_topic_entity.dart';

/// Lớp cơ sở (abstract) cho tất cả các state
/// liên quan đến chức năng **download topic**.
///
/// Các state này được phát ra bởi [DowloadTopicBloc]
/// để cập nhật UI tương ứng.
abstract class DowloadTopicState{}

/// State ban đầu của [DowloadTopicBloc].
///
/// Biểu thị trạng thái **đang chờ**
/// (chưa load dữ liệu, chưa download).
class DowloadTopicWaiting extends DowloadTopicState{}

/// State biểu thị **đã load thành công dữ liệu topic**.
///
/// Thường được emit sau khi gọi `loadData`
/// và trước khi thực hiện download.
class DowloadTopicLoadState extends DowloadTopicState{
  final DowloadTopicEntity dowloadTopicEntity;

  DowloadTopicLoadState({required this.dowloadTopicEntity});
}

/// State biểu thị **đang thực hiện download topic**.
///
/// UI có thể hiển thị loading / progress indicator.
class DowloadingTopic extends DowloadTopicState{}

/// State biểu thị **download topic thành công**.
///
/// Thường dùng để:
/// - Hiển thị thông báo thành công
/// - Điều hướng sang màn hình khác
class DowloadTopicSucces extends DowloadTopicState{}

/// State biểu thị **có lỗi xảy ra** trong quá trình
/// load hoặc download topic.
class DowloadTopicError extends DowloadTopicState{
  final String message;

  DowloadTopicError({required this.message});
}