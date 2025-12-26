
import 'package:equatable/equatable.dart';

enum AllFolderShowedType { list, grid }

class AllFolderState extends Equatable {
  final AllFolderShowedType showedType;

  const AllFolderState({required this.showedType});

  AllFolderState copyWith({AllFolderShowedType? showedType}) {
    return AllFolderState(
      showedType: showedType ?? this.showedType,
    );
  }

  @override
  List<Object?> get props => [showedType];
}