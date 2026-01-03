import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/rank/domain/entities/user_entity.dart';

class RankEntity extends Equatable{
  final String? perriorRank;
  final UserEntity userEntity;

  const RankEntity({required this.perriorRank, required this.userEntity});

  @override
  List<Object?> get props => [perriorRank, userEntity];
}