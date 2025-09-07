import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get tabbar_home => 'Главная';

  @override
  String get tabber_distionary => 'Словарь';

  @override
  String get tabbar_character => 'Алфавит';

  @override
  String get tabbar_info => 'Информация';

  @override
  String get dashboard_folder => 'Мои папки';

  @override
  String get dashboard_folder_seemore => 'Смотреть все';

  @override
  String get dashboard_folder_content => 'темы';

  @override
  String get dashboard_folder_nodata_title => 'Папок нет';

  @override
  String get dashboard_folder_nodata_content => 'Создайте первую папку для организации слов';

  @override
  String get dashboard_comunication => 'Сообщество';

  @override
  String get dashboard_comunication_seemore => 'Смотреть все';

  @override
  String course_owner(String user_nane) {
    return '$user_nane';
  }

  @override
  String amount_word(String amount) {
    return '$amount';
  }

  @override
  String get topic_persent => 'Процент';

  @override
  String get topic_word_finish => 'Завершено';

  @override
  String get topic_word_learning => 'Не завершено';

  @override
  String get add_course => 'Учебный блок';

  @override
  String get add_folder => 'Папка';

  @override
  String get folderSeemore_title => 'Мои папки';

  @override
  String get folderSeemore_grid => 'Сетка';

  @override
  String get folderSeemore_tag_flex => 'Список';

  @override
  String get folderSeemore_content => 'Все папки';

  @override
  String get folderSeemore_subContent => 'Папка';

  @override
  String get folderManager_nodata_title => 'Начните создавать свои папки';

  @override
  String get folderManager_nodata_button => 'Добавить тему обучения';

  @override
  String get folderManager_bottomSheet_addTopic => 'Добавить тему обучения';

  @override
  String get folderManager_bottomSheet_removeFolder => 'Удалить';

  @override
  String get folderManager_topic_bottomSheet_remove => 'Удалить из папки';

  @override
  String get folderManager_Screen_addTopic_title => 'Добавить тему учебного блока';

  @override
  String folderManager_Screen_addTopic_card_owner(String name) {
    return 'Автор: $name';
  }

  @override
  String folderManager_Screen_addTopic_card_amountWord(int amount) {
    return 'Количество слов: $amount';
  }

  @override
  String get comunication_bottomSheet_notify_download_title => 'Хотите скачать?';

  @override
  String get comunication_bottomSheet_notify_download_btn => 'Скачать';

  @override
  String get download_Screen_downloading_title => 'Загрузка темы';

  @override
  String get download_Screen_downloading_contetnt => 'Пожалуйста, подождите...';

  @override
  String get download_Screen_downloading_btn => 'Отмена';

  @override
  String get download_Screen_Success_title => 'Загрузка успешна';

  @override
  String get download_Screen_Success_contetnt => 'Тема готова к изучению';

  @override
  String get download_Screen_Success_btn => 'Начать изучение';

  @override
  String get dashboard_topic_nodata_title => 'Тем нет';

  @override
  String get dashboard_topic_nodata_content => 'Создайте первую тему для начала обучения';

  @override
  String get communication_Screen_title => 'Сообщество';

  @override
  String get communication_Screen_hint_search => 'Введите название темы...';

  @override
  String get communication_Screen_subTitle => 'Коллекция сообщества';

  @override
  String get dashboard_topic => 'Мои темы';

  @override
  String get dashboard_topic_seemore => 'Смотреть все';

  @override
  String get topic_seemore_title => 'Мои темы';

  @override
  String get topic_seemore_subTitle => 'Темы';

  @override
  String get bottomSheet_add_topic => 'Учебный блок';

  @override
  String get bottomSheet_add_folder => 'Папка';

  @override
  String get popup_add_topic => 'Добавить новую тему';

  @override
  String get popup_add_topic_hint => 'Название темы';

  @override
  String get popup_add_topic_exit => 'Тема с таким названием уже существует';

  @override
  String get popup_add_topic_btn_create => 'Создать';

  @override
  String get popup_add_topic_btn_cancle => 'Отмена';

  @override
  String get addWord_Screen_Input_Japan_Label => 'Японские слова';

  @override
  String get addWord_Screen_Input_Japan_Hint => 'Японское слово';

  @override
  String get addWord_Screen_Input_WayRead_Label => 'Чтение (Хирагана)';

  @override
  String get addWord_Screen_Input_WayRead_Hint => 'Чтение';

  @override
  String get addWord_Screen_Input_Mean_Label => 'Значение слова';

  @override
  String get addWord_Screen_Input_Mean_Hint => 'Значение';

  @override
  String get addWord_Screen_btn_add => 'Добавить слово';

  @override
  String get addWord_bottomShet_warning_save_title => 'Внимание';

  @override
  String get addWord_bottomShet_warning_save_content => 'После сохранения редактирование невозможно';

  @override
  String get addWord_bottomShet_warning_save_btn => 'Сохранить';

  @override
  String get addWord_bottomShet_success_save_title => 'Сохранение успешно';

  @override
  String get addWord_bottomShet_success_save_content => 'Ваша тема успешно создана 🎉';

  @override
  String get addWord_bottomShet_success_save_btn => 'ОК';

  @override
  String get listword_Screen_title => 'Темы';

  @override
  String get listword_Screen_AmountWord => 'Слова';

  @override
  String get listword_Screen_Learned => 'Выучено';

  @override
  String get listword_Screen_head_col1 => 'Японский';

  @override
  String get listword_Screen_head_col2 => 'Значение';

  @override
  String get listword_Screen_head_col3 => 'Статус';

  @override
  String get listword_Screen_bottomSheet_public_title => 'Хотите поделиться?';

  @override
  String get listword_Screen_bottomSheet_public_content => 'После публикации любой сможет скачать';

  @override
  String get listword_Screen_bottomSheet_public_btn_pulic => 'Публично';

  @override
  String get listword_Screen_bottomSheet_public_btn_cancel => 'Отмена';

  @override
  String get listword_Screen_bottomSheet_public_succes_title => 'Поздравляем';

  @override
  String get listword_Screen_bottomSheet_public_succes_content => 'Вы успешно поделились темой';

  @override
  String get listword_Screen_bottomSheet_public_succes_btn_ok => 'ОК';

  @override
  String get listword_Screen_bottomSheet_private_title => 'Хотите отменить публикацию?';

  @override
  String get listword_Screen_bottomSheet_private_btn_private => 'Отменить публикацию';

  @override
  String get listword_Screen_bottomSheet_private_btn_cancel => 'Нет';

  @override
  String get listword_Screen_bottomSheet_private_success_title => 'Публикация отменена';

  @override
  String get listword_Screen_bottomSheet_private_success_content => 'Вы отменили публикацию темы';

  @override
  String get listword_Screen_bottomSheet_private_success_OK => 'ОК';

  @override
  String get listword_Screen_btn_learn => 'Учить сейчас';

  @override
  String get keyboard_handwriting_btn_space => 'Пробел';

  @override
  String get keyboard_handwriting_btn_remove => 'Удалить';

  @override
  String get distionary_Screen_title => 'Японский словарь';

  @override
  String get distionary_Screen_hint => 'Введите слово для поиска';

  @override
  String get distionary_Screen_hint_title => 'Поиск слова';

  @override
  String get distionary_Screen_hint_content => 'Начните искать и учить слова';

  @override
  String get distionary_Screen_mean => 'Значение слова';

  @override
  String get distionary_Screen_info => 'Информация о слове';

  @override
  String get distionary_Screen_type => 'Существительное: ';

  @override
  String get distionary_Screen_level => 'Уровень: ';

  @override
  String get popup_remove_topic_title => 'Удалить тему';

  @override
  String get popup_remove_topic_content => 'Вы уверены, что хотите удалить?';

  @override
  String get popup_remove_topic_btn_cancle => 'Отмена';

  @override
  String get popup_remove_topic_btn_delete => 'Удалить';

  @override
  String get character_btn_learn => 'Учить буквы';

  @override
  String listWord_word_complete(String count) {
    return 'Завершено $count';
  }

  @override
  String listWord_word_learning(String count) {
    return 'Не завершено $count';
  }

  @override
  String get listWord_btn_learn => 'Учить слова';

  @override
  String listWord_share_title(String topic) {
    return 'Название темы $topic';
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
  String get learn_warningGboard => 'Рекомендуется использовать Gboard для лучшего опыта';

  @override
  String get learn_btn_check => 'Проверить';

  @override
  String get learn_bottomsheet_wrong_title => 'Неверно';

  @override
  String get learn_bottomsheet_wrong_content => 'Правильный ответ';

  @override
  String get learn_bottomsheet_wrong_btn => 'Продолжить';

  @override
  String get learn_write_input => 'Написать';

  @override
  String get learn_bottomsheet_right_title => 'Правильно';

  @override
  String get motivationalPhrases_1 => 'Продолжайте стараться, вы делаете отлично!';

  @override
  String get motivationalPhrases_2 => 'В этот раз идеально, продолжайте в том же духе!';

  @override
  String get motivationalPhrases_3 => 'Каждый шаг — это прогресс!';

  @override
  String get motivationalPhrases_4 => 'Верьте в себя и продолжайте стараться!';

  @override
  String get motivationalPhrases_5 => 'Вы можете это сделать, никогда не сдавайтесь!';

  @override
  String get motivationalPhrases_6 => 'Успех приходит к тем, кто не перестает пытаться!';

  @override
  String get motivationalPhrases_7 => 'Постепенно улучшайте себя!';

  @override
  String get motivationalPhrases_8 => 'Будьте сильными, сосредоточенными и продолжайте двигаться вперед!';

  @override
  String get motivationalPhrases_9 => 'Отличные усилия! Ставьте более высокие цели!';

  @override
  String get motivationalPhrases_10 => 'Ваш труд скоро будет вознагражден!';

  @override
  String get learn_bottomsheet_right_btn => 'Продолжить';

  @override
  String get learning_combine_title => 'Соедините слова из колонки A с колонкой B';

  @override
  String get learn_translate_title => 'Переведите предложение ниже';

  @override
  String get learn_listen_title => 'Что вы услышали';

  @override
  String get learn_chose_title => 'Выберите правильное слово';

  @override
  String get congraculate_title => 'Завершено';

  @override
  String get congraculate_content => 'Вы великолепны';

  @override
  String get congraculate_commited => 'Время';

  @override
  String get congraculate_amzing => 'Прекрасно';

  @override
  String get profile_level => 'Уровень';

  @override
  String get profile_topic => 'Темы';

  @override
  String get profile_title => 'Звание';

  @override
  String get levelTitles_1 => 'Студент';

  @override
  String get levelTitles_2 => 'Мудрец';

  @override
  String get levelTitles_3 => 'Мыслитель';

  @override
  String get levelTitles_4 => 'Учёный';

  @override
  String get levelTitles_5 => 'Академик';

  @override
  String get levelTitles_6 => 'Литературный гений';

  @override
  String get levelTitles_7 => 'Мудрый человек';

  @override
  String get levelTitles_8 => 'Гений дебатов';

  @override
  String get levelTitles_9 => 'Мастер учения';

  @override
  String get levelTitles_10 => 'Учёный литератор';

  @override
  String get levelTitles_11 => 'Студент-практик';

  @override
  String get levelTitles_12 => 'Эрудит';

  @override
  String get levelTitles_13 => 'Глубокий философ';

  @override
  String get levelTitles_14 => 'Утончённый человек';

  @override
  String get levelTitles_15 => 'Талантливый человек';

  @override
  String profile_date(int month, int year) {
    return '$month месяц $year год';
  }

  @override
  String get setting_title => 'Настройки';

  @override
  String get setting_achivement_title => 'Достижения';

  @override
  String get setting_achivement_content => 'Список достигнутых достижений';

  @override
  String get setting_language_title => 'Язык';

  @override
  String get setting_language_content => 'Выберите язык интерфейса';

  @override
  String get setting_async_title => 'Синхронизация данных';

  @override
  String get setting_async_content => 'Синхронизировать данные в облако';

  @override
  String get setting_downloadAsync_title => 'Скачать данные';

  @override
  String get setting_downloadAsync_content => 'Скачать данные, синхронизированные ранее';

  @override
  String get setting_signout_title => 'Выйти';

  @override
  String get setting_signout_content => 'Выйти из текущей учетной записи';

  @override
  String get achivement_title_one => 'Достижения';

  @override
  String get achivement_owl_title => 'Ночная сова';

  @override
  String get achivement_owl_description => 'Учиться с 0 до 2 часов ночи';

  @override
  String get achivement_tryhard_title => 'Трудолюбивый ученый';

  @override
  String get achivement_tryhard_description => 'Учиться с 4 до 6 утра';

  @override
  String get achivement_habit_title => 'Формирование привычки';

  @override
  String get achivement_habit_description => 'Учиться 28 дней подряд';

  @override
  String get achivement_title_two => 'Серия дней обучения';

  @override
  String achivement_streak_title(String day) {
    return 'Серия $day дней';
  }

  @override
  String achivement_streak_description(String day) {
    return 'Получено за $day дней обучения подряд';
  }

  @override
  String get achivement_title_three => 'Завершенные темы';

  @override
  String achivement_topic_title(String amount) {
    return '$amount Тем';
  }

  @override
  String achivement_topic_description(String amount) {
    return 'Получено за завершение $amount тем';
  }

  @override
  String get bottomSheetAsync_Success_Description => 'Данные успешно синхронизированы';

  @override
  String get bottomSheetAsync_Success_Btn => 'ОК';

  @override
  String get bottomSheet_Nointernet_title => 'Нет подключения к интернету';

  @override
  String get bottomSheet_Nointernet_Description => 'Пожалуйста, проверьте подключение и попробуйте снова';

  @override
  String get bottomSheet_Nointernet_Btn => 'ОК';

  @override
  String get bottomSheet_Error_title => 'Ошибка загрузки данных';

  @override
  String get bottomSheet_Error_description => 'Нет данных для синхронизации';

  @override
  String get bottomSheet_Warning_title => 'Внимание';

  @override
  String get bottomSheet_Warning_Description => 'Синхронизация удалит все данные на этом устройстве';

  @override
  String get bottomSheet_Warning_btn_ok => 'ОК';

  @override
  String get bottomSheet_Warning_btn_cancle => 'Отмена';

  @override
  String get language_title => 'Язык';

  @override
  String get language_bottomsheet_success => 'Язык успешно обновлен';

  @override
  String get error_connect_server => 'Ошибка соединения с сервером';

  @override
  String get login_title => 'С возвращением, рады вас видеть';

  @override
  String get login_email_input_hint => 'Эл. почта';

  @override
  String get login_email_input_hint_focus => 'Введите вашу эл. почту';

  @override
  String get login_email_input_password => 'Пароль';

  @override
  String get login_email_input_password_hint => 'Введите пароль';

  @override
  String get login_btn => 'Войти';

  @override
  String get login_create_question_account => 'Нет аккаунта?';

  @override
  String get login_create_btn_account => 'Регистрация';

  @override
  String get login_with_facebook => 'Войти через Facebook';

  @override
  String get login_with_google => 'Войти через Google';

  @override
  String get login_invalid_email => 'Неверная эл. почта';

  @override
  String get login_user_disabled => 'Аккаунт заблокирован';

  @override
  String get login_user_not_found => 'Аккаунт с этой эл. почтой не найден';

  @override
  String get login_wrong_password => 'Неверный пароль';

  @override
  String get login_error => 'Произошла ошибка';

  @override
  String get register_title => 'Здравствуйте, зарегистрируйтесь для начала';

  @override
  String get register_email_input_hint => 'Эл. почта';

  @override
  String get register_email_input_hint_focus => 'Введите эл. почту';

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
  String get register_re_password_input_hint_focus => 'Повторите пароль';

  @override
  String get register_btn => 'Зарегистрироваться';

  @override
  String get register_question_login => 'Уже есть аккаунт?';

  @override
  String get register_btn_login => 'Войти';

  @override
  String get register_email_already_in_use => 'Эта эл. почта уже используется';

  @override
  String get register_invalid_email => 'Неверный адрес эл. почты';

  @override
  String get register_operation_not_allowed => 'Эл. почта/пароль не активированы';

  @override
  String get register_weak_password => 'Слабый пароль';

  @override
  String get register_error => 'Произошла ошибка';

  @override
  String get register_success => 'Аккаунт создан успешно, возвращение к входу';
}
