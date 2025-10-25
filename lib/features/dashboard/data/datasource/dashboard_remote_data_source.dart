import 'package:japaneseapp/core/Module/topic.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';

class DashboardRemoteDataSource {
  Future<List<topic>> fetchServerTopics(int limit) async {
    return await ServiceLocator.topicService.getAllDataTopic(limit);
  }

// fetch topic by id, fetch word by topic...
}
