import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Service/Local/dao/VocabularyDao.dart';
import 'package:japaneseapp/core/service/check_in/check_in_local_data_source.dart';
import 'package:japaneseapp/core/service/check_in/check_in_use_case.dart';
import 'package:japaneseapp/features/ads/services/ad_result.dart';
import 'package:japaneseapp/features/ads/services/rewarded_ad_service_impl.dart';
import 'package:japaneseapp/features/congratulation/data/datasource/character_local_datasource.dart';
import 'package:japaneseapp/features/congratulation/data/repositories/character_repository_impl.dart';
import 'package:japaneseapp/features/congratulation/domain/entities/character_enity.dart';
import 'package:japaneseapp/features/congratulation/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/congratulation/domain/enum/type_congratulation.dart';
import 'package:japaneseapp/features/congratulation/domain/repositories/character_repository.dart';
import 'package:japaneseapp/features/congratulation/domain/repositories/vocabulary_repository.dart';
import 'package:japaneseapp/features/congratulation/data/repositories/vocabulary_repository_impl.dart';
import 'package:japaneseapp/features/congratulation/domain/usecases/check_in_feature_use_case.dart';
import 'package:japaneseapp/features/congratulation/domain/usecases/update_vocabulary_progress_usecase.dart';
import 'package:japaneseapp/features/congratulation/bloc/congratulation_event.dart';
import 'package:japaneseapp/features/congratulation/bloc/congratulation_state.dart';
import 'package:japaneseapp/features/congratulation/domain/entities/user_progress.dart';
import 'package:japaneseapp/features/congratulation/domain/repositories/user_progress_repository.dart';
import 'package:japaneseapp/features/congratulation/domain/services/audio_player_service.dart';
import 'package:japaneseapp/features/congratulation/domain/services/reward_calculator.dart';
import 'package:japaneseapp/features/congratulation/domain/usecases/calculate_level_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// BLoC chịu trách nhiệm xử lý logic cho màn hình **Chúc mừng**
/// sau khi người dùng hoàn thành một bài học / bài kiểm tra.
///
/// [CongratulationBloc] đảm nhiệm các nghiệp vụ:
/// - Tính toán phần thưởng (coin, exp, exp rank)
/// - Cập nhật tiến trình người dùng
/// - Cập nhật tiến trình từ vựng
/// - Phát âm thanh hoàn thành
/// - Xử lý xem quảng cáo Rewarded để nhận thêm thưởng
///
/// BLoC này nằm ở **presentation layer** và
/// điều phối các UseCase / Service tương ứng,
/// UI chỉ cần lắng nghe state để hiển thị kết quả.
class CongratulationBloc extends Bloc<CongratulationEvent, CongratulationState>{

  /// Repository quản lý tiến trình người dùng
  final UserProgressRepository repo;

  /// Số câu trả lời đúng
  final int correctAnswer;

  /// Số câu trả lời sai
  final int incorrtAnswer;

  /// Tổng số câu hỏi
  final int totalQuestions;

  /// Service phát âm thanh (ví dụ: âm thanh hoàn thành)
  AudioPlayerService audioPlayerService = AudioPlayerService();

  /// Service tính toán phần thưởng (coin, exp, exp rank)
  RewardCalculator rewardCalculator = RewardCalculator();

  /// Khởi tạo [CongratulationBloc] với:
  /// - Repository tiến trình người dùng
  /// - Kết quả làm bài của người dùng
  ///
  /// Đăng ký các event:
  /// - [CongratulationStarted] để load dữ liệu ban đầu
  /// - [ShowAdsRewardEvent] để xử lý xem quảng cáo nhận thưởng
  CongratulationBloc(this.repo, this.correctAnswer, this.incorrtAnswer, this.totalQuestions) : super(CongratulationInitial()){
    on<CongratulationStarted>(_onLoad);
    on<ShowAdsRewardEvent>(_onShowAdsReward);
  }

