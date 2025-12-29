import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/local_topic/bloc/all_topic_event.dart';
import 'package:japaneseapp/features/local_topic/bloc/all_topic_state.dart';
import 'package:japaneseapp/features/local_topic/domain/repositories/topic_repository.dart';
import 'package:japaneseapp/features/local_topic/domain/entities/topic_entity.dart';

/// `AllTopicBloc` chịu trách nhiệm quản lý trạng thái
/// **danh sách topic trên thiết bị**.
///
/// Bloc này hỗ trợ:
/// - Load toàn bộ topic
/// - Load topic theo dạng phân trang
///
/// Dữ liệu được lấy thông qua [TopicRepository].
class AllTopicBloc extends Bloc<AllTopicEvent, AllTopicState>{

  /// Repository xử lý dữ liệu topic (local / database)
  final TopicRepository repository;

  /// Khởi tạo [AllTopicBloc] với [repository].
  ///
  /// Trạng thái ban đầu là [AllTopicIntial].
  AllTopicBloc({required this.repository}) : super(AllTopicIntial()) {
    on<LoadAllTopicEvent>(_onLoadAllTopic);
    on<LoadAllTopicByPageEvent>(_onLoadAllTopicByPage);
  }

  /// Xử lý sự kiện [LoadAllTopicEvent].
  ///
  /// - Emit [LoadingAllTopicState] khi bắt đầu load
  /// - Lấy toàn bộ topic từ repository
  Future<void> _onLoadAllTopic(LoadAllTopicEvent event, Emitter<AllTopicState> emit) async {
    emit(LoadingAllTopicState());
    List<TopicEntity> data = await repository.loadAllTopic();
    await Future.delayed(const Duration(seconds: 1));
    emit(LoadedAllTopicState(topics: data));
  }

  /// Xử lý sự kiện [LoadAllTopicByPageEvent].
  ///
  /// - Emit [LoadingAllTopicState]
  /// - Load danh sách topic theo phân trang
  /// - Emit [LoadedByPageAllTopicState] khi thành công
  Future<void> _onLoadAllTopicByPage(LoadAllTopicByPageEvent event, Emitter<AllTopicState> emit) async {
    emit(LoadingAllTopicState());
    final data = await repository.loadTopicByPage(event.pageSize);
    await Future.delayed(const Duration(seconds: 1));
    emit(LoadedByPageAllTopicState(pages: data));
  }
}