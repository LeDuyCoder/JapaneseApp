import 'package:japaneseapp/features/dashboard/data/datasource/user_remote_data_source.dart';
import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';

import '../../domain/repository/dashboard_repository.dart';
import '../datasource/dashboard_local_data_source.dart';
import '../datasource/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource local;
  final DashboardRemoteDataSource remote;
  final UserRemoteDataSource userRemoteDataSource;

  DashboardRepositoryImpl({required this.userRemoteDataSource, required this.local, required this.remote});

  @override
  Future<Map<String, dynamic>> getDashboardData() async {
    final topicLocal = await local.getTopics(); // return List<Map>
    final folders = await local.getFolders();
    Map<String, dynamic> res = {
      'topic': topicLocal,
      'folder': folders.map((f) => {
        'id': f.id,
        'namefolder': f.name,
        'datefolder': f.dateCreated,
        'amountTopic': f.amountTopic,
      }).toList(),
    };
    try {
      final topicServer = await remote.fetchServerTopics(5);
      res['topicServer'] = topicServer;
    } catch (e) {
      throw Exception();
    }
    return res;
  }

  @override
  Future<bool> downloadTopic(String id) async {
    return true;
  }

  @override
  Future<UserModel> getUserInfo() async {
    return await userRemoteDataSource.getUserData();
  }
}
