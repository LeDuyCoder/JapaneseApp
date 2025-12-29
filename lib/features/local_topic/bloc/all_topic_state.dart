import 'package:japaneseapp/features/local_topic/domain/entities/topic_entity.dart';
import 'package:japaneseapp/features/local_topic/domain/entities/page_entity.dart';

/// Base state cho các trạng thái liên quan đến
/// việc hiển thị danh sách topic trên thiết bị.
abstract class AllTopicState{}

/// Trạng thái khởi tạo ban đầu của [AllTopicBloc].
///
/// Thường được emit khi Bloc vừa được tạo
/// và chưa thực hiện load dữ liệu.
class AllTopicIntial extends AllTopicState{}

/// Trạng thái load **toàn bộ danh sách topic** thành công.
///
/// [topics] chứa danh sách các topic
/// được load từ repository.
class LoadedAllTopicState extends AllTopicState{
  final List<TopicEntity> topics;

  LoadedAllTopicState({required this.topics});
}

/// Trạng thái load topic **theo dạng phân trang** thành công.
///
/// [pages] chứa danh sách các page,
/// mỗi page bao gồm một tập topic.
class LoadedByPageAllTopicState extends AllTopicState{
  final List<PageEntity> pages;

  LoadedByPageAllTopicState({required this.pages});
}

/// Trạng thái đang load dữ liệu topic.
///
/// Thường dùng để hiển thị loading indicator
/// hoặc skeleton UI.
class LoadingAllTopicState extends AllTopicState{}

/// Trạng thái xảy ra lỗi trong quá trình load topic.
///
/// [message] mô tả chi tiết lỗi.
class ErrorAllTopicState extends AllTopicState{
  final String message;

  ErrorAllTopicState({required this.message});
}
