import 'package:japaneseapp/core/Service/Server/FrameAvatarService.dart';
import 'package:japaneseapp/core/Service/Server/TopicService.dart';
import 'package:japaneseapp/core/Service/Server/WordService.dart';

import 'NotificationService.dart';
import 'ScoreService.dart';
import 'UserService.dart';

class ServiceLocator {
  static final TopicService topicService = TopicService();
  static final WordService wordService = WordService();
  static final ScoreService scoreService = ScoreService();
  static final UserService userService = UserService();
  static final FrameAvatarService frameAvatarService = FrameAvatarService();
  static final Notificationservice notificationservice = Notificationservice();

  // Singleton pattern (optional)
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();
}
