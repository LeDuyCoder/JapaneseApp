import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashService {
  static Future<void> playIntro(AudioPlayer player) async {
    try {
      await player.play(AssetSource("sound/intro.mp3"));
    } catch (e) {
      debugPrint("Lỗi khi phát âm thanh: $e");
    }
  }

  static Future<void> requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  static Future<void> checkForUpdate(Function(void Function()) setState) async {
    try {
      InAppUpdate.checkForUpdate().then((info) {
        setState(() {
          if (info.updateAvailability == UpdateAvailability.updateAvailable) {
            InAppUpdate.startFlexibleUpdate().then((_) {
              InAppUpdate.completeFlexibleUpdate();
            });
          }
        });
      });
    } catch (e) {
      debugPrint("Lỗi check update: $e");
    }
  }

  static Future<void> addUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      ServiceLocator.userService.addUser(user.uid, user.displayName ?? "Unknown");
    }
  }

  static Future<void> showNoInternetDialog(
      BuildContext context, Function retry) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text("Không có kết nối",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text("Vui lòng kiểm tra kết nối mạng và thử lại."),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(seconds: 2));
                retry();
              },
              child: const Text("Thử lại"),
            ),
          ],
        );
      },
    );
  }
}
