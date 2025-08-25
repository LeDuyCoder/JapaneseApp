import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get tabbar_home => 'Главная';

  @override
  String get tabbar_character => 'Алфавит';

  @override
  String get tabbar_info => 'Информация';

  @override
  String get dashboard_hintSearch => 'Слово, которое вы хотите найти';

  @override
  String get dashboard_folder => 'Папка';

  @override
  String get dashboard_course => 'Курс';

  @override
  String get dashboard_topic => 'тема';

  @override
  String get dashboard_popupDownload_title => 'Хотите скачать?';

  @override
  String get dashboard_popupDownload_btn_cancel => 'Отмена';

  @override
  String get dashboard_popupDownload_btn_dowload => 'Скачать';

  @override
  String get dashboard_seemore => 'Показать больше';

  @override
  String get dashboard_btn_import => 'Импорт';

  @override
  String get tutorial_one_title => 'Установите приложение';

  @override
  String get tutorial_one_content => 'Убедитесь, что приложение Gboard установлено на вашем устройстве';

  @override
  String get tutorial_two_title => 'Откройте Настройки';

  @override
  String get tutorial_two_content => 'Откройте приложение Настройки и настройте японскую рукописную клавиатуру';

  @override
  String get tutorial_three_title => 'Найдите Gboard';

  @override
  String get tutorial_three_content => 'Найдите Gboard и нажмите, как показано на изображении';

  @override
  String get tutorial_four_title => 'Gboard';

  @override
  String get tutorial_four_content => 'Продолжайте нажимать согласно инструкции';

  @override
  String get tutorial_five_title => 'Языки';

  @override
  String get tutorial_five_content => 'Нажмите на раздел языков';

  @override
  String get tutorial_six_title => 'Добавить клавиатуру';

  @override
  String get tutorial_six_content => 'Добавьте клавиатуру и выберите японский';

  @override
  String get tutorial_seven_title => 'Поиск японского';

  @override
  String get tutorial_seven_content => 'Поиск японского языка';

  @override
  String get tutorial_eight_title => 'Рукописный ввод';

  @override
  String get tutorial_eight_content => 'Выберите рукописную клавиатуру и нажмите Готово';

  @override
  String get tutorial_nice_title => 'Смена клавиатуры';

  @override
  String get tutorial_nice_content => 'При обучении письму переключайтесь на клавиатуру, чтобы лучше запоминать';

  @override
  String get tutorial_btn_back => 'Назад';

  @override
  String get tutorial_btn_forward => 'Вперед';

  @override
  String get tutorial_btn_skip => 'Пропустить';

  @override
  String get tutorial_one_done => 'Готово';

  @override
  String course_owner(String user_nane) {
    return 'создано $user_nane';
  }

  @override
  String amount_word(String amount) {
    return 'Количество: $amount слов';
  }

  @override
  String word_finish(String amount) {
    return 'Завершено: $amount';
  }

  @override
  String word_learning(String amount) {
    return 'Не завершено: $amount';
  }

  @override
  String get add_course => 'Курс';

  @override
  String get add_folder => 'Папка';

  @override
  String get folderManager => 'Добавить тему курса';

  @override
  String get folderManager_addTopic => 'Добавить тему';

  @override
  String get folderManager_remove => 'Удалить';

  @override
  String get folderManager_removeTopic => 'Удалить из папки';

  @override
  String get seemore_search => 'Название папки';

  @override
  String get import_title => 'Выберите способ импорта';

  @override
  String get import_btn_file => 'Из файла';

  @override
  String get import_btn_qr => 'С помощью QR';

  @override
  String get character_btn_learn => 'Изучать буквы';

  @override
  String listWord_word_complete(String count) {
    return 'Завершено $count';
  }

  @override
  String listWord_word_learning(String count) {
    return 'Не завершено $count';
  }

  @override
  String get listWord_btn_learn => 'Изучать слова';

  @override
  String listWord_share_title(String topic) {
    return 'Название темы: $topic';
  }

  @override
  String listWord_share_amount_word(String amount) {
    return 'Количество: $amount слов';
  }

  @override
  String listWord_share_type(String type) {
    return 'Тип: $type';
  }

  @override
  String get listWord_btn_remove => 'Удалить';

  @override
  String get listWord_btn_shared => 'Поделиться';

  @override
  String get learn_warningGboard => 'Рекомендуется использовать Gboard для наилучшего опыта';

  @override
  String get learn_btn_check => 'Проверить';

  @override
  String get learn_bottomsheet_wrong_title => 'Неверно';

  @override
  String get learn_bottomsheet_wrong_content => 'Правильный ответ:';

  @override
  String get learn_bottomsheet_wrong_btn => 'Продолжить';

  @override
  String get learn_write_input => 'Писать';

  @override
  String get learn_bottomsheet_right_title => 'Правильно';

  @override
  String get motivationalPhrases_1 => 'Продолжайте в том же духе, вы отлично справляетесь!';

  @override
  String get motivationalPhrases_2 => 'На этот раз вы справились идеально, продолжайте!';

  @override
  String get motivationalPhrases_3 => 'Каждый шаг — это прогресс!';

  @override
  String get motivationalPhrases_4 => 'Верьте в себя и продолжайте стараться!';

  @override
  String get motivationalPhrases_5 => 'Вы сможете это сделать, никогда не сдавайтесь!';

  @override
  String get motivationalPhrases_6 => 'Успех приходит к тем, кто не перестает пытаться!';

  @override
  String get motivationalPhrases_7 => 'Продвигайтесь вперед шаг за шагом!';

  @override
  String get motivationalPhrases_8 => 'Будьте сильными, сосредоточенными и двигайтесь вперед!';

  @override
  String get motivationalPhrases_9 => 'Отличные усилия! Стремитесь к большему!';

  @override
  String get motivationalPhrases_10 => 'Ваш труд обязательно окупится!';

  @override
  String get learn_bottomsheet_right_btn => 'Продолжить';

  @override
  String get learning_combine_title => 'Сопоставьте слова из столбца А со столбцом B';

  @override
  String get learn_translate_title => 'Переведите предложение ниже';

  @override
  String get learn_listen_title => 'Что вы услышали?';

  @override
  String get learn_chose_title => 'Какое слово правильное?';

  @override
  String get congraculate_title => 'Завершено';

  @override
  String get congraculate_content => 'Вы великолепны';

  @override
  String get congraculate_commited => 'Время';

  @override
  String get congraculate_amzing => 'Отлично';

  @override
  String get profile_level => 'Уровень';

  @override
  String get profile_topic => 'Тема';

  @override
  String get profile_title => 'Звание';

  @override
  String get levelTitles_1 => 'Ученый';

  @override
  String get levelTitles_2 => 'Мудрец';

  @override
  String get levelTitles_3 => 'Мыслитель';

  @override
  String get levelTitles_4 => 'Почетный ученый';

  @override
  String get levelTitles_5 => 'Академический ученый';

  @override
  String get levelTitles_6 => 'Гений литературы';

  @override
  String get levelTitles_7 => 'Святой';

  @override
  String get levelTitles_8 => 'Гений дебатов';

  @override
  String get levelTitles_9 => 'Мастер обучения';

  @override
  String get levelTitles_10 => 'Литературный джентльмен';

  @override
  String get levelTitles_11 => 'Дисциплинированный ученый';

  @override
  String get levelTitles_12 => 'Просветленный';

  @override
  String get levelTitles_13 => 'Глубокий мудрец';

  @override
  String get levelTitles_14 => 'Элегантный наставник';

  @override
  String get levelTitles_15 => 'Гений интеллекта';

  @override
  String profile_date(int month, int year) {
    return '$month месяц $year год';
  }

  @override
  String get setting_title => 'Настройки';

  @override
  String get setting_achivement_title => 'Достижения';

  @override
  String get setting_achivement_content => 'Список полученных достижений';

  @override
  String get setting_language_title => 'Язык';

  @override
  String get setting_language_content => 'Выберите язык интерфейса';

  @override
  String get setting_async_title => 'Синхронизация данных';

  @override
  String get setting_async_content => 'Синхронизация данных с облаком';

  @override
  String get setting_downloadAsync_title => 'Загрузить данные';

  @override
  String get setting_downloadAsync_content => 'Загрузите данные, синхронизированные с предыдущего устройства';

  @override
  String get setting_signout_title => 'Выйти';

  @override
  String get setting_signout_content => 'Выйти из текущей учетной записи';

  @override
  String get achivement_title_one => 'Достижения';

  @override
  String get achivement_owl_title => 'Ночной совенок';

  @override
  String get achivement_owl_description => 'Учился с 0 до 2 часов ночи';

  @override
  String get achivement_tryhard_title => 'Усердный ученик';

  @override
  String get achivement_tryhard_description => 'Учился с 4 до 6 утра';

  @override
  String get achivement_habit_title => 'Создание привычки';

  @override
  String get achivement_habit_description => 'Учился 28 дней подряд';

  @override
  String get achivement_title_two => 'Серия дней обучения';

  @override
  String achivement_streak_title(String day) {
    return 'Серия $day дней';
  }

  @override
  String achivement_streak_description(String day) {
    return 'Достижение за $day дней подряд';
  }

  @override
  String get achivement_title_three => 'Завершенные темы';

  @override
  String achivement_topic_title(String amount) {
    return '$amount тем';
  }

  @override
  String achivement_topic_description(String amount) {
    return 'Достижение за завершение $amount тем';
  }

  @override
  String get bottomSheetAsync_Success_Description => 'Данные успешно синхронизированы';

  @override
  String get bottomSheetAsync_Success_Btn => 'OK';

  @override
  String get bottomSheet_Nointernet_title => 'Нет подключения к интернету';

  @override
  String get bottomSheet_Nointernet_Description => 'Проверьте подключение к интернету и повторите попытку';

  @override
  String get bottomSheet_Nointernet_Btn => 'OK';

  @override
  String get bottomSheet_Warning_title => 'Предупреждение';

  @override
  String get bottomSheet_Warning_Description => 'При синхронизации все локальные данные на этом устройстве будут удалены';

  @override
  String get bottomSheet_Warning_btn_ok => 'OK';

  @override
  String get bottomSheet_Warning_btn_cancle => 'Отмена';

  @override
  String get bottomSheet_Error_title => 'Ошибка загрузки данных';

  @override
  String get bottomSheet_Error_description => 'В настоящее время нет доступных синхронизированных данных';

  @override
  String get language_title => 'Язык';

  @override
  String get language_bottomsheet_success => 'Язык успешно обновлен';

  @override
  String get error_connect_server => 'Ошибка подключения к серверу';

  @override
  String get login_title => 'С возвращением! Рады вас видеть';

  @override
  String get login_email_input_hint => 'Электронная почта';

  @override
  String get login_email_input_hint_focus => 'Введите вашу электронную почту';

  @override
  String get login_email_input_password => 'Пароль';

  @override
  String get login_email_input_password_hint => 'Введите пароль';

  @override
  String get login_btn => 'Войти';

  @override
  String get login_create_question_account => 'Нет учетной записи?';

  @override
  String get login_create_btn_account => 'Регистрация';

  @override
  String get login_with_facebook => 'Войти через Facebook';

  @override
  String get login_with_google => 'Войти через Google';

  @override
  String get login_invalid_email => 'Неверный адрес электронной почты';

  @override
  String get login_user_disabled => 'Эта учетная запись отключена';

  @override
  String get login_user_not_found => 'Учетная запись с этим адресом не найдена';

  @override
  String get login_wrong_password => 'Неверный пароль';

  @override
  String get login_error => 'Произошла ошибка';

  @override
  String get register_title => 'Здравствуйте, зарегистрируйтесь, чтобы начать';

  @override
  String get register_email_input_hint => 'Электронная почта';

  @override
  String get register_email_input_hint_focus => 'Введите вашу электронную почту';

  @override
  String get register_user_input_hint => 'Имя пользователя';

  @override
  String get register_user_input_hint_focus => 'Введите имя пользователя';

  @override
  String get register_password_input_hint => 'Пароль';

  @override
  String get register_password_input_hint_focus => 'Введите пароль';

  @override
  String get register_re_password_input_hint => 'Повторите пароль';

  @override
  String get register_re_password_input_hint_focus => 'Повторно введите пароль';

  @override
  String get register_btn => 'Регистрация';

  @override
  String get register_question_login => 'Уже есть аккаунт?';

  @override
  String get register_btn_login => 'Войти';

  @override
  String get register_email_already_in_use => 'Этот адрес электронной почты уже зарегистрирован';

  @override
  String get register_invalid_email => 'Неверный адрес электронной почты';

  @override
  String get register_operation_not_allowed => 'Вход по email/паролю не разрешен';

  @override
  String get register_weak_password => 'Слишком слабый пароль';

  @override
  String get register_error => 'Произошла ошибка';

  @override
  String get register_success => 'Аккаунт успешно создан, вернитесь на страницу входа';
}
