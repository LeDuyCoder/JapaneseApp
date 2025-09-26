import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';

class FunctionService{

  static DateTime parseDateManual(String dateString) {
    List<String> parts = dateString.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;


  FunctionService(){
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: Config.admodRewardId, // phải lấy đúng ID RewardedAd
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          print("RewardedAd loaded");
          _rewardedAd = ad;
          _isRewardedAdReady = true;
        },
        onAdFailedToLoad: (error) {
          print("RewardedAd failed to load: $error");
          _rewardedAd = null;
          _isRewardedAdReady = false;
        },
      ),
    );
  }

  void _showRewardedAd(SharedPreferences prefs, String today) {
    if (_isRewardedAdReady && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print("RewardedAd dismissed");
          ad.dispose();
          _loadRewardedAd(); // load lại quảng cáo sau khi đóng
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("RewardedAd failed to show: $error");
          ad.dispose();
          _loadRewardedAd();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        },
      );

      _rewardedAd = null;
      _isRewardedAdReady = false;
    } else {
      print("RewardedAd chưa sẵn sàng");
    }
  }


  Future<void> showRewardAdSheet(
      BuildContext context,
      VoidCallback onWatchAd,
      SharedPreferences prefs,
      String today,
      ) async
  {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon + tiêu đề
              const Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.local_fire_department, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Khôi phục chuỗi học",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Nội dung
              const Text(
                "Bạn có thể xem quảng cáo để khôi phục lại chuỗi học hôm nay. "
                    "Nếu không, chuỗi sẽ bị reset.",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 24),

              // Nút hành động
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      await _resetCheckInStreak(prefs, today);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text("Huỷ"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onWatchAd();
                    },
                    icon: const Icon(Icons.play_circle_fill),
                    label: const Text("Xem quảng cáo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }



  // Hàm reset chuỗi điểm danh
  Future<void> _resetCheckInStreak(SharedPreferences prefs, String today) async {
    prefs.setString("lastCheckIn", today);
    prefs.setStringList("checkInHistoryTreak", [today]);
  }

  // Hàm tiếp tục chuỗi điểm danh (chỉ thêm nếu chưa có)
  static Future<void> _continueCheckInStreak(SharedPreferences prefs, String today) async {
    List<String> streak = prefs.getStringList("checkInHistoryTreak") ?? [];
    if (!streak.contains(today)) {
      streak.add(today);
      prefs.setStringList("checkInHistoryTreak", streak);
    }
    prefs.setString("lastCheckIn", today);
  }

  Future<void> setDay(BuildContext ctx) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String today = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}";

    // Lấy danh sách check-in lịch sử, nếu null thì tạo danh sách mới
    List<String> days = prefs.getStringList("checkInHistory") ?? [];
    if (!days.contains(today)) {
      days.add(today);
      prefs.setStringList("checkInHistory", days);
    }

    // Kiểm tra lần check-in gần nhất
    String? lastCheck = prefs.getString("lastCheckIn");
    if (lastCheck == null || lastCheck.isEmpty) {
      await _resetCheckInStreak(prefs, today);
      return;
    }

    // Tính khoảng cách ngày giữa hôm nay và lần check-in trước
    DateTime lastCheckDate = FunctionService.parseDateManual(lastCheck);
    int daysDifference = now.difference(lastCheckDate).inDays;

    // Nếu khoảng cách > 1 ngày, reset streak
    if (daysDifference == 2) {
      showRewardAdSheet(ctx, (){
        _showRewardedAd(prefs, today);
      }, prefs, today);
    } else {
      await _continueCheckInStreak(prefs, today);
    }

    // Đánh dấu thành tựu nếu điểm danh vào sáng sớm
    if (now.hour >= 0 && now.hour < 2) {
      await setAchivement("cudemhockhuya");
    }

    if(now.hour >= 4 && now.hour < 6){
      await setAchivement("trithucdaysom");
    }
  }

  static Future<void> setAchivement(String achivement) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> Achivements = prefs.getStringList("achivement")!;
    if(!Achivements.contains(achivement)) {
      Achivements.add(achivement);
      prefs.setStringList("achivement", Achivements);
    }
  }

  static Future<int> getTopicComplite() async {
    DatabaseHelper db = DatabaseHelper.instance;
    return (await db.countCompletedTopics());
  }

  static Future<bool> synchronyData() async {
    try {
      // Chạy song song DB + SharedPreferences
      final results = await Future.wait([
        DatabaseHelper.instance.getAllSynchronyData(),
        SharedPreferences.getInstance(),
      ]);

      final dbData = results[0];
      final prefs = results[1] as SharedPreferences;

      // Gom prefs thành Map
      final Map<String, dynamic> dataPrefs = {
        for (var key in prefs.getKeys()) key: prefs.get(key)
      };

      // Payload final
      final Map<String, dynamic> payload = {
        "sqlite": dbData,
        "prefs": dataPrefs,
        "updatedAt": FieldValue.serverTimestamp(),
      };

      // Firestore
      final userDoc = FirebaseFirestore.instance
          .collection("datas")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      await userDoc.set({"data": payload}, SetOptions(merge: true));

      return true;
    } catch (e, st) {
      debugPrint("❌ Sync failed: $e");
      debugPrintStack(stackTrace: st);
    } finally {
      return false;
    }
  }

  static Future<void> checkAndBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final lastBackup = prefs.getInt("lastBackup") ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // 24h = 86400000 ms
    if (now - lastBackup > 86400000) {
      await synchronyData(); // Hàm backup bạn đã có
      await prefs.setInt("lastBackup", now);
      print("Đã backup sau 24h!");
    } else {
      print("Chưa tới 24h, bỏ qua backup");
    }
  }
}