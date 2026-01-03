import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/config.dart';
import 'Local/local_db_service.dart';

class FunctionService{

  static DateTime parseDateManual(String dateString) {
    List<String> parts = dateString.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }


  FunctionService(){}

  Future<void> _resetCheckInStreak(SharedPreferences prefs, String today) async {
    prefs.setString("lastCheckIn", today);
    prefs.setStringList("checkInHistoryTreak", [today]);
  }

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

    await _continueCheckInStreak(prefs, today);

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
    final db = LocalDbService.instance;
    return (await db.topicDao.countCompletedTopics());
  }

  static Future<bool> synchronyData() async {
    try {
      // Chạy song song DB + SharedPreferences
      final results = await Future.wait([
        LocalDbService.instance.syncDao.getAllSynchronyData(),
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


      if(FirebaseAuth.instance.currentUser == null) {
        return false;
      }

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
    if (now - lastBackup > 43200000) {
      await synchronyData();
      await prefs.setInt("lastBackup", now);
      print("Đã backup sau 24h!");
    } else {
      print("Chưa tới 24h, bỏ qua backup");
    }
  }
}