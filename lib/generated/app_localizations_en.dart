import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabbar_home => 'Home';

  @override
  String get tabber_distionary => 'Dictionary';

  @override
  String get tabbar_character => 'Alphabet';

  @override
  String get tabbar_info => 'Info';

  @override
  String get dashboard_folder => 'My Folders';

  @override
  String get dashboard_folder_seemore => 'See All';

  @override
  String get dashboard_folder_content => 'topics';

  @override
  String get dashboard_folder_nodata_title => 'No folders yet';

  @override
  String get dashboard_folder_nodata_content => 'Create your first folder to organize your vocabulary';

  @override
  String get dashboard_comunication => 'Community';

  @override
  String get dashboard_comunication_seemore => 'See All';

  @override
  String course_owner(String user_nane) {
    return '$user_nane';
  }

  @override
  String amount_word(String amount) {
    return '$amount';
  }

  @override
  String get topic_persent => 'Percentage';

  @override
  String get topic_word_finish => 'Completed';

  @override
  String get topic_word_learning => 'Not Completed';

  @override
  String get add_course => 'Course';

  @override
  String get add_folder => 'Folder';

  @override
  String get folderSeemore_title => 'My Folders';

  @override
  String get folderSeemore_grid => 'Grid';

  @override
  String get folderSeemore_tag_flex => 'List';

  @override
  String get folderSeemore_content => 'All folders';

  @override
  String get folderSeemore_subContent => 'Folder';

  @override
  String get folderManager_nodata_title => 'Start creating your own folder';

  @override
  String get folderManager_nodata_button => 'Add learning topic';

  @override
  String get folderManager_bottomSheet_addTopic => 'Add Learning Topic';

  @override
  String get folderManager_bottomSheet_removeFolder => 'Delete';

  @override
  String get folderManager_topic_bottomSheet_remove => 'Remove from folder';

  @override
  String get folderManager_Screen_addTopic_title => 'Add Course Topic';

  @override
  String folderManager_Screen_addTopic_card_owner(String name) {
    return 'author: $name';
  }

  @override
  String folderManager_Screen_addTopic_card_amountWord(int amount) {
    return 'words: $amount';
  }

  @override
  String get comunication_bottomSheet_notify_download_title => 'Do you want to download?';

  @override
  String get comunication_bottomSheet_notify_download_btn => 'Download';

  @override
  String get download_Screen_downloading_title => 'Downloading Topic';

  @override
  String get download_Screen_downloading_contetnt => 'Please wait a moment...';

  @override
  String get download_Screen_downloading_btn => 'Cancel';

  @override
  String get download_Screen_Success_title => 'Download Successful';

  @override
  String get download_Screen_Success_contetnt => 'The topic is ready to learn';

  @override
  String get download_Screen_Success_btn => 'Start learning';

  @override
  String get dashboard_topic_nodata_title => 'No topics yet';

  @override
  String get dashboard_topic_nodata_content => 'Create your first topic to start learning';

  @override
  String get communication_Screen_title => 'Community';

  @override
  String get communication_Screen_hint_search => 'Enter topic name...';

  @override
  String get communication_Screen_subTitle => 'Community Collection';

  @override
  String get dashboard_topic => 'My Topics';

  @override
  String get dashboard_topic_seemore => 'See All';

  @override
  String get topic_seemore_title => 'My Topics';

  @override
  String get topic_seemore_subTitle => 'Topics';

  @override
  String get bottomSheet_add_topic => 'Course';

  @override
  String get bottomSheet_add_folder => 'Folder';

  @override
  String get popup_add_topic => 'Add New Topic';

  @override
  String get popup_add_topic_hint => 'Topic Name';

  @override
  String get popup_add_topic_exit => 'Topic Name Already Exists';

  @override
  String get popup_add_topic_btn_create => 'Create';

  @override
  String get popup_add_topic_btn_cancle => 'Cancel';

  @override
  String get addWord_Screen_Input_Japan_Label => 'Japanese Vocabulary';

  @override
  String get addWord_Screen_Input_Japan_Hint => 'Japanese word';

  @override
  String get addWord_Screen_Input_WayRead_Label => 'Reading (Hiragana)';

  @override
  String get addWord_Screen_Input_WayRead_Hint => 'reading';

  @override
  String get addWord_Screen_Input_Mean_Label => 'Word Meaning';

  @override
  String get addWord_Screen_Input_Mean_Hint => 'meaning';

  @override
  String get addWord_Screen_btn_add => 'Add Word';

  @override
  String get addWord_bottomShet_warning_save_title => 'Warning';

  @override
  String get addWord_bottomShet_warning_save_content => 'Once saved, it cannot be edited';

  @override
  String get addWord_bottomShet_warning_save_btn => 'Save';

  @override
  String get addWord_bottomShet_success_save_title => 'Saved Successfully';

  @override
  String get addWord_bottomShet_success_save_content => 'The topic you created has been successfully saved 🎉';

  @override
  String get addWord_bottomShet_success_save_btn => 'OK';

  @override
  String get listword_Screen_title => 'Topic';

  @override
  String get listword_Screen_AmountWord => 'vocabulary';

  @override
  String get listword_Screen_Learned => 'learned';

  @override
  String get listword_Screen_head_col1 => 'Japanese';

  @override
  String get listword_Screen_head_col2 => 'Meaning';

  @override
  String get listword_Screen_head_col3 => 'Status';

  @override
  String get listword_Screen_bottomSheet_public_title => 'Do you want to share?';

  @override
  String get listword_Screen_bottomSheet_public_content => 'When shared, anyone can download';

  @override
  String get listword_Screen_bottomSheet_public_btn_pulic => 'Public';

  @override
  String get listword_Screen_bottomSheet_public_btn_cancel => 'Cancel';

  @override
  String get listword_Screen_bottomSheet_public_succes_title => 'Congratulations';

  @override
  String get listword_Screen_bottomSheet_public_succes_content => 'You have successfully shared your topic';

  @override
  String get listword_Screen_bottomSheet_public_succes_btn_ok => 'OK';

  @override
  String get listword_Screen_bottomSheet_private_title => 'Do you want to cancel sharing?';

  @override
  String get listword_Screen_bottomSheet_private_btn_private => 'Unshare';

  @override
  String get listword_Screen_bottomSheet_private_btn_cancel => 'No';

  @override
  String get listword_Screen_bottomSheet_private_success_title => 'Unshared Successfully';

  @override
  String get listword_Screen_bottomSheet_private_success_content => 'You have unshared your topic';

  @override
  String get listword_Screen_bottomSheet_private_success_OK => 'OK';

  @override
  String get listword_Screen_btn_learn => 'Learn Now';

  @override
  String get keyboard_handwriting_btn_space => 'Space';

  @override
  String get keyboard_handwriting_btn_remove => 'Delete';

  @override
  String get distionary_Screen_title => 'Japanese Dictionary';

  @override
  String get distionary_Screen_hint => 'Enter word to search';

  @override
  String get distionary_Screen_hint_title => 'Search Vocabulary';

  @override
  String get distionary_Screen_hint_content => 'Start searching and learning your words';

  @override
  String get distionary_Screen_mean => 'Word Meaning';

  @override
  String get distionary_Screen_info => 'Word Info';

  @override
  String get distionary_Screen_type => 'Noun: ';

  @override
  String get distionary_Screen_level => 'Level: ';

  @override
  String get popup_remove_topic_title => 'Delete Topic';

  @override
  String get popup_remove_topic_content => 'Do you want to delete?';

  @override
  String get popup_remove_topic_btn_cancle => 'Cancel';

  @override
  String get popup_remove_topic_btn_delete => 'Delete';

  @override
  String get character_btn_learn => 'Learn Alphabet';

  @override
  String listWord_word_complete(String count) {
    return 'Completed $count';
  }

  @override
  String listWord_word_learning(String count) {
    return 'Not Completed $count';
  }

  @override
  String get listWord_btn_learn => 'Learn Words';

  @override
  String listWord_share_title(String topic) {
    return 'Topic name $topic';
  }

  @override
  String listWord_share_amount_word(String amount) {
    return 'Total: $amount words';
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
  String get learn_warningGboard => 'It is recommended to use Gboard for the best experience';

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
  String get motivationalPhrases_2 => 'Perfect this time, keep it up!';

  @override
  String get motivationalPhrases_3 => 'Every step forward is progress!';

  @override
  String get motivationalPhrases_4 => 'Believe in yourself and keep trying!';

  @override
  String get motivationalPhrases_5 => 'You can do it, never give up!';

  @override
  String get motivationalPhrases_6 => 'Success comes to those who keep striving!';

  @override
  String get motivationalPhrases_7 => 'Keep improving, step by step!';

  @override
  String get motivationalPhrases_8 => 'Be strong, stay focused, and keep moving forward!';

  @override
  String get motivationalPhrases_9 => 'Great effort! Keep aiming higher!';

  @override
  String get motivationalPhrases_10 => 'Your hard work will soon pay off!';

  @override
  String get learn_bottomsheet_right_btn => 'Continue';

  @override
  String get learning_combine_title => 'Match from column A to column B';

  @override
  String get learn_translate_title => 'Translate the sentence below';

  @override
  String get learn_listen_title => 'What do you hear?';

  @override
  String get learn_chose_title => 'Which word is correct?';

  @override
  String get congraculate_title => 'Completed';

  @override
  String get congraculate_content => 'You are amazing';

  @override
  String get congraculate_commited => 'Time';

  @override
  String get congraculate_amzing => 'Awesome';

  @override
  String get profile_level => 'Level';

  @override
  String get profile_topic => 'Topic';

  @override
  String get profile_title => 'Title';

  @override
  String get levelTitles_1 => 'Learner';

  @override
  String get levelTitles_2 => 'Wise Scholar';

  @override
  String get levelTitles_3 => 'Thinker';

  @override
  String get levelTitles_4 => 'Erudite Sage';

  @override
  String get levelTitles_5 => 'Academician';

  @override
  String get levelTitles_6 => 'Literary Genius';

  @override
  String get levelTitles_7 => 'Wise Saint';

  @override
  String get levelTitles_8 => 'Debating Genius';

  @override
  String get levelTitles_9 => 'Master Scholar';

  @override
  String get levelTitles_10 => 'Virtuous Scholar';

  @override
  String get levelTitles_11 => 'Diligent Student';

  @override
  String get levelTitles_12 => 'Enlightened One';

  @override
  String get levelTitles_13 => 'Profound Philosopher';

  @override
  String get levelTitles_14 => 'Elegant Sage';

  @override
  String get levelTitles_15 => 'Talented Scholar';

  @override
  String profile_date(int month, int year) {
    return 'Month $month Year $year';
  }

  @override
  String get setting_title => 'Settings';

  @override
  String get setting_achivement_title => 'Achievements';

  @override
  String get setting_achivement_content => 'List of earned achievements';

  @override
  String get setting_language_title => 'Language';

  @override
  String get setting_language_content => 'Select display language';

  @override
  String get setting_async_title => 'Sync Data';

  @override
  String get setting_async_content => 'Sync data to the cloud';

  @override
  String get setting_downloadAsync_title => 'Download Data';

  @override
  String get setting_downloadAsync_content => 'Download synced data from your old device';

  @override
  String get setting_signout_title => 'Sign Out';

  @override
  String get setting_signout_content => 'Sign out of your current account';

  @override
  String get achivement_title_one => 'Achievement';

  @override
  String get achivement_owl_title => 'Night Owl';

  @override
  String get achivement_owl_description => 'Study between 12am and 2am';

  @override
  String get achivement_tryhard_title => 'Hardworking Knowledge Seeker';

  @override
  String get achivement_tryhard_description => 'Study between 4am and 6am';

  @override
  String get achivement_habit_title => 'Habit Builder';

  @override
  String get achivement_habit_description => 'Study for 28 consecutive days';

  @override
  String get achivement_title_two => 'Study Streak';

  @override
  String achivement_streak_title(String day) {
    return '$day-Day Streak';
  }

  @override
  String achivement_streak_description(String day) {
    return 'Earned after studying $day consecutive days';
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
  String get bottomSheetAsync_Success_Description => 'Data has been successfully synced';

  @override
  String get bottomSheetAsync_Success_Btn => 'OK';

  @override
  String get bottomSheet_Nointernet_title => 'No Internet Connection';

  @override
  String get bottomSheet_Nointernet_Description => 'Please check your internet connection and try again';

  @override
  String get bottomSheet_Nointernet_Btn => 'OK';

  @override
  String get bottomSheet_Error_title => 'Data Load Error';

  @override
  String get bottomSheet_Error_description => 'No synced data available';

  @override
  String get bottomSheet_Warning_title => 'Warning';

  @override
  String get bottomSheet_Warning_Description => 'When syncing, all data on this device will be deleted';

  @override
  String get bottomSheet_Warning_btn_ok => 'OK';

  @override
  String get bottomSheet_Warning_btn_cancle => 'Cancel';

  @override
  String get language_title => 'Language';

  @override
  String get language_bottomsheet_success => 'Language Updated Successfully';

  @override
  String get error_connect_server => 'Server Connection Error';

  @override
  String get login_title => 'Welcome back, glad to see you';

  @override
  String get login_email_input_hint => 'Email';

  @override
  String get login_email_input_hint_focus => 'Enter your email';

  @override
  String get login_email_input_password => 'Password';

  @override
  String get login_email_input_password_hint => 'Enter Password';

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
  String get login_invalid_email => 'Invalid Email';

  @override
  String get login_user_disabled => 'Account Disabled';

  @override
  String get login_user_not_found => 'No account found with this email';

  @override
  String get login_wrong_password => 'Incorrect password';

  @override
  String get login_error => 'An error occurred';

  @override
  String get register_title => 'Hello, Sign up to start your journey';

  @override
  String get register_email_input_hint => 'Email';

  @override
  String get register_email_input_hint_focus => 'Enter your email';

  @override
  String get register_user_input_hint => 'Username';

  @override
  String get register_user_input_hint_focus => 'Enter username';

  @override
  String get register_password_input_hint => 'Password';

  @override
  String get register_password_input_hint_focus => 'Enter Password';

  @override
  String get register_re_password_input_hint => 'Confirm Password';

  @override
  String get register_re_password_input_hint_focus => 'Re-enter Password';

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
  String get register_operation_not_allowed => 'Email/password account not enabled';

  @override
  String get register_weak_password => 'Weak Password';

  @override
  String get register_error => 'An error occurred';

  @override
  String get register_success => 'Account created successfully, please go back to login';
}
