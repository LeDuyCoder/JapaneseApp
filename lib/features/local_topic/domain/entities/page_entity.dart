import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/local_topic/domain/entities/topic_entity.dart';

/// `PageEntity` đại diện cho **một trang (page) của danh sách topic**.
///
/// Entity này thường được sử dụng trong
/// các feature có **phân trang (pagination)**,
/// mỗi page chứa một tập các [TopicEntity].
class PageEntity extends Equatable{
  final int page;
  final List<TopicEntity> topicEntities;

  const PageEntity({required this.page, required this.topicEntities});

  @override
  List<Object?> get props => [page, topicEntities];

  PageEntity copyWith({int? page, List<TopicEntity>? topicEntities}){
    return PageEntity(
        page: page ?? this.page,
        topicEntities: topicEntities ?? this.topicEntities
    );
  }
}