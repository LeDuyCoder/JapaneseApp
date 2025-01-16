import 'dart:async';

class TimerService {
  late Timer _timer;
  int _seconds = 0;
  Function(int)? onUpdate; // Hàm callback để cập nhật thời gian

  TimerService({this.onUpdate});

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      if (onUpdate != null) {
        onUpdate!(_seconds); // Gọi callback khi cập nhật thời gian
      }
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void resetTimer() {
    _seconds = 0;
    if (onUpdate != null) {
      onUpdate!(_seconds); // Gọi callback để cập nhật thời gian về 0
    }
  }

  int get currentSeconds => _seconds; // Lấy giá trị hiện tại
}
