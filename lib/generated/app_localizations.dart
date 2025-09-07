import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ru'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @tabbar_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabbar_home;

  /// No description provided for @tabber_distionary.
  ///
  /// In en, this message translates to:
  /// **'Dictionary'**
  String get tabber_distionary;

  /// No description provided for @tabbar_character.
  ///
  /// In en, this message translates to:
  /// **'Alphabet'**
  String get tabbar_character;

  /// No description provided for @tabbar_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get tabbar_info;

  /// No description provided for @dashboard_folder.
  ///
  /// In en, this message translates to:
  /// **'My Folders'**
  String get dashboard_folder;

  /// No description provided for @dashboard_folder_seemore.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get dashboard_folder_seemore;

  /// No description provided for @dashboard_folder_content.
  ///
  /// In en, this message translates to:
  /// **'topics'**
  String get dashboard_folder_content;

  /// No description provided for @dashboard_folder_nodata_title.
  ///
  /// In en, this message translates to:
  /// **'No folders yet'**
  String get dashboard_folder_nodata_title;

  /// No description provided for @dashboard_folder_nodata_content.
  ///
  /// In en, this message translates to:
  /// **'Create your first folder to organize your vocabulary'**
  String get dashboard_folder_nodata_content;

  /// No description provided for @dashboard_comunication.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get dashboard_comunication;

  /// No description provided for @dashboard_comunication_seemore.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get dashboard_comunication_seemore;

  /// No description provided for @course_owner.
  ///
  /// In en, this message translates to:
  /// **'{user_nane}'**
  String course_owner(String user_nane);

  /// No description provided for @amount_word.
  ///
  /// In en, this message translates to:
  /// **'{amount}'**
  String amount_word(String amount);

  /// No description provided for @topic_persent.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get topic_persent;

  /// No description provided for @topic_word_finish.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get topic_word_finish;

  /// No description provided for @topic_word_learning.
  ///
  /// In en, this message translates to:
  /// **'Not Completed'**
  String get topic_word_learning;

  /// No description provided for @add_course.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get add_course;

  /// No description provided for @add_folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get add_folder;

  /// No description provided for @folderSeemore_title.
  ///
  /// In en, this message translates to:
  /// **'My Folders'**
  String get folderSeemore_title;

  /// No description provided for @folderSeemore_grid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get folderSeemore_grid;

  /// No description provided for @folderSeemore_tag_flex.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get folderSeemore_tag_flex;

  /// No description provided for @folderSeemore_content.
  ///
  /// In en, this message translates to:
  /// **'All folders'**
  String get folderSeemore_content;

  /// No description provided for @folderSeemore_subContent.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folderSeemore_subContent;

  /// No description provided for @folderManager_nodata_title.
  ///
  /// In en, this message translates to:
  /// **'Start creating your own folder'**
  String get folderManager_nodata_title;

  /// No description provided for @folderManager_nodata_button.
  ///
  /// In en, this message translates to:
  /// **'Add learning topic'**
  String get folderManager_nodata_button;

  /// No description provided for @folderManager_bottomSheet_addTopic.
  ///
  /// In en, this message translates to:
  /// **'Add Learning Topic'**
  String get folderManager_bottomSheet_addTopic;

  /// No description provided for @folderManager_bottomSheet_removeFolder.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get folderManager_bottomSheet_removeFolder;

  /// No description provided for @folderManager_topic_bottomSheet_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove from folder'**
  String get folderManager_topic_bottomSheet_remove;

  /// No description provided for @folderManager_Screen_addTopic_title.
  ///
  /// In en, this message translates to:
  /// **'Add Course Topic'**
  String get folderManager_Screen_addTopic_title;

  /// No description provided for @folderManager_Screen_addTopic_card_owner.
  ///
  /// In en, this message translates to:
  /// **'author: {name}'**
  String folderManager_Screen_addTopic_card_owner(String name);

  /// No description provided for @folderManager_Screen_addTopic_card_amountWord.
  ///
  /// In en, this message translates to:
  /// **'words: {amount}'**
  String folderManager_Screen_addTopic_card_amountWord(int amount);

  /// No description provided for @comunication_bottomSheet_notify_download_title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to download?'**
  String get comunication_bottomSheet_notify_download_title;

  /// No description provided for @comunication_bottomSheet_notify_download_btn.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get comunication_bottomSheet_notify_download_btn;

  /// No description provided for @download_Screen_downloading_title.
  ///
  /// In en, this message translates to:
  /// **'Downloading Topic'**
  String get download_Screen_downloading_title;

  /// No description provided for @download_Screen_downloading_contetnt.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment...'**
  String get download_Screen_downloading_contetnt;

  /// No description provided for @download_Screen_downloading_btn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get download_Screen_downloading_btn;

  /// No description provided for @download_Screen_Success_title.
  ///
  /// In en, this message translates to:
  /// **'Download Successful'**
  String get download_Screen_Success_title;

  /// No description provided for @download_Screen_Success_contetnt.
  ///
  /// In en, this message translates to:
  /// **'The topic is ready to learn'**
  String get download_Screen_Success_contetnt;

  /// No description provided for @download_Screen_Success_btn.
  ///
  /// In en, this message translates to:
  /// **'Start learning'**
  String get download_Screen_Success_btn;

  /// No description provided for @dashboard_topic_nodata_title.
  ///
  /// In en, this message translates to:
  /// **'No topics yet'**
  String get dashboard_topic_nodata_title;

  /// No description provided for @dashboard_topic_nodata_content.
  ///
  /// In en, this message translates to:
  /// **'Create your first topic to start learning'**
  String get dashboard_topic_nodata_content;

  /// No description provided for @communication_Screen_title.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communication_Screen_title;

  /// No description provided for @communication_Screen_hint_search.
  ///
  /// In en, this message translates to:
  /// **'Enter topic name...'**
  String get communication_Screen_hint_search;

  /// No description provided for @communication_Screen_subTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Collection'**
  String get communication_Screen_subTitle;

  /// No description provided for @dashboard_topic.
  ///
  /// In en, this message translates to:
  /// **'My Topics'**
  String get dashboard_topic;

  /// No description provided for @dashboard_topic_seemore.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get dashboard_topic_seemore;

  /// No description provided for @topic_seemore_title.
  ///
  /// In en, this message translates to:
  /// **'My Topics'**
  String get topic_seemore_title;

  /// No description provided for @topic_seemore_subTitle.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topic_seemore_subTitle;

  /// No description provided for @bottomSheet_add_topic.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get bottomSheet_add_topic;

  /// No description provided for @bottomSheet_add_folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get bottomSheet_add_folder;

  /// No description provided for @popup_add_topic.
  ///
  /// In en, this message translates to:
  /// **'Add New Topic'**
  String get popup_add_topic;

  /// No description provided for @popup_add_topic_hint.
  ///
  /// In en, this message translates to:
  /// **'Topic Name'**
  String get popup_add_topic_hint;

  /// No description provided for @popup_add_topic_exit.
  ///
  /// In en, this message translates to:
  /// **'Topic Name Already Exists'**
  String get popup_add_topic_exit;

  /// No description provided for @popup_add_topic_btn_create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get popup_add_topic_btn_create;

  /// No description provided for @popup_add_topic_btn_cancle.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get popup_add_topic_btn_cancle;

  /// No description provided for @addWord_Screen_Input_Japan_Label.
  ///
  /// In en, this message translates to:
  /// **'Japanese Vocabulary'**
  String get addWord_Screen_Input_Japan_Label;

  /// No description provided for @addWord_Screen_Input_Japan_Hint.
  ///
  /// In en, this message translates to:
  /// **'Japanese word'**
  String get addWord_Screen_Input_Japan_Hint;

  /// No description provided for @addWord_Screen_Input_WayRead_Label.
  ///
  /// In en, this message translates to:
  /// **'Reading (Hiragana)'**
  String get addWord_Screen_Input_WayRead_Label;

  /// No description provided for @addWord_Screen_Input_WayRead_Hint.
  ///
  /// In en, this message translates to:
  /// **'reading'**
  String get addWord_Screen_Input_WayRead_Hint;

  /// No description provided for @addWord_Screen_Input_Mean_Label.
  ///
  /// In en, this message translates to:
  /// **'Word Meaning'**
  String get addWord_Screen_Input_Mean_Label;

  /// No description provided for @addWord_Screen_Input_Mean_Hint.
  ///
  /// In en, this message translates to:
  /// **'meaning'**
  String get addWord_Screen_Input_Mean_Hint;

  /// No description provided for @addWord_Screen_btn_add.
  ///
  /// In en, this message translates to:
  /// **'Add Word'**
  String get addWord_Screen_btn_add;

  /// No description provided for @addWord_bottomShet_warning_save_title.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get addWord_bottomShet_warning_save_title;

  /// No description provided for @addWord_bottomShet_warning_save_content.
  ///
  /// In en, this message translates to:
  /// **'Once saved, it cannot be edited'**
  String get addWord_bottomShet_warning_save_content;

  /// No description provided for @addWord_bottomShet_warning_save_btn.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get addWord_bottomShet_warning_save_btn;

  /// No description provided for @addWord_bottomShet_success_save_title.
  ///
  /// In en, this message translates to:
  /// **'Saved Successfully'**
  String get addWord_bottomShet_success_save_title;

  /// No description provided for @addWord_bottomShet_success_save_content.
  ///
  /// In en, this message translates to:
  /// **'The topic you created has been successfully saved 🎉'**
  String get addWord_bottomShet_success_save_content;

  /// No description provided for @addWord_bottomShet_success_save_btn.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get addWord_bottomShet_success_save_btn;

  /// No description provided for @listword_Screen_title.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get listword_Screen_title;

  /// No description provided for @listword_Screen_AmountWord.
  ///
  /// In en, this message translates to:
  /// **'vocabulary'**
  String get listword_Screen_AmountWord;

  /// No description provided for @listword_Screen_Learned.
  ///
  /// In en, this message translates to:
  /// **'learned'**
  String get listword_Screen_Learned;

  /// No description provided for @listword_Screen_head_col1.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get listword_Screen_head_col1;

  /// No description provided for @listword_Screen_head_col2.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get listword_Screen_head_col2;

  /// No description provided for @listword_Screen_head_col3.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get listword_Screen_head_col3;

  /// No description provided for @listword_Screen_bottomSheet_public_title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to share?'**
  String get listword_Screen_bottomSheet_public_title;

  /// No description provided for @listword_Screen_bottomSheet_public_content.
  ///
  /// In en, this message translates to:
  /// **'When shared, anyone can download'**
  String get listword_Screen_bottomSheet_public_content;

  /// No description provided for @listword_Screen_bottomSheet_public_btn_pulic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get listword_Screen_bottomSheet_public_btn_pulic;

  /// No description provided for @listword_Screen_bottomSheet_public_btn_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get listword_Screen_bottomSheet_public_btn_cancel;

  /// No description provided for @listword_Screen_bottomSheet_public_succes_title.
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get listword_Screen_bottomSheet_public_succes_title;

  /// No description provided for @listword_Screen_bottomSheet_public_succes_content.
  ///
  /// In en, this message translates to:
  /// **'You have successfully shared your topic'**
  String get listword_Screen_bottomSheet_public_succes_content;

  /// No description provided for @listword_Screen_bottomSheet_public_succes_btn_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get listword_Screen_bottomSheet_public_succes_btn_ok;

  /// No description provided for @listword_Screen_bottomSheet_private_title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to cancel sharing?'**
  String get listword_Screen_bottomSheet_private_title;

  /// No description provided for @listword_Screen_bottomSheet_private_btn_private.
  ///
  /// In en, this message translates to:
  /// **'Unshare'**
  String get listword_Screen_bottomSheet_private_btn_private;

  /// No description provided for @listword_Screen_bottomSheet_private_btn_cancel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get listword_Screen_bottomSheet_private_btn_cancel;

  /// No description provided for @listword_Screen_bottomSheet_private_success_title.
  ///
  /// In en, this message translates to:
  /// **'Unshared Successfully'**
  String get listword_Screen_bottomSheet_private_success_title;

  /// No description provided for @listword_Screen_bottomSheet_private_success_content.
  ///
  /// In en, this message translates to:
  /// **'You have unshared your topic'**
  String get listword_Screen_bottomSheet_private_success_content;

  /// No description provided for @listword_Screen_bottomSheet_private_success_OK.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get listword_Screen_bottomSheet_private_success_OK;

  /// No description provided for @listword_Screen_btn_learn.
  ///
  /// In en, this message translates to:
  /// **'Learn Now'**
  String get listword_Screen_btn_learn;

  /// No description provided for @keyboard_handwriting_btn_space.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get keyboard_handwriting_btn_space;

  /// No description provided for @keyboard_handwriting_btn_remove.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get keyboard_handwriting_btn_remove;

  /// No description provided for @distionary_Screen_title.
  ///
  /// In en, this message translates to:
  /// **'Japanese Dictionary'**
  String get distionary_Screen_title;

  /// No description provided for @distionary_Screen_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter word to search'**
  String get distionary_Screen_hint;

  /// No description provided for @distionary_Screen_hint_title.
  ///
  /// In en, this message translates to:
  /// **'Search Vocabulary'**
  String get distionary_Screen_hint_title;

  /// No description provided for @distionary_Screen_hint_content.
  ///
  /// In en, this message translates to:
  /// **'Start searching and learning your words'**
  String get distionary_Screen_hint_content;

  /// No description provided for @distionary_Screen_mean.
  ///
  /// In en, this message translates to:
  /// **'Word Meaning'**
  String get distionary_Screen_mean;

  /// No description provided for @distionary_Screen_info.
  ///
  /// In en, this message translates to:
  /// **'Word Info'**
  String get distionary_Screen_info;

  /// No description provided for @distionary_Screen_type.
  ///
  /// In en, this message translates to:
  /// **'Noun: '**
  String get distionary_Screen_type;

  /// No description provided for @distionary_Screen_level.
  ///
  /// In en, this message translates to:
  /// **'Level: '**
  String get distionary_Screen_level;

  /// No description provided for @popup_remove_topic_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Topic'**
  String get popup_remove_topic_title;

  /// No description provided for @popup_remove_topic_content.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete?'**
  String get popup_remove_topic_content;

  /// No description provided for @popup_remove_topic_btn_cancle.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get popup_remove_topic_btn_cancle;

  /// No description provided for @popup_remove_topic_btn_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get popup_remove_topic_btn_delete;

  /// No description provided for @character_btn_learn.
  ///
  /// In en, this message translates to:
  /// **'Learn Alphabet'**
  String get character_btn_learn;

  /// number of completed words
  ///
  /// In en, this message translates to:
  /// **'Completed {count}'**
  String listWord_word_complete(String count);

  /// number of uncompleted words
  ///
  /// In en, this message translates to:
  /// **'Not Completed {count}'**
  String listWord_word_learning(String count);

  /// No description provided for @listWord_btn_learn.
  ///
  /// In en, this message translates to:
  /// **'Learn Words'**
  String get listWord_btn_learn;

  /// topic name
  ///
  /// In en, this message translates to:
  /// **'Topic name {topic}'**
  String listWord_share_title(String topic);

  /// word count
  ///
  /// In en, this message translates to:
  /// **'Total: {amount} words'**
  String listWord_share_amount_word(String amount);

  /// Share type
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String listWord_share_type(String type);

  /// No description provided for @listWord_btn_remove.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get listWord_btn_remove;

  /// No description provided for @listWord_btn_shared.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get listWord_btn_shared;

  /// No description provided for @learn_warningGboard.
  ///
  /// In en, this message translates to:
  /// **'It is recommended to use Gboard for the best experience'**
  String get learn_warningGboard;

  /// No description provided for @learn_btn_check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get learn_btn_check;

  /// No description provided for @learn_bottomsheet_wrong_title.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get learn_bottomsheet_wrong_title;

  /// No description provided for @learn_bottomsheet_wrong_content.
  ///
  /// In en, this message translates to:
  /// **'The correct answer is'**
  String get learn_bottomsheet_wrong_content;

  /// No description provided for @learn_bottomsheet_wrong_btn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get learn_bottomsheet_wrong_btn;

  /// No description provided for @learn_write_input.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get learn_write_input;

  /// No description provided for @learn_bottomsheet_right_title.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get learn_bottomsheet_right_title;

  /// No description provided for @motivationalPhrases_1.
  ///
  /// In en, this message translates to:
  /// **'Keep going, you\'re doing great!'**
  String get motivationalPhrases_1;

  /// No description provided for @motivationalPhrases_2.
  ///
  /// In en, this message translates to:
  /// **'Perfect this time, keep it up!'**
  String get motivationalPhrases_2;

  /// No description provided for @motivationalPhrases_3.
  ///
  /// In en, this message translates to:
  /// **'Every step forward is progress!'**
  String get motivationalPhrases_3;

  /// No description provided for @motivationalPhrases_4.
  ///
  /// In en, this message translates to:
  /// **'Believe in yourself and keep trying!'**
  String get motivationalPhrases_4;

  /// No description provided for @motivationalPhrases_5.
  ///
  /// In en, this message translates to:
  /// **'You can do it, never give up!'**
  String get motivationalPhrases_5;

  /// No description provided for @motivationalPhrases_6.
  ///
  /// In en, this message translates to:
  /// **'Success comes to those who keep striving!'**
  String get motivationalPhrases_6;

  /// No description provided for @motivationalPhrases_7.
  ///
  /// In en, this message translates to:
  /// **'Keep improving, step by step!'**
  String get motivationalPhrases_7;

  /// No description provided for @motivationalPhrases_8.
  ///
  /// In en, this message translates to:
  /// **'Be strong, stay focused, and keep moving forward!'**
  String get motivationalPhrases_8;

  /// No description provided for @motivationalPhrases_9.
  ///
  /// In en, this message translates to:
  /// **'Great effort! Keep aiming higher!'**
  String get motivationalPhrases_9;

  /// No description provided for @motivationalPhrases_10.
  ///
  /// In en, this message translates to:
  /// **'Your hard work will soon pay off!'**
  String get motivationalPhrases_10;

  /// No description provided for @learn_bottomsheet_right_btn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get learn_bottomsheet_right_btn;

  /// No description provided for @learning_combine_title.
  ///
  /// In en, this message translates to:
  /// **'Match from column A to column B'**
  String get learning_combine_title;

  /// No description provided for @learn_translate_title.
  ///
  /// In en, this message translates to:
  /// **'Translate the sentence below'**
  String get learn_translate_title;

  /// No description provided for @learn_listen_title.
  ///
  /// In en, this message translates to:
  /// **'What do you hear?'**
  String get learn_listen_title;

  /// No description provided for @learn_chose_title.
  ///
  /// In en, this message translates to:
  /// **'Which word is correct?'**
  String get learn_chose_title;

  /// No description provided for @congraculate_title.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get congraculate_title;

  /// No description provided for @congraculate_content.
  ///
  /// In en, this message translates to:
  /// **'You are amazing'**
  String get congraculate_content;

  /// No description provided for @congraculate_commited.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get congraculate_commited;

  /// No description provided for @congraculate_amzing.
  ///
  /// In en, this message translates to:
  /// **'Awesome'**
  String get congraculate_amzing;

  /// No description provided for @profile_level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get profile_level;

  /// No description provided for @profile_topic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get profile_topic;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get profile_title;

  /// No description provided for @levelTitles_1.
  ///
  /// In en, this message translates to:
  /// **'Learner'**
  String get levelTitles_1;

  /// No description provided for @levelTitles_2.
  ///
  /// In en, this message translates to:
  /// **'Wise Scholar'**
  String get levelTitles_2;

  /// No description provided for @levelTitles_3.
  ///
  /// In en, this message translates to:
  /// **'Thinker'**
  String get levelTitles_3;

  /// No description provided for @levelTitles_4.
  ///
  /// In en, this message translates to:
  /// **'Erudite Sage'**
  String get levelTitles_4;

  /// No description provided for @levelTitles_5.
  ///
  /// In en, this message translates to:
  /// **'Academician'**
  String get levelTitles_5;

  /// No description provided for @levelTitles_6.
  ///
  /// In en, this message translates to:
  /// **'Literary Genius'**
  String get levelTitles_6;

  /// No description provided for @levelTitles_7.
  ///
  /// In en, this message translates to:
  /// **'Wise Saint'**
  String get levelTitles_7;

  /// No description provided for @levelTitles_8.
  ///
  /// In en, this message translates to:
  /// **'Debating Genius'**
  String get levelTitles_8;

  /// No description provided for @levelTitles_9.
  ///
  /// In en, this message translates to:
  /// **'Master Scholar'**
  String get levelTitles_9;

  /// No description provided for @levelTitles_10.
  ///
  /// In en, this message translates to:
  /// **'Virtuous Scholar'**
  String get levelTitles_10;

  /// No description provided for @levelTitles_11.
  ///
  /// In en, this message translates to:
  /// **'Diligent Student'**
  String get levelTitles_11;

  /// No description provided for @levelTitles_12.
  ///
  /// In en, this message translates to:
  /// **'Enlightened One'**
  String get levelTitles_12;

  /// No description provided for @levelTitles_13.
  ///
  /// In en, this message translates to:
  /// **'Profound Philosopher'**
  String get levelTitles_13;

  /// No description provided for @levelTitles_14.
  ///
  /// In en, this message translates to:
  /// **'Elegant Sage'**
  String get levelTitles_14;

  /// No description provided for @levelTitles_15.
  ///
  /// In en, this message translates to:
  /// **'Talented Scholar'**
  String get levelTitles_15;

  /// Display month and year in profile
  ///
  /// In en, this message translates to:
  /// **'Month {month} Year {year}'**
  String profile_date(int month, int year);

  /// No description provided for @setting_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting_title;

  /// No description provided for @setting_achivement_title.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get setting_achivement_title;

  /// No description provided for @setting_achivement_content.
  ///
  /// In en, this message translates to:
  /// **'List of earned achievements'**
  String get setting_achivement_content;

  /// No description provided for @setting_language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get setting_language_title;

  /// No description provided for @setting_language_content.
  ///
  /// In en, this message translates to:
  /// **'Select display language'**
  String get setting_language_content;

  /// No description provided for @setting_async_title.
  ///
  /// In en, this message translates to:
  /// **'Sync Data'**
  String get setting_async_title;

  /// No description provided for @setting_async_content.
  ///
  /// In en, this message translates to:
  /// **'Sync data to the cloud'**
  String get setting_async_content;

  /// No description provided for @setting_downloadAsync_title.
  ///
  /// In en, this message translates to:
  /// **'Download Data'**
  String get setting_downloadAsync_title;

  /// No description provided for @setting_downloadAsync_content.
  ///
  /// In en, this message translates to:
  /// **'Download synced data from your old device'**
  String get setting_downloadAsync_content;

  /// No description provided for @setting_signout_title.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get setting_signout_title;

  /// No description provided for @setting_signout_content.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your current account'**
  String get setting_signout_content;

  /// No description provided for @achivement_title_one.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get achivement_title_one;

  /// No description provided for @achivement_owl_title.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get achivement_owl_title;

  /// No description provided for @achivement_owl_description.
  ///
  /// In en, this message translates to:
  /// **'Study between 12am and 2am'**
  String get achivement_owl_description;

  /// No description provided for @achivement_tryhard_title.
  ///
  /// In en, this message translates to:
  /// **'Hardworking Knowledge Seeker'**
  String get achivement_tryhard_title;

  /// No description provided for @achivement_tryhard_description.
  ///
  /// In en, this message translates to:
  /// **'Study between 4am and 6am'**
  String get achivement_tryhard_description;

  /// No description provided for @achivement_habit_title.
  ///
  /// In en, this message translates to:
  /// **'Habit Builder'**
  String get achivement_habit_title;

  /// No description provided for @achivement_habit_description.
  ///
  /// In en, this message translates to:
  /// **'Study for 28 consecutive days'**
  String get achivement_habit_description;

  /// No description provided for @achivement_title_two.
  ///
  /// In en, this message translates to:
  /// **'Study Streak'**
  String get achivement_title_two;

  /// study streak
  ///
  /// In en, this message translates to:
  /// **'{day}-Day Streak'**
  String achivement_streak_title(String day);

  /// study streak description
  ///
  /// In en, this message translates to:
  /// **'Earned after studying {day} consecutive days'**
  String achivement_streak_description(String day);

  /// No description provided for @achivement_title_three.
  ///
  /// In en, this message translates to:
  /// **'Completed Topics'**
  String get achivement_title_three;

  /// topic completion
  ///
  /// In en, this message translates to:
  /// **'{amount} Topics'**
  String achivement_topic_title(String amount);

  /// topic completion description
  ///
  /// In en, this message translates to:
  /// **'Earned after completing {amount} topics'**
  String achivement_topic_description(String amount);

  /// No description provided for @bottomSheetAsync_Success_Description.
  ///
  /// In en, this message translates to:
  /// **'Data has been successfully synced'**
  String get bottomSheetAsync_Success_Description;

  /// No description provided for @bottomSheetAsync_Success_Btn.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get bottomSheetAsync_Success_Btn;

  /// No description provided for @bottomSheet_Nointernet_title.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get bottomSheet_Nointernet_title;

  /// No description provided for @bottomSheet_Nointernet_Description.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get bottomSheet_Nointernet_Description;

  /// No description provided for @bottomSheet_Nointernet_Btn.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get bottomSheet_Nointernet_Btn;

  /// No description provided for @bottomSheet_Error_title.
  ///
  /// In en, this message translates to:
  /// **'Data Load Error'**
  String get bottomSheet_Error_title;

  /// No description provided for @bottomSheet_Error_description.
  ///
  /// In en, this message translates to:
  /// **'No synced data available'**
  String get bottomSheet_Error_description;

  /// No description provided for @bottomSheet_Warning_title.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get bottomSheet_Warning_title;

  /// No description provided for @bottomSheet_Warning_Description.
  ///
  /// In en, this message translates to:
  /// **'When syncing, all data on this device will be deleted'**
  String get bottomSheet_Warning_Description;

  /// No description provided for @bottomSheet_Warning_btn_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get bottomSheet_Warning_btn_ok;

  /// No description provided for @bottomSheet_Warning_btn_cancle.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bottomSheet_Warning_btn_cancle;

  /// No description provided for @language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_title;

  /// No description provided for @language_bottomsheet_success.
  ///
  /// In en, this message translates to:
  /// **'Language Updated Successfully'**
  String get language_bottomsheet_success;

  /// No description provided for @error_connect_server.
  ///
  /// In en, this message translates to:
  /// **'Server Connection Error'**
  String get error_connect_server;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, glad to see you'**
  String get login_title;

  /// No description provided for @login_email_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get login_email_input_hint;

  /// No description provided for @login_email_input_hint_focus.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get login_email_input_hint_focus;

  /// No description provided for @login_email_input_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_email_input_password;

  /// No description provided for @login_email_input_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get login_email_input_password_hint;

  /// No description provided for @login_btn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_btn;

  /// No description provided for @login_create_question_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_create_question_account;

  /// No description provided for @login_create_btn_account.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get login_create_btn_account;

  /// No description provided for @login_with_facebook.
  ///
  /// In en, this message translates to:
  /// **'Login with Facebook'**
  String get login_with_facebook;

  /// No description provided for @login_with_google.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get login_with_google;

  /// No description provided for @login_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get login_invalid_email;

  /// No description provided for @login_user_disabled.
  ///
  /// In en, this message translates to:
  /// **'Account Disabled'**
  String get login_user_disabled;

  /// No description provided for @login_user_not_found.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email'**
  String get login_user_not_found;

  /// No description provided for @login_wrong_password.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get login_wrong_password;

  /// No description provided for @login_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get login_error;

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Hello, Sign up to start your journey'**
  String get register_title;

  /// No description provided for @register_email_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get register_email_input_hint;

  /// No description provided for @register_email_input_hint_focus.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get register_email_input_hint_focus;

  /// No description provided for @register_user_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get register_user_input_hint;

  /// No description provided for @register_user_input_hint_focus.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get register_user_input_hint_focus;

  /// No description provided for @register_password_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get register_password_input_hint;

  /// No description provided for @register_password_input_hint_focus.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get register_password_input_hint_focus;

  /// No description provided for @register_re_password_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get register_re_password_input_hint;

  /// No description provided for @register_re_password_input_hint_focus.
  ///
  /// In en, this message translates to:
  /// **'Re-enter Password'**
  String get register_re_password_input_hint_focus;

  /// No description provided for @register_btn.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get register_btn;

  /// No description provided for @register_question_login.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get register_question_login;

  /// No description provided for @register_btn_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get register_btn_login;

  /// No description provided for @register_email_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get register_email_already_in_use;

  /// No description provided for @register_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get register_invalid_email;

  /// No description provided for @register_operation_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Email/password account not enabled'**
  String get register_operation_not_allowed;

  /// No description provided for @register_weak_password.
  ///
  /// In en, this message translates to:
  /// **'Weak Password'**
  String get register_weak_password;

  /// No description provided for @register_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get register_error;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully, please go back to login'**
  String get register_success;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'ru', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
    case 'ru': return AppLocalizationsRu();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
