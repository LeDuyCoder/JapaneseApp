import 'package:japaneseapp/core/module/topic_module.dart';
import 'package:japaneseapp/core/service/Server/ServiceLocator.dart';
import 'package:japaneseapp/features/dashboard/domain/models/topic_model.dart';

class TabHomeRemoteDataSource {
  Future<List<TopicEntity>> fetchServerTopics(int limit) async {
    List<TopicModule> listTopicModule = await ServiceLocator.topicService.getAllDataTopic(limit);
    return listTopicModule.map((topic) => TopicEntity.fromJson(topic.toJson())).toList();
  }
}
