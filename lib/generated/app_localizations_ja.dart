import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tabbar_home => 'ホーム';

  @override
  String get tabber_distionary => '辞書';

  @override
  String get tabbar_character => '文字表';

  @override
  String get tabbar_info => '情報';

  @override
  String get dashboard_folder => 'マイフォルダー';

  @override
  String get dashboard_folder_seemore => 'すべて表示';

  @override
  String get dashboard_folder_content => 'トピック';

  @override
  String get dashboard_folder_nodata_title => 'フォルダーがありません';

  @override
  String get dashboard_folder_nodata_content => '最初のフォルダーを作成して語彙を整理しましょう';

  @override
  String get dashboard_comunication => 'コミュニティ';

  @override
  String get dashboard_comunication_seemore => 'すべて表示';

  @override
  String course_owner(String user_nane) {
    return '$user_nane';
  }

  @override
  String amount_word(String amount) {
    return '$amount';
  }

  @override
  String get topic_persent => 'パーセント';

  @override
  String get topic_word_finish => '完了';

  @override
  String get topic_word_learning => '未完了';

  @override
  String get add_course => 'コース';

  @override
  String get add_folder => 'フォルダー';

  @override
  String get folderSeemore_title => 'マイフォルダー';

  @override
  String get folderSeemore_grid => 'グリッド';

  @override
  String get folderSeemore_tag_flex => 'リスト';

  @override
  String get folderSeemore_content => 'すべてのフォルダー';

  @override
  String get folderSeemore_subContent => 'フォルダー';

  @override
  String get folderManager_nodata_title => '自分専用のフォルダーを作成しましょう';

  @override
  String get folderManager_nodata_button => '学習トピックを追加';

  @override
  String get folderManager_bottomSheet_addTopic => '学習トピックを追加';

  @override
  String get folderManager_bottomSheet_removeFolder => '削除';

  @override
  String get folderManager_topic_bottomSheet_remove => 'フォルダーから削除';

  @override
  String get folderManager_Screen_addTopic_title => ' 学習トピックを追加';

  @override
  String folderManager_Screen_addTopic_card_owner(String name) {
    return '作者: $name';
  }

  @override
  String folderManager_Screen_addTopic_card_amountWord(int amount) {
    return '単語数: $amount';
  }

  @override
  String get comunication_bottomSheet_notify_download_title => 'ダウンロードしますか？';

  @override
  String get comunication_bottomSheet_notify_download_btn => 'ダウンロード';

  @override
  String get download_Screen_downloading_title => 'トピックをダウンロード中';

  @override
  String get download_Screen_downloading_contetnt => 'しばらくお待ちください...';

  @override
  String get download_Screen_downloading_btn => 'キャンセル';

  @override
  String get download_Screen_Success_title => 'ダウンロード成功';

  @override
  String get download_Screen_Success_contetnt => 'トピックは学習可能になりました';

  @override
  String get download_Screen_Success_btn => '学習開始';

  @override
  String get dashboard_topic_nodata_title => 'トピックがありません';

  @override
  String get dashboard_topic_nodata_content => '最初のトピックを作成して学習を始めましょう';

  @override
  String get communication_Screen_title => 'コミュニティ';

  @override
  String get communication_Screen_hint_search => 'トピック名を入力...';

  @override
  String get communication_Screen_subTitle => 'コミュニティコレクション';

  @override
  String get dashboard_topic => 'マイトピック';

  @override
  String get dashboard_topic_seemore => 'すべて表示';

  @override
  String get topic_seemore_title => 'マイトピック';

  @override
  String get topic_seemore_subTitle => 'トピック';

  @override
  String get bottomSheet_add_topic => 'コース';

  @override
  String get bottomSheet_add_folder => 'フォルダー';

  @override
  String get popup_add_topic => '新しいトピックを追加';

  @override
  String get popup_add_topic_hint => 'トピック名';

  @override
  String get popup_add_topic_exit => 'トピック名は既に存在します';

  @override
  String get popup_add_topic_btn_create => '作成';

  @override
  String get popup_add_topic_btn_cancle => 'キャンセル';

  @override
  String get addWord_Screen_Input_Japan_Label => '日本語の語彙';

  @override
  String get addWord_Screen_Input_Japan_Hint => '日本語の単語';

  @override
  String get addWord_Screen_Input_WayRead_Label => '読み方（ひらがな）';

  @override
  String get addWord_Screen_Input_WayRead_Hint => 'よみかた';

  @override
  String get addWord_Screen_Input_Mean_Label => '意味';

  @override
  String get addWord_Screen_Input_Mean_Hint => '意味';

  @override
  String get addWord_Screen_btn_add => '単語を追加';

  @override
  String get addWord_bottomShet_warning_save_title => '警告';

  @override
  String get addWord_bottomShet_warning_save_content => '保存すると編集できなくなります';

  @override
  String get addWord_bottomShet_warning_save_btn => '保存';

  @override
  String get addWord_bottomShet_success_save_title => '保存成功';

  @override
  String get addWord_bottomShet_success_save_content => '作成したトピックが正常に保存されました 🎉';

  @override
  String get addWord_bottomShet_success_save_btn => 'OK';

  @override
  String get listword_Screen_title => 'トピック';

  @override
  String get listword_Screen_AmountWord => '語彙';

  @override
  String get listword_Screen_Learned => '習得済み';

  @override
  String get listword_Screen_head_col1 => '日本語';

  @override
  String get listword_Screen_head_col2 => '意味';

  @override
  String get listword_Screen_head_col3 => '状態';

  @override
  String get listword_Screen_bottomSheet_public_title => '共有しますか？';

  @override
  String get listword_Screen_bottomSheet_public_content => '共有すると誰でもダウンロードできます';

  @override
  String get listword_Screen_bottomSheet_public_btn_pulic => '公開';

  @override
  String get listword_Screen_bottomSheet_public_btn_cancel => 'キャンセル';

  @override
  String get listword_Screen_bottomSheet_public_succes_title => 'おめでとうございます';

  @override
  String get listword_Screen_bottomSheet_public_succes_content => 'あなたのトピックを正常に共有しました';

  @override
  String get listword_Screen_bottomSheet_public_succes_btn_ok => 'OK';

  @override
  String get listword_Screen_bottomSheet_private_title => '共有を取り消しますか？';

  @override
  String get listword_Screen_bottomSheet_private_btn_private => '共有を取り消す';

  @override
  String get listword_Screen_bottomSheet_private_btn_cancel => 'いいえ';

  @override
  String get listword_Screen_bottomSheet_private_success_title => '公開取り消し成功';

  @override
  String get listword_Screen_bottomSheet_private_success_content => 'トピックの共有を取り消しました';

  @override
  String get listword_Screen_bottomSheet_private_success_OK => 'OK';

  @override
  String get listword_Screen_btn_learn => '今すぐ学習';

  @override
  String get keyboard_handwriting_btn_space => 'スペース';

  @override
  String get keyboard_handwriting_btn_remove => '削除';

  @override
  String get distionary_Screen_title => '日本語辞典';

  @override
  String get distionary_Screen_hint => '調べたい単語を入力';

  @override
  String get distionary_Screen_hint_title => '語彙を検索';

  @override
  String get distionary_Screen_hint_content => '単語を調べて学び始めましょう';

  @override
  String get distionary_Screen_mean => '意味';

  @override
  String get distionary_Screen_info => '単語情報';

  @override
  String get distionary_Screen_type => '名詞: ';

  @override
  String get distionary_Screen_level => 'レベル: ';

  @override
  String get popup_remove_topic_title => 'トピックを削除';

  @override
  String get popup_remove_topic_content => '削除しますか？';

  @override
  String get popup_remove_topic_btn_cancle => 'キャンセル';

  @override
  String get popup_remove_topic_btn_delete => '削除';

  @override
  String get character_btn_learn => '文字を学ぶ';

  @override
  String listWord_word_complete(String count) {
    return '$count 完了';
  }

  @override
  String listWord_word_learning(String count) {
    return '$count 未完了';
  }

  @override
  String get listWord_btn_learn => '単語を学ぶ';

  @override
  String listWord_share_title(String topic) {
    return 'トピック名 $topic';
  }

  @override
  String listWord_share_amount_word(String amount) {
    return '単語数: $amount 語';
  }

  @override
  String listWord_share_type(String type) {
    return 'タイプ: $type';
  }

  @override
  String get listWord_btn_remove => '削除';

  @override
  String get listWord_btn_shared => '共有';

  @override
  String get learn_warningGboard => 'より良い体験のために Gboard を使用することを推奨します';

  @override
  String get learn_btn_check => '確認';

  @override
  String get learn_bottomsheet_wrong_title => '不正解';

  @override
  String get learn_bottomsheet_wrong_content => '正しい答えは';

  @override
  String get learn_bottomsheet_wrong_btn => '続ける';

  @override
  String get learn_write_input => '書く';

  @override
  String get learn_bottomsheet_right_title => '正解';

  @override
  String get motivationalPhrases_1 => 'その調子！とてもよくできています！';

  @override
  String get motivationalPhrases_2 => '今回は完璧です、その調子で頑張ろう！';

  @override
  String get motivationalPhrases_3 => '一歩ずつの進歩が成果です！';

  @override
  String get motivationalPhrases_4 => '自分を信じて努力を続けましょう！';

  @override
  String get motivationalPhrases_5 => 'あなたならできる、絶対に諦めないで！';

  @override
  String get motivationalPhrases_6 => '努力を続ける者に成功は訪れます！';

  @override
  String get motivationalPhrases_7 => '一歩ずつ改善を重ねましょう！';

  @override
  String get motivationalPhrases_8 => '強く集中して前進を続けましょう！';

  @override
  String get motivationalPhrases_9 => '素晴らしい努力です！さらに高い目標を！';

  @override
  String get motivationalPhrases_10 => 'あなたの努力は必ず報われます！';

  @override
  String get learn_bottomsheet_right_btn => '続ける';

  @override
  String get learning_combine_title => 'A列の単語をB列に移す';

  @override
  String get learn_translate_title => '下の文を翻訳';

  @override
  String get learn_listen_title => '聞き取れた内容';

  @override
  String get learn_chose_title => '正しい単語を選択';

  @override
  String get congraculate_title => '完了';

  @override
  String get congraculate_content => '素晴らしい！';

  @override
  String get congraculate_commited => '時間';

  @override
  String get congraculate_amzing => '素晴らしい';

  @override
  String get profile_level => 'レベル';

  @override
  String get profile_topic => 'トピック';

  @override
  String get profile_title => '称号';

  @override
  String get levelTitles_1 => '学士';

  @override
  String get levelTitles_2 => '賢者';

  @override
  String get levelTitles_3 => '思想家';

  @override
  String get levelTitles_4 => '学者';

  @override
  String get levelTitles_5 => 'アカデミック学士';

  @override
  String get levelTitles_6 => '文学の天才';

  @override
  String get levelTitles_7 => '知恵の聖人';

  @override
  String get levelTitles_8 => '議論の天才';

  @override
  String get levelTitles_9 => '道学の達人';

  @override
  String get levelTitles_10 => '文士';

  @override
  String get levelTitles_11 => '修練学士';

  @override
  String get levelTitles_12 => '聡明者';

  @override
  String get levelTitles_13 => '賢哲';

  @override
  String get levelTitles_14 => '文雅者';

  @override
  String get levelTitles_15 => '才能ある賢者';

  @override
  String profile_date(int month, int year) {
    return '$month月 $year年';
  }

  @override
  String get setting_title => '設定';

  @override
  String get setting_achivement_title => '実績';

  @override
  String get setting_achivement_content => '獲得した実績のリスト';

  @override
  String get setting_language_title => '言語';

  @override
  String get setting_language_content => '表示言語を選択';

  @override
  String get setting_async_title => 'データ同期';

  @override
  String get setting_async_content => 'クラウドにデータを同期';

  @override
  String get setting_downloadAsync_title => 'データをダウンロード';

  @override
  String get setting_downloadAsync_content => '以前同期したデータをダウンロード';

  @override
  String get setting_signout_title => 'ログアウト';

  @override
  String get setting_signout_content => '現在のアカウントからログアウト';

  @override
  String get achivement_title_one => '実績';

  @override
  String get achivement_owl_title => '夜更かし学習';

  @override
  String get achivement_owl_description => '0時から2時まで学習';

  @override
  String get achivement_tryhard_title => '勤勉な知識人';

  @override
  String get achivement_tryhard_description => '4時から6時まで学習';

  @override
  String get achivement_habit_title => '習慣形成';

  @override
  String get achivement_habit_description => '28日間連続で学習';

  @override
  String get achivement_title_two => '学習連続日数';

  @override
  String achivement_streak_title(String day) {
    return '$day日連続';
  }

  @override
  String achivement_streak_description(String day) {
    return '$day日連続で学習すると獲得';
  }

  @override
  String get achivement_title_three => '完了トピック';

  @override
  String achivement_topic_title(String amount) {
    return '$amount トピック';
  }

  @override
  String achivement_topic_description(String amount) {
    return '$amountトピック完了で獲得';
  }

  @override
  String get bottomSheetAsync_Success_Description => 'データは正常に同期されました';

  @override
  String get bottomSheetAsync_Success_Btn => 'OK';

  @override
  String get bottomSheet_Nointernet_title => 'インターネット接続なし';

  @override
  String get bottomSheet_Nointernet_Description => 'インターネット接続を確認して再試行してください';

  @override
  String get bottomSheet_Nointernet_Btn => 'OK';

  @override
  String get bottomSheet_Error_title => 'データ取得エラー';

  @override
  String get bottomSheet_Error_description => '同期済みデータはありません';

  @override
  String get bottomSheet_Warning_title => '警告';

  @override
  String get bottomSheet_Warning_Description => '同期すると現在のデータは削除されます';

  @override
  String get bottomSheet_Warning_btn_ok => 'OK';

  @override
  String get bottomSheet_Warning_btn_cancle => 'キャンセル';

  @override
  String get language_title => '言語';

  @override
  String get language_bottomsheet_success => '言語更新成功';

  @override
  String get error_connect_server => 'サーバー接続エラー';

  @override
  String get login_title => 'おかえりなさい。お会いできて嬉しいです';

  @override
  String get login_email_input_hint => 'メール';

  @override
  String get login_email_input_hint_focus => 'メールを入力';

  @override
  String get login_email_input_password => 'パスワード';

  @override
  String get login_email_input_password_hint => 'パスワードを入力';

  @override
  String get login_btn => 'ログイン';

  @override
  String get login_create_question_account => 'アカウントがありません';

  @override
  String get login_create_btn_account => '登録';

  @override
  String get login_with_facebook => 'Facebookでログイン';

  @override
  String get login_with_google => 'Googleでログイン';

  @override
  String get login_invalid_email => '無効なメールアドレス';

  @override
  String get login_user_disabled => 'アカウントは無効です';

  @override
  String get login_user_not_found => 'メールアドレスに対応するアカウントが見つかりません';

  @override
  String get login_wrong_password => 'パスワードが正しくありません';

  @override
  String get login_error => 'エラーが発生しました';

  @override
  String get register_title => 'こんにちは、登録して学習を始めましょう';

  @override
  String get register_email_input_hint => 'メール';

  @override
  String get register_email_input_hint_focus => 'メールを入力';

  @override
  String get register_user_input_hint => 'ユーザー名';

  @override
  String get register_user_input_hint_focus => 'ユーザー名を入力';

  @override
  String get register_password_input_hint => 'パスワード';

  @override
  String get register_password_input_hint_focus => 'パスワードを入力';

  @override
  String get register_re_password_input_hint => 'パスワード再入力';

  @override
  String get register_re_password_input_hint_focus => 'パスワード再入力';

  @override
  String get register_btn => '登録';

  @override
  String get register_question_login => 'すでにアカウントをお持ちですか？';

  @override
  String get register_btn_login => 'ログイン';

  @override
  String get register_email_already_in_use => 'このメールはすでに登録されています';

  @override
  String get register_invalid_email => '無効なメールアドレスです';

  @override
  String get register_operation_not_allowed => 'メール/パスワードアカウントは有効化されていません';

  @override
  String get register_weak_password => 'パスワードが弱すぎます';

  @override
  String get register_error => 'エラーが発生しました';

  @override
  String get register_success => 'アカウント作成成功。ログイン画面に戻ります';
}
