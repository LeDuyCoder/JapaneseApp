import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get tabbar_home => 'Trang Chủ';

  @override
  String get tabbar_character => 'Bảng Chữ Cái';

  @override
  String get tabbar_info => 'Thông Tin';

  @override
  String get dashboard_hintSearch => 'Từ bạn muốn tra';

  @override
  String get dashboard_folder => 'Thư Mục';

  @override
  String get dashboard_course => 'Học Phần';

  @override
  String get dashboard_topic => 'chủ đề';

  @override
  String get dashboard_popupDownload_title => 'Bạn có muốn tải xuống không';

  @override
  String get dashboard_popupDownload_btn_cancel => 'Hủy';

  @override
  String get dashboard_popupDownload_btn_dowload => 'Tải';

  @override
  String get dashboard_seemore => 'Xem Thêm';

  @override
  String get dashboard_btn_import => 'Nhập';

  @override
  String get tutorial_one_title => 'Cài đặt ứng dụng';

  @override
  String get tutorial_one_content => 'Hãy đảm bảo thiết bị của bạn đã cài đặt ứng dụng Gboard';

  @override
  String get tutorial_two_title => 'Vào Ứng Dụng Setting';

  @override
  String get tutorial_two_content => 'Bạn hãy vào ứng dụng setting để thiết lập bàn phím học viết tiếng nhật';

  @override
  String get tutorial_three_title => 'Tìm Kiếm Gboard';

  @override
  String get tutorial_three_content => 'Bạn hãy bấm tìm và tìm đến Gboard như trên ảnh';

  @override
  String get tutorial_four_title => 'Gboard';

  @override
  String get tutorial_four_content => 'Tiếp tục bấm vòa theo như hướng dẫn';

  @override
  String get tutorial_five_title => 'Languages';

  @override
  String get tutorial_five_content => 'Hãy bấm vào phần ngôn ngữ';

  @override
  String get tutorial_six_title => 'ADD KEYBOARD';

  @override
  String get tutorial_six_content => 'Bấm vô thêm bàn phím để thêm bàn phím tiếng nhật';

  @override
  String get tutorial_seven_title => 'Search Japanese';

  @override
  String get tutorial_seven_content => 'Hãy bấm tìm kiếm ngôn ngữ tiếng nhật';

  @override
  String get tutorial_eight_title => 'handwriting';

  @override
  String get tutorial_eight_content => 'Hãy chọn dạng bàn phím viết và bấm done';

  @override
  String get tutorial_nice_title => 'Thay đổi bàn phím';

  @override
  String get tutorial_nice_content => 'khi học viết nhớ chuyển sang bàn phím để tập viết để nhớ tốt hơn';

  @override
  String get tutorial_btn_back => 'trước';

  @override
  String get tutorial_btn_forward => 'sau';

  @override
  String get tutorial_btn_skip => 'bỏ qua';

  @override
  String get tutorial_one_done => 'xong';

  @override
  String course_owner(String user_nane) {
    return 'tạo bởi $user_nane';
  }

  @override
  String amount_word(String amount) {
    return 'số lượng: $amount Từ';
  }

  @override
  String word_finish(String amount) {
    return 'Hoàn Thành: $amount';
  }

  @override
  String word_learning(String amount) {
    return 'Chưa Hoàn Thành: $amount';
  }

  @override
  String get add_course => 'Học phần';

  @override
  String get add_folder => 'Thư Mục';

  @override
  String get folderManager => 'Thêm Chủ Đề Học Phần';

  @override
  String get folderManager_addTopic => 'Thêm Chủ Đề';

  @override
  String get folderManager_remove => 'xóa';

  @override
  String get folderManager_removeTopic => 'Xóa khỏi thư mục';

  @override
  String get seemore_search => 'Tên thư mục';

  @override
  String get import_title => 'Chọn phước thức nhập';

  @override
  String get import_btn_file => 'Từ File';

  @override
  String get import_btn_qr => 'Từ QR';

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
  String get bottomSheet_Warning_title => 'Cảnh Báo';

  @override
  String get bottomSheet_Warning_Description => 'Khi đồng bộ toa bộ dữ liệu trên máy hiện tại sẽ bị xóa';

  @override
  String get bottomSheet_Warning_btn_ok => 'OK';

  @override
  String get bottomSheet_Warning_btn_cancle => 'Hủy';

  @override
  String get bottomSheet_Error_title => 'Lỗi Tải Dữ Liệu';

  @override
  String get bottomSheet_Error_description => 'Hiện không có bản đồng bộ hóa dữ liệu nào';

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
