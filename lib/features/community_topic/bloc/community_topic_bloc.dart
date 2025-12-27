import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/community_topic/bloc/community_topic_event.dart';
import 'package:japaneseapp/features/community_topic/bloc/community_topic_state.dart';

import 'package:japaneseapp/features/community_topic/domain/repositories/community_topic_repository.dart';

/// `CommunityTopicBloc` chịu trách nhiệm quản lý trạng thái (state)
/// liên quan đến **Community Topic** trong ứng dụng.
///
/// Bloc này xử lý các sự kiện:
/// - Tải danh sách topic cộng đồng
/// - Tìm kiếm topic theo tên
///
/// Bloc sẽ tương tác với [CommunityTopicRepository] để lấy dữ liệu
/// và phát ra các state tương ứng như:
/// - [CommunityTopicLoading]
/// - [CommunityTopicLoaded]
/// - [CommunityTopicNoFound]
/// - [CommunityTopicError]
class CommunityTopicBloc extends Bloc<CommynityTopicEvent, CommunityTopicState> {

  /// Repository dùng để thao tác với nguồn dữ liệu Community Topic
  /// (API, database, v.v.)
  final CommunityTopicRepository repository;

  /// Khởi tạo [CommunityTopicBloc] với [repository].
  ///
  /// State ban đầu là [CommunityTopicInitial].
  CommunityTopicBloc(this.repository) : super(CommunityTopicInitial()) {
    on<searchTopics>(_onSearchTopics);
    on<LoadTopics>(_onLoadTopics);
  }

  /// Xử lý sự kiện [searchTopics].
  ///
  /// Luồng xử lý:
  /// 1. Emit [CommunityTopicLoading]
  /// 2. Gọi `repository.searchTopics`
  /// 3. Nếu danh sách rỗng → emit [CommunityTopicNoFound]
  /// 4. Nếu có dữ liệu → emit [CommunityTopicLoaded]
  /// 5. Nếu lỗi → emit [CommunityTopicError]
  ///
  /// [event.nameTopic] là từ khóa tìm kiếm topic.
  void _onSearchTopics(searchTopics event, Emitter<CommunityTopicState> emit) async {
    emit(CommunityTopicLoading());
    try{
      await repository.searchTopics(event.nameTopic).then((fetchedTopics){
        if(fetchedTopics.isEmpty){
          emit(CommunityTopicNoFound());
        }else {
          emit(CommunityTopicLoaded(topics: fetchedTopics));
        }
      }).catchError((e){
        emit(CommunityTopicNoFound());
      });
    }catch(e){
      emit(CommunityTopicError(e.toString()));
    }
  }

  /// Xử lý sự kiện [LoadTopics].
  ///
  /// Dùng để tải danh sách topic cộng đồng với số lượng giới hạn.
  ///
  /// Luồng xử lý:
  /// 1. Emit [CommunityTopicLoading]
  /// 2. Gọi `repository.loadCommunityTopics`
  /// 3. Thành công → emit [CommunityTopicLoaded]
  /// 4. Lỗi → emit [CommunityTopicError]
  ///
  /// [event.limit] là số lượng topic cần tải.
  void _onLoadTopics(LoadTopics event, Emitter<CommunityTopicState> emit) async {
    emit(CommunityTopicLoading());
    try {
      await repository.loadCommunityTopics(event.limit).then((fetchedTopics) {
        emit(CommunityTopicLoaded(topics: fetchedTopics));
      }).catchError((e) {
        emit(CommunityTopicError(e.toString()));
      });
    } catch (e) {
      emit(CommunityTopicError(e.toString()));
    }
  }
}