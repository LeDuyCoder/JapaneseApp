import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tabbar_home => 'ホーム';

  @override
  String get tabbar_character => 'アルファベット';

  @override
  String get tabbar_info => '情報';

  @override
  String get dashboard_hintSearch => '検索したい単語';

  @override
  String get dashboard_folder => 'フォルダー';

  @override
  String get dashboard_course => 'コース';

  @override
  String get dashboard_topic => 'トピック';

  @override
  String get dashboard_popupDownload_title => 'ダウンロードしますか？';

  @override
  String get dashboard_popupDownload_btn_cancel => 'キャンセル';

  @override
  String get dashboard_popupDownload_btn_dowload => 'ダウンロード';

  @override
  String get dashboard_seemore => 'もっと見る';

  @override
  String get dashboard_btn_import => 'インポート';

  @override
  String get tutorial_one_title => 'アプリをインストール';

  @override
  String get tutorial_one_content => '端末にGboardアプリがインストールされていることを確認してください';

  @override
  String get tutorial_two_title => '設定を開く';

  @override
  String get tutorial_two_content => '設定アプリを開き、日本語手書きキーボードを設定します';

  @override
  String get tutorial_three_title => 'Gboardを検索';

  @override
  String get tutorial_three_content => '検索してGboardを見つけ、画像の通りにタップしてください';

  @override
  String get tutorial_four_title => 'Gboard';

  @override
  String get tutorial_four_content => '指示通りにタップを続けてください';

  @override
  String get tutorial_five_title => '言語';

  @override
  String get tutorial_five_content => '言語セクションをタップしてください';

  @override
  String get tutorial_six_title => 'キーボードを追加';

  @override
  String get tutorial_six_content => 'キーボードを追加して日本語を選択してください';

  @override
  String get tutorial_seven_title => '日本語を検索';

  @override
  String get tutorial_seven_content => '日本語を検索してください';

  @override
  String get tutorial_eight_title => '手書き入力';

  @override
  String get tutorial_eight_content => '手書きキーボードを選択し、「完了」をタップしてください';

  @override
  String get tutorial_nice_title => 'キーボードを切り替え';

  @override
  String get tutorial_nice_content => '練習の際はキーボードを切り替えて記憶を強化しましょう';

  @override
  String get tutorial_btn_back => '戻る';

  @override
  String get tutorial_btn_forward => '次へ';

  @override
  String get tutorial_btn_skip => 'スキップ';

  @override
  String get tutorial_one_done => '完了';

  @override
  String course_owner(String user_nane) {
    return '$user_nane によって作成';
  }

  @override
  String amount_word(String amount) {
    return '単語数: $amount 語';
  }

  @override
  String word_finish(String amount) {
    return '完了: $amount';
  }

  @override
  String word_learning(String amount) {
    return '未完了: $amount';
  }

  @override
  String get add_course => 'コース';

  @override
  String get add_folder => 'フォルダー';

  @override
  String get folderManager => 'コーストピックを追加';

  @override
  String get folderManager_addTopic => 'トピックを追加';

  @override
  String get folderManager_remove => '削除';

  @override
  String get folderManager_removeTopic => 'フォルダーから削除';

  @override
  String get seemore_search => 'フォルダー名';

  @override
  String get import_title => 'インポート方法を選択';

  @override
  String get import_btn_file => 'ファイルから';

  @override
  String get import_btn_qr => 'QRから';

  @override
  String get character_btn_learn => '文字を学ぶ';

  @override
  String listWord_word_complete(String count) {
    return '完了 $count';
  }

  @override
  String listWord_word_learning(String count) {
    return '未完了 $count';
  }

  @override
  String get listWord_btn_learn => '単語を学ぶ';

  @override
  String listWord_share_title(String topic) {
    return 'トピック名: $topic';
  }

  @override
  String listWord_share_amount_word(String amount) {
    return '単語数: $amount 語';
  }

  @override
  String listWord_share_type(String type) {
    return '種類: $type';
  }

  @override
  String get listWord_btn_remove => '削除';

  @override
  String get listWord_btn_shared => '共有';

  @override
  String get learn_warningGboard => '最適な体験のためにGboardを推奨します';

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
  String get motivationalPhrases_1 => 'その調子！よくできています！';

  @override
  String get motivationalPhrases_2 => '今回もよくできました、次も頑張ろう！';

  @override
  String get motivationalPhrases_3 => '一歩前進するごとに成長です！';

  @override
  String get motivationalPhrases_4 => '自分を信じて挑戦し続けてください！';

  @override
  String get motivationalPhrases_5 => '諦めなければ必ずできます！';

  @override
  String get motivationalPhrases_6 => '成功は諦めない人に訪れます！';

  @override
  String get motivationalPhrases_7 => '一歩ずつ着実に成長しましょう！';

  @override
  String get motivationalPhrases_8 => '強く、集中して、続けましょう！';

  @override
  String get motivationalPhrases_9 => '素晴らしい努力です！さらに上を目指しましょう！';

  @override
  String get motivationalPhrases_10 => '努力は必ず報われます！';

  @override
  String get learn_bottomsheet_right_btn => '続ける';

  @override
  String get learning_combine_title => 'A列とB列をマッチさせましょう';

  @override
  String get learn_translate_title => '次の文を翻訳してください';

  @override
  String get learn_listen_title => '何と聞こえましたか？';

  @override
  String get learn_chose_title => '正しい単語はどれですか？';

  @override
  String get congraculate_title => '完了';

  @override
  String get congraculate_content => '素晴らしい！';

  @override
  String get congraculate_commited => '学習時間';

  @override
  String get congraculate_amzing => 'すごい';

  @override
  String get profile_level => 'レベル';

  @override
  String get profile_topic => 'トピック';

  @override
  String get profile_title => '称号';

  @override
  String get levelTitles_1 => '学者';

  @override
  String get levelTitles_2 => '賢者';

  @override
  String get levelTitles_3 => '思想家';

  @override
  String get levelTitles_4 => '名誉ある学者';

  @override
  String get levelTitles_5 => '学術学者';

  @override
  String get levelTitles_6 => '文才の天才';

  @override
  String get levelTitles_7 => '聖人';

  @override
  String get levelTitles_8 => '討論の天才';

  @override
  String get levelTitles_9 => '学習の達人';

  @override
  String get levelTitles_10 => '文学紳士';

  @override
  String get levelTitles_11 => '規律ある学者';

  @override
  String get levelTitles_12 => '悟りを開いた者';

  @override
  String get levelTitles_13 => '深遠な賢者';

  @override
  String get levelTitles_14 => '優雅な師';

  @override
  String get levelTitles_15 => '知性の天才';

  @override
  String profile_date(int month, int year) {
    return '$year年$month月';
  }

  @override
  String get setting_title => '設定';

  @override
  String get setting_achivement_title => '実績';

  @override
  String get setting_achivement_content => '解除した実績の一覧';

  @override
  String get setting_language_title => '言語';

  @override
  String get setting_language_content => '表示言語を選択';

  @override
  String get setting_async_title => 'データ同期';

  @override
  String get setting_async_content => 'データをクラウドに同期';

  @override
  String get setting_downloadAsync_title => 'データをダウンロード';

  @override
  String get setting_downloadAsync_content => '以前の端末から同期済みデータをダウンロード';

  @override
  String get setting_signout_title => 'ログアウト';

  @override
  String get setting_signout_content => '現在のアカウントからサインアウト';

  @override
  String get achivement_title_one => '実績';

  @override
  String get achivement_owl_title => '夜更かしフクロウ';

  @override
  String get achivement_owl_description => '午前0時から2時の間に学習した';

  @override
  String get achivement_tryhard_title => '早起き学習者';

  @override
  String get achivement_tryhard_description => '午前4時から6時の間に学習した';

  @override
  String get achivement_habit_title => '習慣の構築者';

  @override
  String get achivement_habit_description => '28日間連続で学習した';

  @override
  String get achivement_title_two => '学習連続日数';

  @override
  String achivement_streak_title(String day) {
    return '$day日連続';
  }

  @override
  String achivement_streak_description(String day) {
    return '$day日連続で学習した';
  }

  @override
  String get achivement_title_three => 'トピック完了';

  @override
  String achivement_topic_title(String amount) {
    return '$amount トピック';
  }

  @override
  String achivement_topic_description(String amount) {
    return '$amount トピックを完了した';
  }

  @override
  String get bottomSheetAsync_Success_Description => 'データが正常に同期されました';

  @override
  String get bottomSheetAsync_Success_Btn => 'OK';

  @override
  String get bottomSheet_Nointernet_title => 'インターネット接続なし';

  @override
  String get bottomSheet_Nointernet_Description => 'インターネット接続を確認して、もう一度お試しください';

  @override
  String get bottomSheet_Nointernet_Btn => 'OK';

  @override
  String get bottomSheet_Warning_title => '警告';

  @override
  String get bottomSheet_Warning_Description => '同期すると、この端末のローカルデータはすべて削除されます';

  @override
  String get bottomSheet_Warning_btn_ok => 'OK';

  @override
  String get bottomSheet_Warning_btn_cancle => 'キャンセル';

  @override
  String get bottomSheet_Error_title => 'データダウンロードエラー';

  @override
  String get bottomSheet_Error_description => '現在利用可能な同期データはありません';

  @override
  String get language_title => '言語';

  @override
  String get language_bottomsheet_success => '言語が正常に更新されました';

  @override
  String get error_connect_server => 'サーバーに接続できませんでした';

  @override
  String get login_title => 'お帰りなさい、お会いできて嬉しいです';

  @override
  String get login_email_input_hint => 'メールアドレス';

  @override
  String get login_email_input_hint_focus => 'メールアドレスを入力してください';

  @override
  String get login_email_input_password => 'パスワード';

  @override
  String get login_email_input_password_hint => 'パスワードを入力してください';

  @override
  String get login_btn => 'ログイン';

  @override
  String get login_create_question_account => 'アカウントをお持ちでないですか？';

  @override
  String get login_create_btn_account => '新規登録';

  @override
  String get login_with_facebook => 'Facebookでログイン';

  @override
  String get login_with_google => 'Googleでログイン';

  @override
  String get login_invalid_email => '無効なメールアドレスです';

  @override
  String get login_user_disabled => 'このアカウントは無効になっています';

  @override
  String get login_user_not_found => 'このメールのアカウントは見つかりませんでした';

  @override
  String get login_wrong_password => 'パスワードが間違っています';

  @override
  String get login_error => 'エラーが発生しました';

  @override
  String get register_title => 'こんにちは、登録して始めましょう';

  @override
  String get register_email_input_hint => 'メールアドレス';

  @override
  String get register_email_input_hint_focus => 'メールアドレスを入力してください';

  @override
  String get register_user_input_hint => 'ユーザー名';

  @override
  String get register_user_input_hint_focus => 'ユーザー名を入力してください';

  @override
  String get register_password_input_hint => 'パスワード';

  @override
  String get register_password_input_hint_focus => 'パスワードを入力してください';

  @override
  String get register_re_password_input_hint => 'パスワードを再入力';

  @override
  String get register_re_password_input_hint_focus => 'もう一度パスワードを入力してください';

  @override
  String get register_btn => '新規登録';

  @override
  String get register_question_login => 'すでにアカウントをお持ちですか？';

  @override
  String get register_btn_login => 'ログイン';

  @override
  String get register_email_already_in_use => 'このメールはすでに登録されています';

  @override
  String get register_invalid_email => '無効なメールアドレスです';

  @override
  String get register_operation_not_allowed => 'メール/パスワードでのサインインは有効ではありません';

  @override
  String get register_weak_password => 'パスワードが弱すぎます';

  @override
  String get register_error => 'エラーが発生しました';

  @override
  String get register_success => 'アカウントが作成されました。ログインページに戻ってください';
}
