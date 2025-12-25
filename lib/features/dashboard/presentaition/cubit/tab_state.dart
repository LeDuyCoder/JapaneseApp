import 'package:equatable/equatable.dart';

class TabState extends Equatable {
  final int index;
  final int reloadKey;

  const TabState(this.index, this.reloadKey);

  @override
  List<Object?> get props => [index, reloadKey];

  TabState copyWith({int? index, int? reloadKey}) {
    return TabState(index ?? this.index, reloadKey ?? this.reloadKey);
  }
}
