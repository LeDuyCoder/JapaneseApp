import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tabbar_home => '首页';

  @override
  String get tabbar_character => '字母';

  @override
  String get tabbar_info => '信息';

  @override
  String get dashboard_hintSearch => '想要搜索的单词';

  @override
  String get dashboard_folder => '文件夹';

  @override
  String get dashboard_course => '课程';

  @override
  String get dashboard_topic => '主题';

  @override
  String get dashboard_popupDownload_title => '要下载吗？';

  @override
  String get dashboard_popupDownload_btn_cancel => '取消';

  @override
  String get dashboard_popupDownload_btn_dowload => '下载';

  @override
  String get dashboard_seemore => '查看更多';

  @override
  String get dashboard_btn_import => '导入';

  @override
  String get tutorial_one_title => '安装应用';

  @override
  String get tutorial_one_content => '请确认设备中已安装Gboard应用';

  @override
  String get tutorial_two_title => '打开设置';

  @override
  String get tutorial_two_content => '打开设置应用，配置日语手写键盘';

  @override
  String get tutorial_three_title => '搜索Gboard';

  @override
  String get tutorial_three_content => '搜索并找到Gboard，按照图片操作点击';

  @override
  String get tutorial_four_title => 'Gboard';

  @override
  String get tutorial_four_content => '按照指示继续点击';

  @override
  String get tutorial_five_title => '语言';

  @override
  String get tutorial_five_content => '点击语言部分';

  @override
  String get tutorial_six_title => '添加键盘';

  @override
  String get tutorial_six_content => '添加键盘并选择日语';

  @override
  String get tutorial_seven_title => '搜索日语';

  @override
  String get tutorial_seven_content => '搜索日语';

  @override
  String get tutorial_eight_title => '手写输入';

  @override
  String get tutorial_eight_content => '选择手写键盘，点击“完成”';

  @override
  String get tutorial_nice_title => '切换键盘';

  @override
  String get tutorial_nice_content => '练习时切换键盘以增强记忆';

  @override
  String get tutorial_btn_back => '返回';

  @override
  String get tutorial_btn_forward => '下一步';

  @override
  String get tutorial_btn_skip => '跳过';

  @override
  String get tutorial_one_done => '完成';

  @override
  String course_owner(String user_nane) {
    return '由 $user_nane 创建';
  }

  @override
  String amount_word(String amount) {
    return '单词数: $amount 个';
  }

  @override
  String word_finish(String amount) {
    return '完成: $amount';
  }

  @override
  String word_learning(String amount) {
    return '未完成: $amount';
  }

  @override
  String get add_course => '课程';

  @override
  String get add_folder => '文件夹';

  @override
  String get folderManager => '添加课程主题';

  @override
  String get folderManager_addTopic => '添加主题';

  @override
  String get folderManager_remove => '删除';

  @override
  String get folderManager_removeTopic => '从文件夹删除';

  @override
  String get seemore_search => '文件夹名称';

  @override
  String get import_title => '选择导入方式';

  @override
  String get import_btn_file => '从文件导入';

  @override
  String get import_btn_qr => '通过QR导入';

  @override
  String get character_btn_learn => '学习字符';

  @override
  String listWord_word_complete(String count) {
    return '完成 $count';
  }

  @override
  String listWord_word_learning(String count) {
    return '未完成 $count';
  }

  @override
  String get listWord_btn_learn => '学习单词';

  @override
  String listWord_share_title(String topic) {
    return '主题名: $topic';
  }

  @override
  String listWord_share_amount_word(String amount) {
    return '单词数: $amount 个';
  }

  @override
  String listWord_share_type(String type) {
    return '类型: $type';
  }

  @override
  String get listWord_btn_remove => '删除';

  @override
  String get listWord_btn_shared => '分享';

  @override
  String get learn_warningGboard => '为获得最佳体验，推荐使用Gboard';

  @override
  String get learn_btn_check => '确认';

  @override
  String get learn_bottomsheet_wrong_title => '错误';

  @override
  String get learn_bottomsheet_wrong_content => '正确答案是';

  @override
  String get learn_bottomsheet_wrong_btn => '继续';

  @override
  String get learn_write_input => '书写';

  @override
  String get learn_bottomsheet_right_title => '正确';

  @override
  String get motivationalPhrases_1 => '干得好！继续保持！';

  @override
  String get motivationalPhrases_2 => '这次也很棒，下次继续加油！';

  @override
  String get motivationalPhrases_3 => '每一步进步都是成长！';

  @override
  String get motivationalPhrases_4 => '相信自己，不断挑战！';

  @override
  String get motivationalPhrases_5 => '只要不放弃，就一定能成功！';

  @override
  String get motivationalPhrases_6 => '成功属于坚持不懈的人！';

  @override
  String get motivationalPhrases_7 => '一步一步稳步成长！';

  @override
  String get motivationalPhrases_8 => '保持专注，继续努力！';

  @override
  String get motivationalPhrases_9 => '了不起的努力！继续向上！';

  @override
  String get motivationalPhrases_10 => '努力必有回报！';

  @override
  String get learn_bottomsheet_right_btn => '继续';

  @override
  String get learning_combine_title => '将A列与B列匹配';

  @override
  String get learn_translate_title => '请翻译以下句子';

  @override
  String get learn_listen_title => '你听到了什么？';

  @override
  String get learn_chose_title => '哪个单词是正确的？';

  @override
  String get congraculate_title => '完成';

  @override
  String get congraculate_content => '太棒了！';

  @override
  String get congraculate_commited => '学习时间';

  @override
  String get congraculate_amzing => '了不起';

  @override
  String get profile_level => '等级';

  @override
  String get profile_topic => '主题';

  @override
  String get profile_title => '称号';

  @override
  String get levelTitles_1 => '学者';

  @override
  String get levelTitles_2 => '贤者';

  @override
  String get levelTitles_3 => '思想家';

  @override
  String get levelTitles_4 => '荣誉学者';

  @override
  String get levelTitles_5 => '学术学者';

  @override
  String get levelTitles_6 => '文才天才';

  @override
  String get levelTitles_7 => '圣人';

  @override
  String get levelTitles_8 => '辩论天才';

  @override
  String get levelTitles_9 => '学习达人';

  @override
  String get levelTitles_10 => '文学绅士';

  @override
  String get levelTitles_11 => '有纪律的学者';

  @override
  String get levelTitles_12 => '开悟者';

  @override
  String get levelTitles_13 => '深邃贤者';

  @override
  String get levelTitles_14 => '优雅导师';

  @override
  String get levelTitles_15 => '智慧天才';

  @override
  String profile_date(int month, int year) {
    return '$year年$month月';
  }

  @override
  String get setting_title => '设置';

  @override
  String get setting_achivement_title => '成就';

  @override
  String get setting_achivement_content => '已解锁成就列表';

  @override
  String get setting_language_title => '语言';

  @override
  String get setting_language_content => '选择显示语言';

  @override
  String get setting_async_title => '数据同步';

  @override
  String get setting_async_content => '将数据同步到云端';

  @override
  String get setting_downloadAsync_title => '下载数据';

  @override
  String get setting_downloadAsync_content => '从以前设备下载已同步的数据';

  @override
  String get setting_signout_title => '退出登录';

  @override
  String get setting_signout_content => '从当前账户登出';

  @override
  String get achivement_title_one => '成就';

  @override
  String get achivement_owl_title => '夜猫子';

  @override
  String get achivement_owl_description => '在凌晨0点到2点间学习';

  @override
  String get achivement_tryhard_title => '早起学习者';

  @override
  String get achivement_tryhard_description => '在凌晨4点到6点间学习';

  @override
  String get achivement_habit_title => '习惯养成者';

  @override
  String get achivement_habit_description => '连续28天学习';

  @override
  String get achivement_title_two => '连续学习天数';

  @override
  String achivement_streak_title(String day) {
    return '连续 $day 天';
  }

  @override
  String achivement_streak_description(String day) {
    return '连续学习 $day 天';
  }

  @override
  String get achivement_title_three => '主题完成';

  @override
  String achivement_topic_title(String amount) {
    return '$amount 个主题';
  }

  @override
  String achivement_topic_description(String amount) {
    return '完成 $amount 个主题';
  }

  @override
  String get bottomSheetAsync_Success_Description => '数据已成功同步';

  @override
  String get bottomSheetAsync_Success_Btn => '确定';

  @override
  String get bottomSheet_Nointernet_title => '无网络连接';

  @override
  String get bottomSheet_Nointernet_Description => '请检查网络连接后重试';

  @override
  String get bottomSheet_Nointernet_Btn => '确定';

  @override
  String get bottomSheet_Warning_title => '警告';

  @override
  String get bottomSheet_Warning_Description => '同步后，设备上的本地数据将全部删除';

  @override
  String get bottomSheet_Warning_btn_ok => '确定';

  @override
  String get bottomSheet_Warning_btn_cancle => '取消';

  @override
  String get bottomSheet_Error_title => '数据下载错误';

  @override
  String get bottomSheet_Error_description => '当前没有可用的同步数据';

  @override
  String get language_title => '语言';

  @override
  String get language_bottomsheet_success => '语言已成功更新';

  @override
  String get error_connect_server => '无法连接服务器';

  @override
  String get login_title => '欢迎回来，很高兴见到你';

  @override
  String get login_email_input_hint => '邮箱地址';

  @override
  String get login_email_input_hint_focus => '请输入邮箱地址';

  @override
  String get login_email_input_password => '密码';

  @override
  String get login_email_input_password_hint => '请输入密码';

  @override
  String get login_btn => '登录';

  @override
  String get login_create_question_account => '没有账户吗？';

  @override
  String get login_create_btn_account => '注册';

  @override
  String get login_with_facebook => '使用Facebook登录';

  @override
  String get login_with_google => '使用Google登录';

  @override
  String get login_invalid_email => '无效邮箱地址';

  @override
  String get login_user_disabled => '该账户已被禁用';

  @override
  String get login_user_not_found => '未找到该邮箱的账户';

  @override
  String get login_wrong_password => '密码错误';

  @override
  String get login_error => '发生错误';

  @override
  String get register_title => '你好，注册并开始吧';

  @override
  String get register_email_input_hint => '邮箱地址';

  @override
  String get register_email_input_hint_focus => '请输入邮箱地址';

  @override
  String get register_user_input_hint => '用户名';

  @override
  String get register_user_input_hint_focus => '请输入用户名';

  @override
  String get register_password_input_hint => '密码';

  @override
  String get register_password_input_hint_focus => '请输入密码';

  @override
  String get register_re_password_input_hint => '再次输入密码';

  @override
  String get register_re_password_input_hint_focus => '请再次输入密码';

  @override
  String get register_btn => '注册';

  @override
  String get register_question_login => '已有账户？';

  @override
  String get register_btn_login => '登录';

  @override
  String get register_email_already_in_use => '该邮箱已被注册';

  @override
  String get register_invalid_email => '无效邮箱地址';

  @override
  String get register_operation_not_allowed => '邮箱/密码登录未启用';

  @override
  String get register_weak_password => '密码太弱';

  @override
  String get register_error => '发生错误';

  @override
  String get register_success => '账户已创建，请返回登录页面';
}
