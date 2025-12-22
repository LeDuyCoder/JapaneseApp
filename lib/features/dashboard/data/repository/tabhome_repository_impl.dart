
import 'package:japaneseapp/features/dashboard/data/datasource/user_remote_data_source.dart';
import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';

import '../../domain/repository/tabhome_repository.dart';
import '../datasource/tabhome_local_data_source.dart';
import '../datasource/tabhome_remote_data_source.dart';

class TabHomeRepositoryImpl implements TabHomeRepository {
  final TabHomeLocalDataSource local;
  final TabHomeRemoteDataSource remote;
  final UserRemoteDataSource userRemoteDataSource;

  TabHomeRepositoryImpl({required this.userRemoteDataSource, required this.local, required this.remote});

  @override
  Future<Map<String, dynamic>> getTabHomeData() async {
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
      throw Exception(e);
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
