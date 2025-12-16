import 'package:japaneseapp/features/topicdetail/data/datasources/topic_privacy_remote_datasource.dart';
import 'package:japaneseapp/features/topicdetail/domain/repositories/topic_privacy_repository.dart';

class TopicPrivacyRepositoryImpl extends TopicPrivacyRepository {
  final TopicPrivacyRemoteDataSourceImpl remoteDataSource;

  TopicPrivacyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> isTopicPrivate(String idTopic) async {
    return (await remoteDataSource.isTopicPrivate(idTopic));
  }

  @override
  Future<void> setTopicPrivacy(String idTopic, String nameTopic, bool isPrivate) {
    return remoteDataSource.setTopicPrivacy(idTopic, nameTopic);
  }


}