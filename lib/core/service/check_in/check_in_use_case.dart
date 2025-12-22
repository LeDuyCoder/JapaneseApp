import 'check_in_local_data_source.dart';
import 'check_in_status.dart';
import '../../utils/date_formatter.dart';

class CheckInUseCase {
  final CheckInLocalDataSource local;

  CheckInUseCase(this.local);

  /// Thực hiện check-in cho ngày [now]
  /// Trả về trạng thái CheckInStatus
  Future<CheckInStatus> execute(DateTime now) async {
    final today = DateFormatter.format(now);

    await local.saveToday(today);

    final lastCheck = local.getLastCheckIn();
    if (lastCheck == null || lastCheck.isEmpty) {
      await local.resetStreak(today);
      return CheckInStatus.reset;
    }

    final lastDate = DateFormatter.parse(lastCheck);
    final diff = now.difference(lastDate).inDays;

    if (diff == 2) {
      return CheckInStatus.needRewardAd;
    }

    await local.continueStreak(today);
    return CheckInStatus.continued;
  }
}
