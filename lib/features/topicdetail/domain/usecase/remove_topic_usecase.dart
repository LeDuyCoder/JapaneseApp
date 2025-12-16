import 'package:japaneseapp/features/topicdetail/domain/repositories/topicdetails_repository.dart';

class removeTopicUsecase {
  final TopicDetailsRepository repository;

  removeTopicUsecase(this.repository);

  Future<void> call(String topicName) async {
    return await repository.removeTopic(topicName);
  }
}