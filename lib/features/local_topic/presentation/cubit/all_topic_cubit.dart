import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/local_topic/presentation/cubit/all_topic_cubit_state.dart';

/// `AllTopicCubit` quản lý trạng thái **trang hiện tại**
/// của danh sách topic khi phân trang.
///
/// Cubit này đơn giản, chỉ cần lưu `page` và cập nhật khi người dùng
/// chọn trang mới.
class AllTopicCubit extends Cubit<AllTopicCubitState>{

  /// Khởi tạo cubit với trạng thái ban đầu.
  ///
  /// Mặc định `page = 1`.
  AllTopicCubit() : super(const AllTopicCubitState(page: 1));

  /// Cập nhật trang hiện tại.
  ///
  /// Khi gọi phương thức này, cubit sẽ emit một state mới
  /// với `page` được cập nhật.
  void updatePage(int page){
    emit(state.copyWith(page));
  }
}