  /// Xử lý sự kiện [CongratulationStarted].
  ///
  /// Luồng xử lý:
  /// 1. Emit trạng thái loading
  /// 2. Lấy tiến trình hiện tại của người dùng
  /// 3. Tính toán phần thưởng (coin, exp, exp rank)
  /// 4. Cập nhật tiến trình từ vựng
  /// 5. Cập nhật level, exp, coin cho người dùng
  /// 6. Cập nhật trạng thái check-in
  /// 7. Phát âm thanh hoàn thành
  /// 8. Emit trạng thái loaded với dữ liệu phần thưởng
  Future<void> _onLoad(CongratulationStarted event, Emitter emit) async {
    emit(CongratulationLoading());
    UserProgress progress = await repo.getProgress();

    int expRankPlus = rewardCalculator.calcExpRank(correct: correctAnswer, incorrect: incorrtAnswer, total: totalQuestions);
    int coin = rewardCalculator.calcCoin(correctAnswer, totalQuestions);
    int expPlus = rewardCalculator.calcLevelExp(progress.level, progress.nextExp - progress.exp);

    if(event.type == TypeCongratulation.vocabulary) {
      VocabularyRepository vocabularyRepository = VocabularyRepositoryImpl(
          VocabularyDao());
      await UpdateVocabularyProgressUseCase(vocabularyRepository).execute(
          event.words);
    }

    if(event.type == TypeCongratulation.character){
      CharacterRepository characterRepository = CharacterRepositoryImpl(
        characterLocalDatasource: CharacterLocalDatasource()
      );
      List<WordEntity> wordEntities = event.words;
      List<CharacterEntity> characters = [];
      for(WordEntity wordEntity in wordEntities){
        characters.add(
            CharacterEntity(
                character: wordEntity.word,
                romaji: wordEntity.wayread,
                examples: wordEntity.examples ?? [],
                pathImage: wordEntity.pathImage ?? "",
                level: wordEntity.level
            )
        );
      }

      characterRepository.updateProgressCharacterDB(event.typeTest.name, characters);
      characterRepository.updateProgressCharacterSharedFile(event.typeTest.name, 1);
    }

    await repo.saveProgress(CalculateLevelUseCase().call(current: progress, gainedExp: expPlus));
    await repo.addCoin(coin);
    await repo.addExpRank(expRankPlus);

    final prefs = await SharedPreferences.getInstance();
    final local = CheckInLocalDataSource(prefs);
    final useCase = CheckInUseCase(local);

    CheckInFeatureUseCase(useCase).execute();

    await audioPlayerService.play("sound/completed.mp3");
    emit(CongratulationLoaded(coin, expRankPlus, expPlus, level: progress.level, exp: progress.exp, nextExp: progress.nextExp));
  }

  /// Xử lý sự kiện [ShowAdsRewardEvent].
  ///
  /// Luồng xử lý:
  /// 1. Emit trạng thái loading khi xem quảng cáo
  /// 2. Hiển thị quảng cáo Rewarded
  /// 3. Nếu người dùng xem hết quảng cáo:
  ///    - Cộng thêm thưởng (coin)
  ///    - Emit lại trạng thái loaded với phần thưởng mới
  ///
  /// Nếu người dùng không xem hết quảng cáo,
  /// không có phần thưởng bổ sung.
  Future<void> _onShowAdsReward(ShowAdsRewardEvent event, Emitter emit) async {
    emit(CongratulationLoadingAds());
    AdResult watched = await RewardedAdServiceImpl().show();
    print("check watched ad result: $watched");
    UserProgress progress = await repo.getProgress();

    if(watched == AdResult.watched){
      repo.addCoin(event.coin);
      emit(CongratulationLoaded(event.coin * 2, event.expPlus, event.expRankPlus, level: progress.level, exp: progress.exp, nextExp: progress.nextExp));
    }
  }
}