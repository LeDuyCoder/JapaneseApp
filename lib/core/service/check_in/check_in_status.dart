/// Trạng thái của check-in sau khi thực hiện
enum CheckInStatus {
  /// Tiếp tục streak bình thường
  continued,

  /// Streak bị reset
  reset,

  /// Cần xem quảng cáo để cứu streak
  needRewardAd,
}