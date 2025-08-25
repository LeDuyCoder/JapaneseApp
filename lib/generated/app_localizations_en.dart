import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabbar_home => 'Home';

  @override
  String get tabbar_character => 'Alphabet';

  @override
  String get tabbar_info => 'Info';

  @override
  String get dashboard_hintSearch => 'Word you want to search';

  @override
  String get dashboard_folder => 'Folder';

  @override
  String get dashboard_course => 'Course';

  @override
  String get dashboard_topic => 'Topic';

  @override
  String get dashboard_popupDownload_title => 'Do you want to download?';

  @override
  String get dashboard_popupDownload_btn_cancel => 'Cancel';

  @override
  String get dashboard_popupDownload_btn_dowload => 'Download';

  @override
  String get dashboard_seemore => 'See More';

  @override
  String get dashboard_btn_import => 'Import';

  @override
  String get tutorial_one_title => 'Install the App';

  @override
  String get tutorial_one_content => 'Make sure your device has the Gboard app installed';

  @override
  String get tutorial_two_title => 'Open Settings';

  @override
  String get tutorial_two_content => 'Go to the settings app to set up the Japanese handwriting keyboard';

  @override
  String get tutorial_three_title => 'Search for Gboard';

  @override
  String get tutorial_three_content => 'Tap to search and find Gboard as shown in the image';

  @override
  String get tutorial_four_title => 'Gboard';

  @override
  String get tutorial_four_content => 'Continue tapping as instructed';

  @override
  String get tutorial_five_title => 'Languages';

  @override
  String get tutorial_five_content => 'Tap on the language section';

  @override
  String get tutorial_six_title => 'Add Keyboard';

  @override
  String get tutorial_six_content => 'Tap to add a keyboard and choose Japanese';

  @override
  String get tutorial_seven_title => 'Search Japanese';

  @override
  String get tutorial_seven_content => 'Search for the Japanese language';

  @override
  String get tutorial_eight_title => 'Handwriting';

  @override
  String get tutorial_eight_content => 'Choose the handwriting keyboard and tap Done';

  @override
  String get tutorial_nice_title => 'Switch Keyboard';

  @override
  String get tutorial_nice_content => 'Remember to switch keyboards when practicing writing to improve memory';

  @override
  String get tutorial_btn_back => 'Back';

  @override
  String get tutorial_btn_forward => 'Next';

  @override
  String get tutorial_btn_skip => 'Skip';

  @override
  String get tutorial_one_done => 'Done';

  @override
  String course_owner(String user_nane) {
    return 'Created by $user_nane';
  }

  @override
  String amount_word(String amount) {
    return 'Amount: $amount Words';
  }

  @override
  String word_finish(String amount) {
    return 'Completed: $amount';
  }

  @override
  String word_learning(String amount) {
    return 'Incomplete: $amount';
  }

  @override
  String get add_course => 'Course';

  @override
  String get add_folder => 'Folder';

  @override
  String get folderManager => 'Add Course Topic';

  @override
  String get folderManager_addTopic => 'Add Topic';

  @override
  String get folderManager_remove => 'Delete';

  @override
  String get folderManager_removeTopic => 'Remove from Folder';

  @override
  String get seemore_search => 'Folder Name';

  @override
  String get import_title => 'Choose Import Method';

  @override
  String get import_btn_file => 'From File';

  @override
  String get import_btn_qr => 'From QR';

  @override
  String get character_btn_learn => 'Learn Characters';

  @override
  String listWord_word_complete(String count) {
    return 'Completed $count';
  }

  @override
  String listWord_word_learning(String count) {
    return 'Incomplete $count';
  }

  @override
  String get listWord_btn_learn => 'Learn Words';

  @override
  String listWord_share_title(String topic) {
    return 'Topic Name: $topic';
  }

  @override
  String listWord_share_amount_word(String amount) {
    return 'Amount: $amount Words';
  }

  @override
  String listWord_share_type(String type) {
    return 'Type: $type';
  }

  @override
  String get listWord_btn_remove => 'Delete';

  @override
  String get listWord_btn_shared => 'Share';

  @override
  String get learn_warningGboard => 'Gboard is recommended for the best experience';

  @override
  String get learn_btn_check => 'Check';

  @override
  String get learn_bottomsheet_wrong_title => 'Incorrect';

  @override
  String get learn_bottomsheet_wrong_content => 'The correct answer is';

  @override
  String get learn_bottomsheet_wrong_btn => 'Continue';

  @override
  String get learn_write_input => 'Write';

  @override
  String get learn_bottomsheet_right_title => 'Correct Answer';

  @override
  String get motivationalPhrases_1 => 'Keep going, you\'re doing great!';

  @override
  String get motivationalPhrases_2 => 'You did great this time, keep pushing forward!';

  @override
  String get motivationalPhrases_3 => 'Every step forward is progress!';

  @override
  String get motivationalPhrases_4 => 'Believe in yourself and keep trying!';

  @override
  String get motivationalPhrases_5 => 'You can do it, never give up!';

  @override
  String get motivationalPhrases_6 => 'Success comes to those who don’t quit!';

  @override
  String get motivationalPhrases_7 => 'Keep improving step by step!';

  @override
  String get motivationalPhrases_8 => 'Be strong, stay focused, and keep going!';

  @override
  String get motivationalPhrases_9 => 'Amazing effort! Aim even higher!';

  @override
  String get motivationalPhrases_10 => 'Your hard work will pay off soon!';

  @override
  String get learn_bottomsheet_right_btn => 'Continue';

  @override
  String get learning_combine_title => 'Match from Column A to Column B';

  @override
  String get learn_translate_title => 'Translate the Sentence Below';

  @override
  String get learn_listen_title => 'What Did You Hear?';

  @override
  String get learn_chose_title => 'Which word is correct?';

  @override
  String get congraculate_title => 'Completed';

  @override
  String get congraculate_content => 'You’re Amazing!';

  @override
  String get congraculate_commited => 'Time Spent';

  @override
  String get congraculate_amzing => 'Wonderful';

  @override
  String get profile_level => 'Level';

  @override
  String get profile_topic => 'Topic';

  @override
  String get profile_title => 'Title';

  @override
  String get levelTitles_1 => 'Scholar';

  @override
  String get levelTitles_2 => 'Wise One';

  @override
  String get levelTitles_3 => 'Thinker';

  @override
  String get levelTitles_4 => 'Honorable Academic';

  @override
  String get levelTitles_5 => 'Academic Scholar';

  @override
  String get levelTitles_6 => 'Literary Genius';

  @override
  String get levelTitles_7 => 'Sage';

  @override
  String get levelTitles_8 => 'Debating Genius';

  @override
  String get levelTitles_9 => 'Master Learner';

  @override
  String get levelTitles_10 => 'Literary Gentleman';

  @override
  String get levelTitles_11 => 'Disciplined Scholar';

  @override
  String get levelTitles_12 => 'Enlightened One';

  @override
  String get levelTitles_13 => 'Profound Sage';

  @override
  String get levelTitles_14 => 'Elegant Master';

  @override
  String get levelTitles_15 => 'Gifted Intellectual';

  @override
  String profile_date(int month, int year) {
    return 'Month $month, Year $year';
  }

  @override
  String get setting_title => 'Settings';

  @override
  String get setting_achivement_title => 'Achievements';

  @override
  String get setting_achivement_content => 'List of achievements unlocked';

  @override
  String get setting_language_title => 'Language';

  @override
  String get setting_language_content => 'Select display language';

  @override
  String get setting_async_title => 'Data Sync';

  @override
  String get setting_async_content => 'Sync data to the cloud';

  @override
  String get setting_downloadAsync_title => 'Download Data';

  @override
  String get setting_downloadAsync_content => 'Download synced data from your previous device';

  @override
  String get setting_signout_title => 'Sign Out';

  @override
  String get setting_signout_content => 'Sign out from the current account';

  @override
  String get achivement_title_one => 'Achievements';

  @override
  String get achivement_owl_title => 'Night Owl';

  @override
  String get achivement_owl_description => 'Studied between 12am and 2am';

  @override
  String get achivement_tryhard_title => 'Early Bird Learner';

  @override
  String get achivement_tryhard_description => 'Studied between 4am and 6am';

  @override
  String get achivement_habit_title => 'Habit Builder';

  @override
  String get achivement_habit_description => 'Studied for 28 consecutive days';

  @override
  String get achivement_title_two => 'Study Streak';

  @override
  String achivement_streak_title(String day) {
    return '${day}_Day Streak';
  }

  @override
  String achivement_streak_description(String day) {
    return 'Earned by studying $day days in a row';
  }

  @override
  String get achivement_title_three => 'Completed Topics';

  @override
  String achivement_topic_title(String amount) {
    return '$amount Topics';
  }

  @override
  String achivement_topic_description(String amount) {
    return 'Earned after completing $amount topics';
  }

  @override
  String get bottomSheetAsync_Success_Description => 'Data synced successfully';

  @override
  String get bottomSheetAsync_Success_Btn => 'OK';

  @override
  String get bottomSheet_Nointernet_title => 'No Internet Connection';

  @override
  String get bottomSheet_Nointernet_Description => 'Please check your internet connection and try again';

  @override
  String get bottomSheet_Nointernet_Btn => 'OK';

  @override
  String get bottomSheet_Warning_title => 'Warning';

  @override
  String get bottomSheet_Warning_Description => 'Syncing will erase all local data on this device';

  @override
  String get bottomSheet_Warning_btn_ok => 'OK';

  @override
  String get bottomSheet_Warning_btn_cancle => 'Cancel';

  @override
  String get bottomSheet_Error_title => 'Data Download Error';

  @override
  String get bottomSheet_Error_description => 'There is currently no data sync available';

  @override
  String get language_title => 'Language';

  @override
  String get language_bottomsheet_success => 'Language updated successfully';

  @override
  String get error_connect_server => 'Failed to connect to the server';

  @override
  String get login_title => 'Welcome back, happy to see you';

  @override
  String get login_email_input_hint => 'Email';

  @override
  String get login_email_input_hint_focus => 'Enter your email';

  @override
  String get login_email_input_password => 'Password';

  @override
  String get login_email_input_password_hint => 'Enter your password';

  @override
  String get login_btn => 'Login';

  @override
  String get login_create_question_account => 'Don\'t have an account?';

  @override
  String get login_create_btn_account => 'Sign Up';

  @override
  String get login_with_facebook => 'Login with Facebook';

  @override
  String get login_with_google => 'Login with Google';

  @override
  String get login_invalid_email => 'Invalid email address';

  @override
  String get login_user_disabled => 'This account has been disabled';

  @override
  String get login_user_not_found => 'No account found with this email';

  @override
  String get login_wrong_password => 'Incorrect password';

  @override
  String get login_error => 'An error has occurred';

  @override
  String get register_title => 'Hello, sign up to get started';

  @override
  String get register_email_input_hint => 'Email';

  @override
  String get register_email_input_hint_focus => 'Enter your email';

  @override
  String get register_user_input_hint => 'Username';

  @override
  String get register_user_input_hint_focus => 'Enter your username';

  @override
  String get register_password_input_hint => 'Password';

  @override
  String get register_password_input_hint_focus => 'Enter your password';

  @override
  String get register_re_password_input_hint => 'Re-enter Password';

  @override
  String get register_re_password_input_hint_focus => 'Re-enter your password';

  @override
  String get register_btn => 'Sign Up';

  @override
  String get register_question_login => 'Already have an account?';

  @override
  String get register_btn_login => 'Login';

  @override
  String get register_email_already_in_use => 'This email is already registered';

  @override
  String get register_invalid_email => 'Invalid email address';

  @override
  String get register_operation_not_allowed => 'Email/password sign-in is not enabled';

  @override
  String get register_weak_password => 'Password is too weak';

  @override
  String get register_error => 'An error has occurred';

  @override
  String get register_success => 'Account created successfully, return to login page';
}
