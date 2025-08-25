import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
    Locale('vi')
  ];

  /// No description provided for @tabbar_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabbar_home;

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

  /// No description provided for @dashboard_hintSearch.
  ///
  /// In en, this message translates to:
  /// **'Word you want to search'**
  String get dashboard_hintSearch;

  /// No description provided for @dashboard_folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get dashboard_folder;

  /// No description provided for @dashboard_course.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get dashboard_course;

  /// No description provided for @dashboard_topic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get dashboard_topic;

  /// No description provided for @dashboard_popupDownload_title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to download?'**
  String get dashboard_popupDownload_title;

  /// No description provided for @dashboard_popupDownload_btn_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dashboard_popupDownload_btn_cancel;

  /// No description provided for @dashboard_popupDownload_btn_dowload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get dashboard_popupDownload_btn_dowload;

  /// No description provided for @dashboard_seemore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get dashboard_seemore;

  /// No description provided for @dashboard_btn_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get dashboard_btn_import;

  /// No description provided for @tutorial_one_title.
  ///
  /// In en, this message translates to:
  /// **'Install the App'**
  String get tutorial_one_title;

  /// No description provided for @tutorial_one_content.
  ///
  /// In en, this message translates to:
  /// **'Make sure your device has the Gboard app installed'**
  String get tutorial_one_content;

  /// No description provided for @tutorial_two_title.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get tutorial_two_title;

  /// No description provided for @tutorial_two_content.
  ///
  /// In en, this message translates to:
  /// **'Go to the settings app to set up the Japanese handwriting keyboard'**
  String get tutorial_two_content;

  /// No description provided for @tutorial_three_title.
  ///
  /// In en, this message translates to:
  /// **'Search for Gboard'**
  String get tutorial_three_title;

  /// No description provided for @tutorial_three_content.
  ///
  /// In en, this message translates to:
  /// **'Tap to search and find Gboard as shown in the image'**
  String get tutorial_three_content;

  /// No description provided for @tutorial_four_title.
  ///
  /// In en, this message translates to:
  /// **'Gboard'**
  String get tutorial_four_title;

  /// No description provided for @tutorial_four_content.
  ///
  /// In en, this message translates to:
  /// **'Continue tapping as instructed'**
  String get tutorial_four_content;

  /// No description provided for @tutorial_five_title.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get tutorial_five_title;

  /// No description provided for @tutorial_five_content.
  ///
  /// In en, this message translates to:
  /// **'Tap on the language section'**
  String get tutorial_five_content;

  /// No description provided for @tutorial_six_title.
  ///
  /// In en, this message translates to:
  /// **'Add Keyboard'**
  String get tutorial_six_title;

  /// No description provided for @tutorial_six_content.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a keyboard and choose Japanese'**
  String get tutorial_six_content;

  /// No description provided for @tutorial_seven_title.
  ///
  /// In en, this message translates to:
  /// **'Search Japanese'**
  String get tutorial_seven_title;

  /// No description provided for @tutorial_seven_content.
  ///
  /// In en, this message translates to:
  /// **'Search for the Japanese language'**
  String get tutorial_seven_content;

  /// No description provided for @tutorial_eight_title.
  ///
  /// In en, this message translates to:
  /// **'Handwriting'**
  String get tutorial_eight_title;

  /// No description provided for @tutorial_eight_content.
  ///
  /// In en, this message translates to:
  /// **'Choose the handwriting keyboard and tap Done'**
  String get tutorial_eight_content;

  /// No description provided for @tutorial_nice_title.
  ///
  /// In en, this message translates to:
  /// **'Switch Keyboard'**
  String get tutorial_nice_title;

  /// No description provided for @tutorial_nice_content.
  ///
  /// In en, this message translates to:
  /// **'Remember to switch keyboards when practicing writing to improve memory'**
  String get tutorial_nice_content;

  /// No description provided for @tutorial_btn_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tutorial_btn_back;

  /// No description provided for @tutorial_btn_forward.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorial_btn_forward;

  /// No description provided for @tutorial_btn_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tutorial_btn_skip;

  /// No description provided for @tutorial_one_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tutorial_one_done;

  /// Created by whom
  ///
  /// In en, this message translates to:
  /// **'Created by {user_nane}'**
  String course_owner(String user_nane);

  /// Number of words
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount} Words'**
  String amount_word(String amount);

  /// Number of completed words
  ///
  /// In en, this message translates to:
  /// **'Completed: {amount}'**
  String word_finish(String amount);

  /// Number of incomplete words
  ///
  /// In en, this message translates to:
  /// **'Incomplete: {amount}'**
  String word_learning(String amount);

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

  /// No description provided for @folderManager.
  ///
  /// In en, this message translates to:
  /// **'Add Course Topic'**
  String get folderManager;

  /// No description provided for @folderManager_addTopic.
  ///
  /// In en, this message translates to:
  /// **'Add Topic'**
  String get folderManager_addTopic;

  /// No description provided for @folderManager_remove.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get folderManager_remove;

  /// No description provided for @folderManager_removeTopic.
  ///
  /// In en, this message translates to:
  /// **'Remove from Folder'**
  String get folderManager_removeTopic;

  /// No description provided for @seemore_search.
  ///
  /// In en, this message translates to:
  /// **'Folder Name'**
  String get seemore_search;

  /// No description provided for @import_title.
  ///
  /// In en, this message translates to:
  /// **'Choose Import Method'**
  String get import_title;

  /// No description provided for @import_btn_file.
  ///
  /// In en, this message translates to:
  /// **'From File'**
  String get import_btn_file;

  /// No description provided for @import_btn_qr.
  ///
  /// In en, this message translates to:
  /// **'From QR'**
  String get import_btn_qr;

  /// No description provided for @character_btn_learn.
  ///
  /// In en, this message translates to:
  /// **'Learn Characters'**
  String get character_btn_learn;

  /// Number of completed words
  ///
  /// In en, this message translates to:
  /// **'Completed {count}'**
  String listWord_word_complete(String count);

  /// Number of incomplete words
  ///
  /// In en, this message translates to:
  /// **'Incomplete {count}'**
  String listWord_word_learning(String count);

  /// No description provided for @listWord_btn_learn.
  ///
  /// In en, this message translates to:
  /// **'Learn Words'**
  String get listWord_btn_learn;

  /// Topic name
  ///
  /// In en, this message translates to:
  /// **'Topic Name: {topic}'**
  String listWord_share_title(String topic);

  /// Number of words
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount} Words'**
  String listWord_share_amount_word(String amount);

  /// Type of sharing
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
  /// **'Gboard is recommended for the best experience'**
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
  /// **'You did great this time, keep pushing forward!'**
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
  /// **'Success comes to those who don’t quit!'**
  String get motivationalPhrases_6;

  /// No description provided for @motivationalPhrases_7.
  ///
  /// In en, this message translates to:
  /// **'Keep improving step by step!'**
  String get motivationalPhrases_7;

  /// No description provided for @motivationalPhrases_8.
  ///
  /// In en, this message translates to:
  /// **'Be strong, stay focused, and keep going!'**
  String get motivationalPhrases_8;

  /// No description provided for @motivationalPhrases_9.
  ///
  /// In en, this message translates to:
  /// **'Amazing effort! Aim even higher!'**
  String get motivationalPhrases_9;

  /// No description provided for @motivationalPhrases_10.
  ///
  /// In en, this message translates to:
  /// **'Your hard work will pay off soon!'**
  String get motivationalPhrases_10;

  /// No description provided for @learn_bottomsheet_right_btn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get learn_bottomsheet_right_btn;

  /// No description provided for @learning_combine_title.
  ///
  /// In en, this message translates to:
  /// **'Match from Column A to Column B'**
  String get learning_combine_title;

  /// No description provided for @learn_translate_title.
  ///
  /// In en, this message translates to:
  /// **'Translate the Sentence Below'**
  String get learn_translate_title;

  /// No description provided for @learn_listen_title.
  ///
  /// In en, this message translates to:
  /// **'What Did You Hear?'**
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
  /// **'You’re Amazing!'**
  String get congraculate_content;

  /// No description provided for @congraculate_commited.
  ///
  /// In en, this message translates to:
  /// **'Time Spent'**
  String get congraculate_commited;

  /// No description provided for @congraculate_amzing.
  ///
  /// In en, this message translates to:
  /// **'Wonderful'**
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
  /// **'Scholar'**
  String get levelTitles_1;

  /// No description provided for @levelTitles_2.
  ///
  /// In en, this message translates to:
  /// **'Wise One'**
  String get levelTitles_2;

  /// No description provided for @levelTitles_3.
  ///
  /// In en, this message translates to:
  /// **'Thinker'**
  String get levelTitles_3;

  /// No description provided for @levelTitles_4.
  ///
  /// In en, this message translates to:
  /// **'Honorable Academic'**
  String get levelTitles_4;

  /// No description provided for @levelTitles_5.
  ///
  /// In en, this message translates to:
  /// **'Academic Scholar'**
  String get levelTitles_5;

  /// No description provided for @levelTitles_6.
  ///
  /// In en, this message translates to:
  /// **'Literary Genius'**
  String get levelTitles_6;

  /// No description provided for @levelTitles_7.
  ///
  /// In en, this message translates to:
  /// **'Sage'**
  String get levelTitles_7;

  /// No description provided for @levelTitles_8.
  ///
  /// In en, this message translates to:
  /// **'Debating Genius'**
  String get levelTitles_8;

  /// No description provided for @levelTitles_9.
  ///
  /// In en, this message translates to:
  /// **'Master Learner'**
  String get levelTitles_9;

  /// No description provided for @levelTitles_10.
  ///
  /// In en, this message translates to:
  /// **'Literary Gentleman'**
  String get levelTitles_10;

  /// No description provided for @levelTitles_11.
  ///
  /// In en, this message translates to:
  /// **'Disciplined Scholar'**
  String get levelTitles_11;

  /// No description provided for @levelTitles_12.
  ///
  /// In en, this message translates to:
  /// **'Enlightened One'**
  String get levelTitles_12;

  /// No description provided for @levelTitles_13.
  ///
  /// In en, this message translates to:
  /// **'Profound Sage'**
  String get levelTitles_13;

  /// No description provided for @levelTitles_14.
  ///
  /// In en, this message translates to:
  /// **'Elegant Master'**
  String get levelTitles_14;

  /// No description provided for @levelTitles_15.
  ///
  /// In en, this message translates to:
  /// **'Gifted Intellectual'**
  String get levelTitles_15;

  /// Display month and year in profile
  ///
  /// In en, this message translates to:
  /// **'Month {month}, Year {year}'**
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
  /// **'List of achievements unlocked'**
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
  /// **'Data Sync'**
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
  /// **'Download synced data from your previous device'**
  String get setting_downloadAsync_content;

  /// No description provided for @setting_signout_title.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get setting_signout_title;

  /// No description provided for @setting_signout_content.
  ///
  /// In en, this message translates to:
  /// **'Sign out from the current account'**
  String get setting_signout_content;

  /// No description provided for @achivement_title_one.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achivement_title_one;

  /// No description provided for @achivement_owl_title.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get achivement_owl_title;

  /// No description provided for @achivement_owl_description.
  ///
  /// In en, this message translates to:
  /// **'Studied between 12am and 2am'**
  String get achivement_owl_description;

  /// No description provided for @achivement_tryhard_title.
  ///
  /// In en, this message translates to:
  /// **'Early Bird Learner'**
  String get achivement_tryhard_title;

  /// No description provided for @achivement_tryhard_description.
  ///
  /// In en, this message translates to:
  /// **'Studied between 4am and 6am'**
  String get achivement_tryhard_description;

  /// No description provided for @achivement_habit_title.
  ///
  /// In en, this message translates to:
  /// **'Habit Builder'**
  String get achivement_habit_title;

  /// No description provided for @achivement_habit_description.
  ///
  /// In en, this message translates to:
  /// **'Studied for 28 consecutive days'**
  String get achivement_habit_description;

  /// No description provided for @achivement_title_two.
  ///
  /// In en, this message translates to:
  /// **'Study Streak'**
  String get achivement_title_two;

  /// Study streak title
  ///
  /// In en, this message translates to:
  /// **'{day}_Day Streak'**
  String achivement_streak_title(String day);

  /// Study streak description
  ///
  /// In en, this message translates to:
  /// **'Earned by studying {day} days in a row'**
  String achivement_streak_description(String day);

  /// No description provided for @achivement_title_three.
  ///
  /// In en, this message translates to:
  /// **'Completed Topics'**
  String get achivement_title_three;

  /// Topic count
  ///
  /// In en, this message translates to:
  /// **'{amount} Topics'**
  String achivement_topic_title(String amount);

  /// Topic completion description
  ///
  /// In en, this message translates to:
  /// **'Earned after completing {amount} topics'**
  String achivement_topic_description(String amount);

  /// No description provided for @bottomSheetAsync_Success_Description.
  ///
  /// In en, this message translates to:
  /// **'Data synced successfully'**
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

  /// No description provided for @bottomSheet_Warning_title.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get bottomSheet_Warning_title;

  /// No description provided for @bottomSheet_Warning_Description.
  ///
  /// In en, this message translates to:
  /// **'Syncing will erase all local data on this device'**
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

  /// No description provided for @bottomSheet_Error_title.
  ///
  /// In en, this message translates to:
  /// **'Data Download Error'**
  String get bottomSheet_Error_title;

  /// No description provided for @bottomSheet_Error_description.
  ///
  /// In en, this message translates to:
  /// **'There is currently no data sync available'**
  String get bottomSheet_Error_description;

  /// No description provided for @language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_title;

  /// No description provided for @language_bottomsheet_success.
  ///
  /// In en, this message translates to:
  /// **'Language updated successfully'**
  String get language_bottomsheet_success;

  /// No description provided for @error_connect_server.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to the server'**
  String get error_connect_server;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, happy to see you'**
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
  /// **'Enter your password'**
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
  /// **'Invalid email address'**
  String get login_invalid_email;

  /// No description provided for @login_user_disabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
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
  /// **'An error has occurred'**
  String get login_error;

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Hello, sign up to get started'**
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
  /// **'Enter your username'**
  String get register_user_input_hint_focus;

  /// No description provided for @register_password_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get register_password_input_hint;

  /// No description provided for @register_password_input_hint_focus.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get register_password_input_hint_focus;

  /// No description provided for @register_re_password_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter Password'**
  String get register_re_password_input_hint;

  /// No description provided for @register_re_password_input_hint_focus.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
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
  /// **'Email/password sign-in is not enabled'**
  String get register_operation_not_allowed;

  /// No description provided for @register_weak_password.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get register_weak_password;

  /// No description provided for @register_error.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred'**
  String get register_error;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully, return to login page'**
  String get register_success;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
