import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';

abstract class TabHomeState {}
class TabHomeInitial extends TabHomeState {}
class TabHomeLoading extends TabHomeState {}
class TabHomeLoaded extends TabHomeState {
  final List<Map<String,dynamic>> topicsLocal;
  final List<Map<String,dynamic>> folders;
  final List topicServer; // raw or typed
  final UserModel userModel;
  TabHomeLoaded({required this.userModel, required this.topicsLocal, required this.folders, required this.topicServer});
}
class TabHomeError extends TabHomeState {
  final String message;
  TabHomeError(this.message);
}
