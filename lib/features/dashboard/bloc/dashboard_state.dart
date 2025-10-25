import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';

abstract class DashboardState {}
class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final List<Map<String,dynamic>> topicsLocal;
  final List<Map<String,dynamic>> folders;
  final List topicServer; // raw or typed
  final UserModel userModel;
  DashboardLoaded({required this.userModel, required this.topicsLocal, required this.folders, required this.topicServer});
}
class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
