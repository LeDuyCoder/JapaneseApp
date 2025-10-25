import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tabbar_home => '首页';

  @override
  String get tabber_distionary => '词典';

  @override
  String get tabbar_character => '字母表';

  @override
  String get tabbar_info => '信息';

  @override
  String get dashboard_folder => '我的文件夹';

  @override
  String get dashboard_folder_seemore => '查看全部';

  @override
  String get dashboard_folder_content => '主题';

  @override
  String get dashboard_folder_nodata_title => '暂无文件夹';

  @override
  String get dashboard_folder_nodata_content => '创建第一个文件夹来整理您的词汇';

  @override
  String get dashboard_comunication => '社区';

  @override
  String get dashboard_comunication_seemore => '查看全部';

  @override
  String course_owner(String user_nane) {
    return '$user_nane';
  }

  @override
  String amount_word(String amount) {
    return '$amount';
  }

  @override
  String get topic_persent => '百分比';

  @override
  String get topic_word_finish => '已完成';

  @override
  String get topic_word_learning => '未完成';

  @override
  String get add_course => '学习单元';

  @override
  String get add_folder => '文件夹';

  @override
  String get folderSeemore_title => '我的文件夹';

  @override
  String get folderSeemore_grid => '网格';

  @override
  String get folderSeemore_tag_flex => '列表';

  @override
  String get folderSeemore_content => '所有文件夹';

  @override
  String get folderSeemore_subContent => '文件夹';

  @override
  String get folderManager_nodata_title => '开始创建您的专属文件夹';

  @override
  String get folderManager_nodata_button => '添加学习主题';

  @override
  String get folderManager_bottomSheet_addTopic => '添加学习主题';

  @override
  String get folderManager_bottomSheet_removeFolder => '删除';

  @override
  String get folderManager_topic_bottomSheet_remove => '从文件夹中删除';

  @override
  String get folderManager_Screen_addTopic_title => '添加学习主题单元';

  @override
  String folderManager_Screen_addTopic_card_owner(String name) {
    return '作者: $name';
  }

  @override
  String folderManager_Screen_addTopic_card_amountWord(int amount) {
    return '单词数: $amount';
  }

  @override
  String get comunication_bottomSheet_notify_download_title => '您想下载吗？';

  @override
  String get comunication_bottomSheet_notify_download_btn => '下载';

  @override
  String get download_Screen_downloading_title => '主题下载中';

  @override
  String get download_Screen_downloading_contetnt => '请稍候...';

  @override
  String get download_Screen_downloading_btn => '取消';

  @override
  String get download_Screen_Success_title => '下载成功';

  @override
  String get download_Screen_Success_contetnt => '主题已准备好学习';

  @override
  String get download_Screen_Success_btn => '开始学习';

  @override
  String get dashboard_topic_nodata_title => '暂无主题';

  @override
  String get dashboard_topic_nodata_content => '创建第一个主题开始学习';

  @override
  String get communication_Screen_title => '社区';

  @override
  String get communication_Screen_hint_search => '输入主题名称...';

  @override
  String get communication_Screen_subTitle => '社区合集';

  @override
  String get dashboard_topic => '我的主题';

  @override
  String get dashboard_topic_seemore => '查看全部';

  @override
  String get topic_seemore_title => '我的主题';

  @override
  String get topic_seemore_subTitle => '主题';

  @override
  String get bottomSheet_add_topic => '学习单元';

  @override
  String get bottomSheet_add_folder => '文件夹';

  @override
  String get popup_add_topic => '添加新主题';

  @override
  String get popup_add_topic_hint => '主题名称';

  @override
  String get popup_add_topic_exit => '主题名称已存在';

  @override
  String get popup_add_topic_btn_create => '创建';

  @override
  String get popup_add_topic_btn_cancle => '取消';

  @override
  String get addWord_Screen_Input_Japan_Label => '日语词汇';

  @override
  String get addWord_Screen_Input_Japan_Hint => '日语单词';

  @override
  String get addWord_Screen_Input_WayRead_Label => '读法（平假名）';

  @override
  String get addWord_Screen_Input_WayRead_Hint => '读法';

  @override
  String get addWord_Screen_Input_Mean_Label => '单词意思';

  @override
  String get addWord_Screen_Input_Mean_Hint => '意思';

  @override
  String get addWord_Screen_btn_add => '添加单词';

  @override
  String get addWord_bottomShet_warning_save_title => '警告';

  @override
  String get addWord_bottomShet_warning_save_content => '保存后无法编辑';

  @override
  String get addWord_bottomShet_warning_save_btn => '保存';

  @override
  String get addWord_bottomShet_success_save_title => '保存成功';

  @override
  String get addWord_bottomShet_success_save_content => '您创建的主题已成功保存 🎉';

  @override
  String get addWord_bottomShet_success_save_btn => '确定';

  @override
  String get listword_Screen_title => '主题';

  @override
  String get listword_Screen_AmountWord => '单词';

  @override
  String get listword_Screen_Learned => '已掌握';

  @override
  String get listword_Screen_head_col1 => '日语';

  @override
  String get listword_Screen_head_col2 => '意思';

  @override
  String get listword_Screen_head_col3 => '状态';

  @override
  String get listword_Screen_bottomSheet_public_title => '您想分享吗？';

  @override
  String get listword_Screen_bottomSheet_public_content => '分享后，任何人都可以下载';

  @override
  String get listword_Screen_bottomSheet_public_btn_pulic => '公开';

  @override
  String get listword_Screen_bottomSheet_public_btn_cancel => '取消';

  @override
  String get listword_Screen_bottomSheet_public_succes_title => '恭喜';

  @override
  String get listword_Screen_bottomSheet_public_succes_content => '您已成功分享主题';

  @override
  String get listword_Screen_bottomSheet_public_succes_btn_ok => '确定';

  @override
  String get listword_Screen_bottomSheet_private_title => '您想取消分享吗？';

  @override
  String get listword_Screen_bottomSheet_private_btn_private => '取消分享';

  @override
  String get listword_Screen_bottomSheet_private_btn_cancel => '否';

  @override
  String get listword_Screen_bottomSheet_private_success_title => '取消公开成功';

  @override
  String get listword_Screen_bottomSheet_private_success_content => '您已取消主题分享';

  @override
  String get listword_Screen_bottomSheet_private_success_OK => '确定';

  @override
  String get listword_Screen_btn_learn => '立即学习';

  @override
  String get keyboard_handwriting_btn_space => '空格';

  @override
  String get keyboard_handwriting_btn_remove => '删除';

  @override
  String get distionary_Screen_title => '日语词典';

  @override
  String get distionary_Screen_hint => '输入想查询的单词';

  @override
  String get distionary_Screen_hint_title => '查找词汇';

  @override
  String get distionary_Screen_hint_content => '开始查询并学习您的单词';

  @override
  String get distionary_Screen_mean => '单词意思';

  @override
  String get distionary_Screen_info => '单词信息';

  @override
  String get distionary_Screen_type => '名词: ';

  @override
  String get distionary_Screen_level => '等级: ';

  @override
  String get popup_remove_topic_title => '删除主题';

  @override
  String get popup_remove_topic_content => '确定要删除吗？';

  @override
  String get popup_remove_topic_btn_cancle => '取消';

  @override
  String get popup_remove_topic_btn_delete => '删除';

  @override
  String get character_btn_learn => '学习字母';

  @override
  String listWord_word_complete(String count) {
    return '已完成 $count';
  }

  @override
  String listWord_word_learning(String count) {
    return '未完成 $count';
  }

  @override
  String get listWord_btn_learn => '学习单词';

  @override
  String listWord_share_title(String topic) {
    return '主题名 $topic';
  }

  @override
  String listWord_share_amount_word(String amount) {
    return '数量: $amount 个单词';
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
  String get learn_warningGboard => '建议使用 Gboard 以获得最佳体验';

  @override
  String get learn_btn_check => '检查';

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
  String get motivationalPhrases_1 => '继续努力，你做得很好！';

  @override
  String get motivationalPhrases_2 => '这次完美，继续加油！';

  @override
  String get motivationalPhrases_3 => '每一步都是进步！';

  @override
  String get motivationalPhrases_4 => '相信自己，继续努力！';

  @override
  String get motivationalPhrases_5 => '你能做到，永不放弃！';

  @override
  String get motivationalPhrases_6 => '努力不懈者终将成功！';

  @override
  String get motivationalPhrases_7 => '一步步提升自己！';

  @override
  String get motivationalPhrases_8 => '坚强、专注，继续前进！';

  @override
  String get motivationalPhrases_9 => '出色的努力！设定更高目标！';

  @override
  String get motivationalPhrases_10 => '你的努力很快就会有回报！';

  @override
  String get learn_bottomsheet_right_btn => '继续';

  @override
  String get learning_combine_title => '将A列的词语与B列匹配';

  @override
  String get learn_translate_title => '翻译下面的句子';

  @override
  String get learn_listen_title => '你听到了什么';

  @override
  String get learn_chose_title => '选择正确的单词';

  @override
  String get congraculate_title => '完成';

  @override
  String get congraculate_content => '你真棒';

  @override
  String get congraculate_commited => '时间';

  @override
  String get congraculate_amzing => '太棒了';

  @override
  String get profile_level => '等级';

  @override
  String get profile_topic => '主题';

  @override
  String get profile_title => '称号';

  @override
  String get levelTitles_1 => '学士';

  @override
  String get levelTitles_2 => '智者';

  @override
  String get levelTitles_3 => '思想家';

  @override
  String get levelTitles_4 => '尊者';

  @override
  String get levelTitles_5 => '学术大师';

  @override
  String get levelTitles_6 => '文学奇才';

  @override
  String get levelTitles_7 => '智慧贤者';

  @override
  String get levelTitles_8 => '辩论天才';

  @override
  String get levelTitles_9 => '学道通达';

  @override
  String get levelTitles_10 => '文学志士';

  @override
  String get levelTitles_11 => '学者修炼';

  @override
  String get levelTitles_12 => '博学者';

  @override
  String get levelTitles_13 => '贤哲深邃';

  @override
  String get levelTitles_14 => '文雅真人';

  @override
  String get levelTitles_15 => '才智之人';

  @override
  String profile_date(int month, int year) {
    return '$month月 $year年';
  }

  @override
  String get setting_title => '设置';

  @override
  String get setting_achivement_title => '成就';

  @override
  String get setting_achivement_content => '已达成的成就列表';

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
  String get setting_downloadAsync_content => '下载您之前同步的数据';

  @override
  String get setting_signout_title => '登出';

  @override
  String get setting_signout_content => '登出当前账户';

  @override
  String get achivement_title_one => '成就';

  @override
  String get achivement_owl_title => '夜猫子';

  @override
  String get achivement_owl_description => '凌晨0点到2点学习';

  @override
  String get achivement_tryhard_title => '勤奋学者';

  @override
  String get achivement_tryhard_description => '凌晨4点到6点学习';

  @override
  String get achivement_habit_title => '形成习惯';

  @override
  String get achivement_habit_description => '连续学习28天';

  @override
  String get achivement_title_two => '学习连续天数';

  @override
  String achivement_streak_title(String day) {
    return '连续$day天';
  }

  @override
  String achivement_streak_description(String day) {
    return '连续学习$day天获得';
  }

  @override
  String get achivement_title_three => '完成主题';

  @override
  String achivement_topic_title(String amount) {
    return '$amount 个主题';
  }

  @override
  String achivement_topic_description(String amount) {
    return '完成$amount个主题获得';
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
  String get bottomSheet_Error_title => '数据加载错误';

  @override
  String get bottomSheet_Error_description => '暂无同步数据';

  @override
  String get bottomSheet_Warning_title => '警告';

  @override
  String get bottomSheet_Warning_Description => '同步将清空当前设备上的所有数据';

  @override
  String get bottomSheet_Warning_btn_ok => '确定';

  @override
  String get bottomSheet_Warning_btn_cancle => '取消';

  @override
  String get language_title => '语言';

  @override
  String get language_bottomsheet_success => '语言更新成功';

  @override
  String get error_connect_server => '连接服务器失败';

  @override
  String get login_title => '欢迎回来，很高兴见到你';

  @override
  String get login_email_input_hint => '邮箱';

  @override
  String get login_email_input_hint_focus => '请输入邮箱';

  @override
  String get login_email_input_password => '密码';

  @override
  String get login_email_input_password_hint => '请输入密码';

  @override
  String get login_btn => '登录';

  @override
  String get login_create_question_account => '没有账户？';

  @override
  String get login_create_btn_account => '注册';

  @override
  String get login_with_facebook => '使用 Facebook 登录';

  @override
  String get login_with_google => '使用 Google 登录';

  @override
  String get login_invalid_email => '邮箱无效';

  @override
  String get login_user_disabled => '账户已被禁用';

  @override
  String get login_user_not_found => '未找到该邮箱账户';

  @override
  String get login_wrong_password => '密码错误';

  @override
  String get login_error => '发生错误';

  @override
  String get register_title => '你好，请注册以开始体验';

  @override
  String get register_email_input_hint => '邮箱';

  @override
  String get register_email_input_hint_focus => '请输入邮箱';

  @override
  String get register_user_input_hint => '用户名';

  @override
  String get register_user_input_hint_focus => '请输入用户名';

  @override
  String get register_password_input_hint => '密码';

  @override
  String get register_password_input_hint_focus => '请输入密码';

  @override
  String get register_re_password_input_hint => '确认密码';

  @override
  String get register_re_password_input_hint_focus => '再次输入密码';

  @override
  String get register_btn => '注册';

  @override
  String get register_question_login => '已有账户？';

  @override
  String get register_btn_login => '登录';

  @override
  String get register_email_already_in_use => '该邮箱已被注册';

  @override
  String get register_invalid_email => '邮箱地址无效';

  @override
  String get register_operation_not_allowed => '邮箱/密码账户尚未激活';

  @override
  String get register_weak_password => '密码过于简单';

  @override
  String get register_error => '发生错误';

  @override
  String get register_success => '账户创建成功，返回登录页面';
}
