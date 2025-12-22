import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/core/Screen/rewardRankScreen.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/Utilities/WeekUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class rewardRankService {
  static final rewardRankService _instance = rewardRankService._internal();

  factory rewardRankService() {
    return _instance;
  }

  rewardRankService._internal();

  Future<bool> hasKeyRankWeek() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey("perrior_rank");
  }

  Future<bool> isSameWeek(String periorRankNow) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? perriorRank = sharedPreferences.getString("perrior_rank");
    if (perriorRank == null) {
      return false;
    }
    return perriorRank == periorRankNow;
  }

  Future<String> getRankWeek() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? perriorRank = sharedPreferences.getString("perrior_rank");
    if (perriorRank == null) {
      return "";
    }
    return perriorRank;
  }

  Future<void> setRankWeek(String periorRankNow) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("perrior_rank", periorRankNow);
  }

  Future<void> rewardGift(BuildContext context) async {
    if(await hasKeyRankWeek()){
      if(await isSameWeek(WeekUtils.getCurrentWeekString())){
        // Cùng tuần, không làm gì cả
        return;
      }else{
        if(FirebaseAuth.instance.currentUser != null) {
          String periodNow = WeekUtils.getCurrentWeekString();
          String lastPeriod = await getRankWeek();
          String userId = FirebaseAuth.instance.currentUser!.uid;
          Map<String, dynamic> dataScoreByUser = await ServiceLocator.scoreService
              .getScore(lastPeriod, userId);
          print("dataScoreByUser: $dataScoreByUser");
          if(!dataScoreByUser.containsKey("error")){
              int rank = dataScoreByUser["rank"];
              if(rank > 0 && rank <= 3) {
                //delay 1s
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.push(
                  context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 900),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          rewardRankScreen(rank: rank), // màn hình nhận quà
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        var scaleTween = Tween<double>(begin: 0.5, end: 1.0)
                            .chain(CurveTween(curve: Curves.elasticOut)); // bật nhẹ
                        var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

                        return FadeTransition(
                          opacity: animation.drive(fadeTween),
                          child: ScaleTransition(
                            scale: animation.drive(scaleTween),
                            child: child,
                          ),
                        );
                      },
                    )
                );
              }
          }

          setRankWeek(periodNow);
        }
      }
    }
    else{
      setRankWeek(WeekUtils.getCurrentWeekString());
    }
  }
}