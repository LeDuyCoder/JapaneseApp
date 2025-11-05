import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  /// Check xem có mạng Internet thật sự hay không
  static Future<bool> hasNetwork() async {
    // B1: kiểm tra có kết nối wifi / mobile hay không
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // không có kết nối
    }

    // B2: thử ping tới google để chắc chắn có internet
    try {
      final result = await InternetAddress.lookup('jpa.landernetwork.io.vn');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException {
      return false;
    }
  }
}
