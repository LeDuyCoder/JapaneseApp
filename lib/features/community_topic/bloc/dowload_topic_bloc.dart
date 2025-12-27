import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/community_topic/bloc/dowload_topic_event.dart';
import 'package:japaneseapp/features/community_topic/bloc/dowload_topic_state.dart';
import 'package:japaneseapp/features/community_topic/domain/repositories/dowload_topic_repository.dart';

/// `DowloadTopicBloc` chịu trách nhiệm quản lý trạng thái
/// liên quan đến **tải (download) Topic** trong ứng dụng.
///
/// Bloc này đảm nhiệm 2 nhiệm vụ chính:
/// - Tải dữ liệu chi tiết của một topic từ repository
/// - Thực hiện quá trình download topic về thiết bị
///
/// Bloc làm việc với [DowloadTopicRepository] để xử lý dữ liệu
/// và phát ra các state tương ứng:
/// - [DowloadTopicWaiting]
/// - [DowloadTopicLoadState]
/// - [DowloadingTopic]
/// - [DowloadTopicSucces]
/// - [DowloadTopicError]
class DowloadTopicBloc extends Bloc<DowloadTopicEvent, DowloadTopicState>{

  /// Repository chịu trách nhiệm thao tác dữ liệu
  /// liên quan đến download topic (API, local DB, v.v.)
  final DowloadTopicRepository repository;

  /// Khởi tạo [DowloadTopicBloc] với [repository].
  ///
  /// State ban đầu là [DowloadTopicWaiting].
  DowloadTopicBloc(this.repository) : super(DowloadTopicWaiting()) {
    on<DowloadTopicLoad>(_onLoad);
    on<DowloadTopic>(_onDowload);
  }

  /// Xử lý sự kiện [DowloadTopicLoad].
  ///
  /// Sự kiện này dùng để **load dữ liệu topic** theo `topicId`
  /// trước khi thực hiện download.
  ///
  /// Luồng xử lý:
  /// 1. Gọi `repository.loadData`
  /// 2. Thành công → emit [DowloadTopicLoadState]
  /// 3. Thất bại → emit [DowloadTopicError]
  ///
  /// [event.topicId] là ID của topic cần tải dữ liệu.
  Future<void> _onLoad(DowloadTopicLoad event, Emitter<DowloadTopicState> emit) async {
    try{
      await repository.loadData(event.topicId).then((feachData){
        emit(DowloadTopicLoadState(dowloadTopicEntity: feachData));
      }).catchError((e){
        emit(DowloadTopicError(message: e.toString()));
      });
    }catch (e){
      emit(DowloadTopicError(message: e.toString()));
    }
  }

  /// Xử lý sự kiện [DowloadTopic].
  ///
  /// Sự kiện này thực hiện **quá trình download topic**.
  ///
  /// Luồng xử lý:
  /// 1. Emit [DowloadingTopic] để hiển thị trạng thái đang tải
  /// 2. Delay 3 giây (giả lập thời gian download)
  /// 3. Gọi `repository.dowload`
  /// 4. Thành công → emit [DowloadTopicSucces]
  /// 5. Thất bại → emit [DowloadTopicError]
  ///
  /// [event.dowloadTopicEntity] chứa dữ liệu topic cần download.
  Future<void> _onDowload(DowloadTopic event, Emitter<DowloadTopicState> emit) async {
    emit(DowloadingTopic());
    try {
      await Future.delayed(const Duration(seconds: 3));
      await repository.dowload(event.dowloadTopicEntity);
      emit(DowloadTopicSucces());
    } catch (e) {
      emit(DowloadTopicError(message: e.toString()));
    }
  }

}