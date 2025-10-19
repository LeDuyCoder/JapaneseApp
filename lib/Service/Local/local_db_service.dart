import 'package:japaneseapp/Service/Local/dao/ReadNotificationDao.dart';
import 'package:japaneseapp/Service/Local/dao/UserItemsDAO.dart';

import 'dao/DatabseDao.dart';
import 'dao/TopicDao.dart';
import 'dao/WordDao.dart';
import 'dao/FolderDao.dart';
import 'dao/CharacterDao.dart';
import 'dao/VocabularyDao.dart';
import 'dao/SyncDao.dart';
import 'dao/MiscDao.dart';
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
  final UserItemsDao userItemsDao;
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
        userItemsDao = UserItemsDao(),
        preferencesService = PreferencesService();
}
