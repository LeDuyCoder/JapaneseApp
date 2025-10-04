import 'package:japaneseapp/Service/Local/dao/readNotification_dao.dart';

import 'dao/databse_dao.dart';
import 'dao/topic_dao.dart';
import 'dao/word_dao.dart';
import 'dao/folder_dao.dart';
import 'dao/character_dao.dart';
import 'dao/vocabulary_dao.dart';
import 'dao/sync_dao.dart';
import 'dao/misc_dao.dart';
import 'preferences_service.dart';

/// Service tổng quản lý tất cả DAO + SharedPreferences.
/// Khi cần gọi DB local chỉ cần dùng [LocalDbService.instance]
class LocalDbService {
  static final LocalDbService instance = LocalDbService._init();

  final TopicDao topicDao;
  final WordDao wordDao;
  final FolderDao folderDao;
  final CharacterDao characterDao;
  final VocabularyDao vocabularyDao;
  final SyncDao syncDao;
  final MiscDao miscDao;
  final DatabseDao databseDao;
  final ReadnotificationDao readnotificationDao;
  final PreferencesService preferencesService;

  LocalDbService._init()
      : topicDao = TopicDao(),
        wordDao = WordDao(),
        folderDao = FolderDao(),
        characterDao = CharacterDao(),
        vocabularyDao = VocabularyDao(),
        syncDao = SyncDao(),
        miscDao = MiscDao(),
        databseDao = DatabseDao(),
        readnotificationDao = ReadnotificationDao(),
        preferencesService = PreferencesService();
}
