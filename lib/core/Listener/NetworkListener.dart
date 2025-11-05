import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../main.dart';

class NetworkListener {
  static final NetworkListener _instance = NetworkListener._internal();
  factory NetworkListener() => _instance;
  NetworkListener._internal();

  final Connectivity _connectivity = Connectivity();
  bool _isDialogShowing = false;

  void init() {
    // Kiểm tra ngay lúc khởi động
    _checkInternetNow();

    // Lắng nghe thay đổi kết nối (wifi/4g)
    _connectivity.onConnectivityChanged.listen((_) async {
      await _checkInternetNow();
    });

    // Lắng nghe internet thực sự (ping)
    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        _showNoInternetDialog();
      }
    });
  }

  Future<void> _checkInternetNow() async {
    final hasInternet = await InternetConnectionChecker.instance.hasConnection;
    if (!hasInternet) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    final context = navigatorKey.currentState!.overlay!.context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: const [
            Icon(Icons.wifi_off, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text(
              "Mất kết nối",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          "Hiện tại bạn đang ngoại tuyến. Một số tính năng học yêu cầu Internet và tiến trình có thể không được lưu.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.arrow_right_alt, color: Colors.black),
            label: const Text(
              "Bỏ Qua",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              _isDialogShowing = false;
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.refresh, color: Colors.blue),
            label: const Text(
              "Check lại",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              _isDialogShowing = false;

              final hasInternet =
              await InternetConnectionChecker.instance.hasConnection;
              //delay 1s
              await Future.delayed(const Duration(seconds: 1));
              if (!hasInternet) {
                _showNoInternetDialog();
              }
            },
          ),
        ],
      ),
    );
  }

}
