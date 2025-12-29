import 'package:equatable/equatable.dart';

/// Trạng thái của [AllTopicCubit].
///
/// Chỉ lưu thông tin **trang hiện tại** (page) trong pagination.
class AllTopicCubitState extends Equatable{
  final int page;

  const AllTopicCubitState({required this.page});

  @override
  List<Object?> get props => [page];

  AllTopicCubitState copyWith(int? page){
    return AllTopicCubitState(page: page ?? this.page);
  }

}