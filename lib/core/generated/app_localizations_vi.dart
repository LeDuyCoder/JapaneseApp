import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get tabbar_home => 'Trang Chủ';

  @override
  String get tabber_distionary => 'Từ Điển';

  @override
  String get tabbar_character => 'Bảng Chữ Cái';

  @override
  String get tabbar_info => 'Thông Tin';

  @override
  String get dashboard_folder => 'Thư Mục Của Tôi';

  @override
  String get dashboard_folder_seemore => 'Xem Tất Cả';

  @override
  String get dashboard_folder_content => 'chủ đề';

  @override
  String get dashboard_folder_nodata_title => 'Chưa có thư mục nào';

  @override
  String get dashboard_folder_nodata_content => 'Hãy tạo thư mục đầu tiên để sắp xếp từ vựng của bạn';

  @override
  String get dashboard_comunication => 'Cộng Đồng';

  @override
  String get dashboard_comunication_seemore => 'Xem Tất Cả';

  @override
  String course_owner(String user_nane) {
    return '$user_nane';
  }

  @override
  String amount_word(String amount) {
    return '$amount';
  }

  @override
  String get topic_persent => 'Phần Trăm';

  @override
  String get topic_word_finish => 'Hoàn Thành';

  @override
  String get topic_word_learning => 'Chưa Hoàn Thành';

  @override
  String get add_course => 'Học phần';

  @override
  String get add_folder => 'Thư Mục';

  @override
  String get folderSeemore_title => 'Thư Mục Của Tôi';

  @override
  String get folderSeemore_grid => 'Lưới';

  @override
  String get folderSeemore_tag_flex => 'Danh Sách';

  @override
  String get folderSeemore_content => 'Tất cả thư mục';

  @override
  String get folderSeemore_subContent => 'Thư Mục';

  @override
  String get folderManager_nodata_title => 'Bắt đầu tạo thư mục cho riêng bạn';

  @override
  String get folderManager_nodata_button => 'Thêm chủ đề học';

  @override
  String get folderManager_bottomSheet_addTopic => 'Thêm Chủ Đề Học';

  @override
  String get folderManager_bottomSheet_removeFolder => 'Xóa';

  @override
  String get folderManager_topic_bottomSheet_remove => 'Xóa khỏi thư mục';

  @override
  String get folderManager_Screen_addTopic_title => ' Thêm Chủ Đề Học Phần';

  @override
  String folderManager_Screen_addTopic_card_owner(String name) {
    return 'tác giả: $name';
  }

  @override
  String folderManager_Screen_addTopic_card_amountWord(int amount) {
    return 'số từ: $amount';
  }

  @override
  String get comunication_bottomSheet_notify_download_title => 'Bạn có muốn tải xuống không';

  @override
  String get comunication_bottomSheet_notify_download_btn => 'Tải';

  @override
  String get download_Screen_downloading_title => 'Đang Tải Chủ Đề';

  @override
  String get download_Screen_downloading_contetnt => 'Vui lòng chờ trong giây lát...';

  @override
  String get download_Screen_downloading_btn => 'Hủy';

  @override
  String get download_Screen_Success_title => 'Tải Thành Công';

  @override
  String get download_Screen_Success_contetnt => 'Chủ đề đã sẵn sàng để học';

  @override
  String get download_Screen_Success_btn => 'Bắt đầu học';

  @override
  String get dashboard_topic_nodata_title => 'Chưa có chủ đề nào';

  @override
  String get dashboard_topic_nodata_content => 'Hãy tạo chủ đề đầu tiên để bắt đầu học';

  @override
  String get communication_Screen_title => 'Cộng Đồng';

  @override
  String get communication_Screen_hint_search => 'Nhập tên chủ đề...';

  @override
  String get communication_Screen_subTitle => 'Bộ Sư Tập Cộng Đồng';

  @override
  String get dashboard_topic => 'Chủ để của tôi';

  @override
  String get dashboard_topic_seemore => 'Xem Tất Cả';

  @override
  String get topic_seemore_title => 'Chủ Đề Của Tôi';

  @override
  String get topic_seemore_subTitle => 'Chủ Đề';

  @override
  String get bottomSheet_add_topic => 'Học Phần';

  @override
  String get bottomSheet_add_folder => 'Thư Mục';

  @override
  String get popup_add_topic => 'Thêm Chủ Đề Mới';

  @override
  String get popup_add_topic_hint => 'Tên Chủ Đề';

  @override
  String get popup_add_topic_exit => 'Tên Chủ Đề Đã Tồn Tại';

  @override
  String get popup_add_topic_btn_create => 'Tạo';

  @override
  String get popup_add_topic_btn_cancle => 'Hủy';

  @override
  String get addWord_Screen_Input_Japan_Label => 'Từ vựng tiếng nhật';

  @override
  String get addWord_Screen_Input_Japan_Hint => 'Từ tiếng nhật';

  @override
  String get addWord_Screen_Input_WayRead_Label => 'Cách đọc (Hiragana)';

  @override
  String get addWord_Screen_Input_WayRead_Hint => 'cách đọc';

  @override
  String get addWord_Screen_Input_Mean_Label => 'Nghĩa của từ';

  @override
  String get addWord_Screen_Input_Mean_Hint => 'nghĩa';

  @override
  String get addWord_Screen_btn_add => 'Thêm Từ';

  @override
  String get addWord_bottomShet_warning_save_title => 'Cảnh Báo';

  @override
  String get addWord_bottomShet_warning_save_content => 'Khi lưu không thể chỉnh sữa';

  @override
  String get addWord_bottomShet_warning_save_btn => 'Lưu';

  @override
  String get addWord_bottomShet_success_save_title => 'Lưu Thành Công';

  @override
  String get addWord_bottomShet_success_save_content => 'Chủ đề bạn tạo đã được tạo thành công 🎉';

  @override
  String get addWord_bottomShet_success_save_btn => 'OK';

  @override
  String get listword_Screen_title => 'Chủ Đề';

  @override
  String get listword_Screen_AmountWord => 'từ vựng';

  @override
  String get listword_Screen_Learned => 'đã thuộc';

  @override
  String get listword_Screen_head_col1 => 'Tiếng Nhật';

  @override
  String get listword_Screen_head_col2 => 'Nghĩa';

  @override
  String get listword_Screen_head_col3 => 'Trạng Thái';

  @override
  String get listword_Screen_bottomSheet_public_title => 'Bạn có muốn chia sẻ không?';

  @override
  String get listword_Screen_bottomSheet_public_content => 'Khi chia sẻ, ai cũng có thể tải về';

  @override
  String get listword_Screen_bottomSheet_public_btn_pulic => 'Công Khai';

  @override
  String get listword_Screen_bottomSheet_public_btn_cancel => 'Hủy';

  @override
  String get listword_Screen_bottomSheet_public_succes_title => 'Chúc Mừng';

  @override
  String get listword_Screen_bottomSheet_public_succes_content => 'Bạn đã chia sẽ thành công bộ chủ đề của bạn';

  @override
  String get listword_Screen_bottomSheet_public_succes_btn_ok => 'OK';

  @override
  String get listword_Screen_bottomSheet_private_title => 'Bạn có muốn hủy chia sẻ không';

  @override
  String get listword_Screen_bottomSheet_private_btn_private => 'Hủy chia sẻ';

  @override
  String get listword_Screen_bottomSheet_private_btn_cancel => 'Không';

  @override
  String get listword_Screen_bottomSheet_private_success_title => 'Hủy Công Khai Thành Công';

  @override
  String get listword_Screen_bottomSheet_private_success_content => 'Bạn đã hủy chia sẽ chủ đề của bạn';

  @override
  String get listword_Screen_bottomSheet_private_success_OK => 'OK';

  @override
  String get listword_Screen_btn_learn => 'Học Ngay';

  @override
  String get keyboard_handwriting_btn_space => 'Khoảng trắng';

  @override
  String get keyboard_handwriting_btn_remove => 'Xóa';

  @override
  String get distionary_Screen_title => 'Từ Điển Tiếng Nhật';

  @override
  String get distionary_Screen_hint => 'Nhập Từ Muốn Tra';

  @override
  String get distionary_Screen_hint_title => 'Tra Từ Vựng';

  @override
  String get distionary_Screen_hint_content => 'Bắt đầu tra và học từ của bạn nào';

  @override
  String get distionary_Screen_mean => 'Nghĩa của từ';

  @override
  String get distionary_Screen_info => 'Thông tin từ';

  @override
  String get distionary_Screen_type => 'Danh từ: ';

  @override
  String get distionary_Screen_level => 'Cấp Độ: ';

  @override
  String get popup_remove_topic_title => 'Xóa chủ đề';

  @override
  String get popup_remove_topic_content => 'Bạn có muốn xóa không';

  @override
  String get popup_remove_topic_btn_cancle => 'Hủy';

  @override
  String get popup_remove_topic_btn_delete => 'Xóa';

  @override
  String get character_btn_learn => 'Học Chữ Cái';

  @override
  String listWord_word_complete(String count) {
    return 'Hoàn Thành $count';
  }

  @override
  String listWord_word_learning(String count) {
    return 'Chưa Hoàn Thành $count';
  }

  @override
  String get listWord_btn_learn => 'Học Từ';

  @override
  String listWord_share_title(String topic) {
    return 'Tên chủ đền $topic';
  }

  @override
  String listWord_share_amount_word(String amount) {
    return 'số lượng: $amount Từ';
  }

  @override
  String listWord_share_type(String type) {
    return 'Loại: $type';
  }

  @override
  String get listWord_btn_remove => 'Xóa';

  @override
  String get listWord_btn_shared => 'Chia Sẻ';

  @override
  String get learn_warningGboard => 'Khuyến nghị sử dụng Gboard để có trả nghiệm tốt nhất';

  @override
  String get learn_btn_check => 'Kiểm tra';

  @override
  String get learn_bottomsheet_wrong_title => 'Không Chính Xác';

  @override
  String get learn_bottomsheet_wrong_content => 'Câu trả lời đúng là';

  @override
  String get learn_bottomsheet_wrong_btn => 'Tiếp Tục';

  @override
  String get learn_write_input => 'Viết';

  @override
  String get learn_bottomsheet_right_title => 'Trả Lời Chính Xác';

  @override
  String get motivationalPhrases_1 => 'Tiếp tục cố gắng, bạn đang làm rất tốt!';

  @override
  String get motivationalPhrases_2 => 'Lần này bạn đã hoàn hảo, hãy tiếp tục cố gắng!';

  @override
  String get motivationalPhrases_3 => 'Mỗi bước tiến lên đều là một sự tiến bộ!';

  @override
  String get motivationalPhrases_4 => 'Hãy tin vào bản thân và tiếp tục nỗ lực!';

  @override
  String get motivationalPhrases_5 => 'Bạn có thể làm được, đừng bao giờ bỏ cuộc!';

  @override
  String get motivationalPhrases_6 => 'Thành công đến với những ai không ngừng cố gắng!';

  @override
  String get motivationalPhrases_7 => 'Tiếp tục cải thiện, từng bước một!';

  @override
  String get motivationalPhrases_8 => 'Hãy mạnh mẽ, tập trung và tiếp tục tiến lên!';

  @override
  String get motivationalPhrases_9 => 'Nỗ lực tuyệt vời! Hãy tiếp tục đặt mục tiêu cao hơn!';

  @override
  String get motivationalPhrases_10 => 'Sự chăm chỉ của bạn sẽ sớm được đền đáp!';

  @override
  String get learn_bottomsheet_right_btn => 'Tiếp Tục';

  @override
  String get learning_combine_title => 'Nói từ cột A sang cột B';

  @override
  String get learn_translate_title => 'Dịch Câu Bên Dưới';

  @override
  String get learn_listen_title => 'Bạn Nghe Được Gì';

  @override
  String get learn_chose_title => 'Từ nào đúng của từ';

  @override
  String get congraculate_title => 'Hoàn Thành';

  @override
  String get congraculate_content => 'Bạn Thật Tuyệt vời';

  @override
  String get congraculate_commited => 'Thời Gian';

  @override
  String get congraculate_amzing => 'Tuyệt vời';

  @override
  String get profile_level => 'Cấp Bậc';

  @override
  String get profile_topic => 'Chủ Đề';

  @override
  String get profile_title => 'Danh Hiệu';

  @override
  String get levelTitles_1 => 'Học Sĩ';

  @override
  String get levelTitles_2 => 'Minh Triết Giả';

  @override
  String get levelTitles_3 => 'Tư Tưởng Gia';

  @override
  String get levelTitles_4 => 'Bác Học Tôn Giả';

  @override
  String get levelTitles_5 => 'Hàn Lâm Học Sĩ';

  @override
  String get levelTitles_6 => 'Kỳ Tài Văn Học';

  @override
  String get levelTitles_7 => 'Trí Thánh Nhân';

  @override
  String get levelTitles_8 => 'Thiên Tài Biện Luận';

  @override
  String get levelTitles_9 => 'Học Đạo Tinh Thông';

  @override
  String get levelTitles_10 => 'Chí Sĩ Văn Nhân';

  @override
  String get levelTitles_11 => 'Luyện Tư Học Sĩ';

  @override
  String get levelTitles_12 => 'Thông Tuệ Giả';

  @override
  String get levelTitles_13 => 'Hiền Triết Uyên Thâm';

  @override
  String get levelTitles_14 => 'Văn Nhã Chân Nhân';

  @override
  String get levelTitles_15 => 'Trí Nhân Kỳ Tài';

  @override
  String profile_date(int month, int year) {
    return 'Tháng $month Năm $year';
  }

  @override
  String get setting_title => 'Cài Đặt';

  @override
  String get setting_achivement_title => 'Thành Tựu';

  @override
  String get setting_achivement_content => 'Danh sách thành tựu đã đặt được';

  @override
  String get setting_language_title => 'Ngôn Ngữ';

  @override
  String get setting_language_content => 'Chọn ngôn ngữ hiển thị';

  @override
  String get setting_async_title => 'Đồng Bộ Dữ Liệu';

  @override
  String get setting_async_content => 'Đồng bộ dữ liệu lên đám mây';

  @override
  String get setting_downloadAsync_title => 'Tải Bộ Dữ Liệu';

  @override
  String get setting_downloadAsync_content => 'Tải bộ dữ liệu đã đồng bộ trên máy củ của bạn';

  @override
  String get setting_signout_title => 'Đăng Xuất';

  @override
  String get setting_signout_content => 'Đăng xuất khỏi tài khoản hiện tại';

  @override
  String get achivement_title_one => 'Thành Tựu';

  @override
  String get achivement_owl_title => 'Cú Đêm Học Khuya';

  @override
  String get achivement_owl_description => 'Học từ lúc 0h đến 2 giờ sáng';

  @override
  String get achivement_tryhard_title => 'Tri Thức Chăm Chỉ';

  @override
  String get achivement_tryhard_description => 'Học từ lúc 4 đến 6 giờ sáng';

  @override
  String get achivement_habit_title => 'HÌnh Thành Thói Quen';

  @override
  String get achivement_habit_description => 'Học liên tiếp 28 ngày';

  @override
  String get achivement_title_two => 'Chuổi Ngày Học';

  @override
  String achivement_streak_title(String day) {
    return 'Chuổi $day ngày';
  }

  @override
  String achivement_streak_description(String day) {
    return 'Nhận khi học liên tục $day ngày';
  }

  @override
  String get achivement_title_three => 'Chủ Đề Hoàn Thành';

  @override
  String achivement_topic_title(String amount) {
    return '$amount Chủ Đề';
  }

  @override
  String achivement_topic_description(String amount) {
    return 'Nhận khi hoàn thành $amount chủ đề';
  }

  @override
  String get bottomSheetAsync_Success_Description => 'Dữ liệu đã được đồng bộ hóa thành công';

  @override
  String get bottomSheetAsync_Success_Btn => 'OK';

  @override
  String get bottomSheet_Nointernet_title => 'Không Có Kết Nối Internet';

  @override
  String get bottomSheet_Nointernet_Description => 'Vui lòng kểm tra kết nối internet của bạn và thử lại';

  @override
  String get bottomSheet_Nointernet_Btn => 'OK';

  @override
  String get bottomSheet_Error_title => 'Lỗi Tải Dữ Liệu';

  @override
  String get bottomSheet_Error_description => 'Hiện không có bản đồng bộ hóa dữ liệu nào';

  @override
  String get bottomSheet_Warning_title => 'Cảnh Báo';

  @override
  String get bottomSheet_Warning_Description => 'Khi đồng bộ toa bộ dữ liệu trên máy hiện tại sẽ bị xóa';

  @override
  String get bottomSheet_Warning_btn_ok => 'OK';

  @override
  String get bottomSheet_Warning_btn_cancle => 'Hủy';

  @override
  String get language_title => 'Ngôn ngữ';

  @override
  String get language_bottomsheet_success => 'Cập Nhật Ngôn Ngữ Thành Công';

  @override
  String get error_connect_server => 'Lỗi Kết Nối Đến Máy Chủ';

  @override
  String get login_title => 'Chào mừng trở lại, Rất vui được gặp bạn';

  @override
  String get login_email_input_hint => 'Email';

  @override
  String get login_email_input_hint_focus => 'Nhập email của bạn';

  @override
  String get login_email_input_password => 'Mật Khẩu';

  @override
  String get login_email_input_password_hint => 'Nhập Mật Khẩu';

  @override
  String get login_btn => 'Đăng Nhập';

  @override
  String get login_create_question_account => 'Không Có Tài Khoảng';

  @override
  String get login_create_btn_account => 'Đăng Kí';

  @override
  String get login_with_facebook => 'Đăng Nhập Với Facebook';

  @override
  String get login_with_google => 'Đăng Nhập Với Google';

  @override
  String get login_invalid_email => 'Email Không Hợp Lệ';

  @override
  String get login_user_disabled => 'Tài Khoản Đã Bị Khóa';

  @override
  String get login_user_not_found => 'Không tìm thấy tài khoản với email này';

  @override
  String get login_wrong_password => 'Mật khẩu không đúng';

  @override
  String get login_error => 'Đã Có Lỗi Xảy Ra';

  @override
  String get register_title => 'Xin chào, Đăng kí để bắt đầu trải nghiệm';

  @override
  String get register_email_input_hint => 'Email';

  @override
  String get register_email_input_hint_focus => 'Nhập email của bạn';

  @override
  String get register_user_input_hint => 'Tên Người Dùng';

  @override
  String get register_user_input_hint_focus => 'Nhập tên người dùng';

  @override
  String get register_password_input_hint => 'Mật Khẩu';

  @override
  String get register_password_input_hint_focus => 'Nhập Mật Khẩu';

  @override
  String get register_re_password_input_hint => 'Nhập Lại Mật Khẩu';

  @override
  String get register_re_password_input_hint_focus => 'Nhập Lại Mật Khẩu';

  @override
  String get register_btn => 'Đăng Kí';

  @override
  String get register_question_login => 'Đã Có Tài Khoảng';

  @override
  String get register_btn_login => 'Đăng Nhập';

  @override
  String get register_email_already_in_use => 'Email này đã được đăng ký';

  @override
  String get register_invalid_email => 'Địa chỉ email không hợp lệ.';

  @override
  String get register_operation_not_allowed => 'Tài khoản email/mật khẩu chưa được kích hoạt.';

  @override
  String get register_weak_password => 'Mật Khẩu Quá Yếu';

  @override
  String get register_error => 'Đã Có Lỗi Xảy Ra';

  @override
  String get register_success => 'Tạo tài khoản thành công, quay lại trang đăng nhập';
}
