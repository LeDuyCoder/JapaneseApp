import 'package:japaneseapp/features/topicdetail/domain/repositories/topicdetails_repository.dart';

class OpenQuizCardUseCase {
  final TopicDetailsRepository repository;

  OpenQuizCardUseCase(this.repository);

  Future<void> call(String quizCardId) async {
    await repository.openQuizCard(quizCardId);
  }
}