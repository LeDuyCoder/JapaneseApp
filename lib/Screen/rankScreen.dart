import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:japaneseapp/Service/RewardRankService.dart';
import 'package:japaneseapp/Theme/colors.dart';
import 'package:japaneseapp/Utilities/WeekUtils.dart';

import '../Service/Server/ServiceLocator.dart';

class rankScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _rankScreen();
}

class _rankScreen extends State<rankScreen>{

  String formatNumber(int number) {
    final formatter = NumberFormat("#,###", "en_US");
    return formatter.format(number);
  }

  String formatName(String fullname) {
    if (fullname.trim().isEmpty) return "";

    List<String> parts = fullname.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      String first = parts[parts.length - 2][0].toUpperCase();
      String second = parts.last[0].toUpperCase();
      return first + second;
    }
  }


  Map<String, dynamic> rankMap = {
    "Bronze": {
      "min": 0,
      "max": 500,
      "color": Colors.brown,
      "image": "assets/rank/copper.png",
      "name": "Bậc Đồng",
      "next": "Bạc"
    },
    "Silver": {
      "min": 501,
      "max": 1500,
      "color": Colors.grey,
      "image": "assets/rank/silver.png",
      "name": "Bậc Bạc",
      "next": "Vàng"
    },
    "Gold": {
      "min": 1501,
      "max": 3000,
      "color": Colors.orange,
      "image": "assets/rank/gold.png",
      "name": "Bậc Vàng",
      "next": "Kim Cương"
    },
    "Diamond": {
      "min": 3001,
      "max": 5000,
      "color": Colors.blueAccent,
      "image": "assets/rank/diamond.png",
      "name": "Bậc Kim Cương",
      "next": "Ruby"
    },
    "Ruby": {
      "min": 5001,
      "max": 8000,
      "color": Colors.red,
      "image": "assets/rank/ruby.png",
      "name": "Bậc Ruby",
      "next": "Obsidian"
    },
    "Obsidian": {
      "min": 8001,
      "max": double.infinity,
      "color": Colors.purple,
      "image": "assets/rank/Obsidian.png",
      "name": "Bậc Obsidian",
      "next": "Top 1"
    },
  };

  String getRank(int score){
    if(score <= 500){
      return "Bronze";
    } else if(score <= 1500){
      return "Silver";
    } else if(score <= 3000){
      return "Gold";
    } else if(score <= 5000){
      return "Diamond";
    } else if(score <= 8000){
      return "Ruby";
    } else {
      return "Obsidian";
    }
  }

  Future<List<dynamic>> loadData(String userId, String period) async {
    List<Object> list = [];



    list.add(await ServiceLocator.scoreService.getScore(period, userId));
    list.add(await ServiceLocator.scoreService.getLeaderboard(period, 10));

    rewardRankService().rewardGift(context);

    //print(await ServiceLocator.scoreService.getLeaderboard(period, 10));

    return list;
  }

  Widget _buildRankItem(BuildContext context, int rank, String name, String level, String initials, String score, Color levelColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.sizeOf(context).width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "$rank",
                style: TextStyle(
                  fontFamily: "Itim",
                  fontSize: 20,
                  color: rank == 1 ? Colors.amber : (rank == 2 ? Colors.grey : (rank == 3 ? Colors.brown : AppColors.textPrimary)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: "Itim",
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    level,
                    style: TextStyle(
                      fontFamily: "Itim",
                      fontSize: 16,
                      color: levelColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            score,
            style: const TextStyle(
              fontFamily: "Itim",
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.backgroundPrimary,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(CupertinoIcons.arrow_left)),
        ),
        body: FutureBuilder(future:loadData(FirebaseAuth.instance.currentUser!.uid, WeekUtils.getCurrentWeekString()), builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Container(
                height: 100,
                width: 100,
                child: const CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }

          return Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: AppColors.backgroundPrimary,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      child: Image.asset(snapshot.data![0]["score"] != null ? rankMap[getRank(snapshot.data![0]["score"])]["image"] : rankMap["Bronze"]["image"]),
                    ),
                    Text(snapshot.data![0]["score"] != null ? rankMap[getRank(snapshot.data![0]["score"])]["name"] : "NaN" ,style: TextStyle(fontFamily: "Itim", fontSize: 35, fontWeight: FontWeight.bold, color: rankMap[getRank(snapshot.data![0]["score"])]["color"])),
                    Container(
                      width: MediaQuery.sizeOf(context).width/1.2,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tiến trình", style: TextStyle(fontFamily: "Itim", fontSize: 20, color: AppColors.textPrimary)),
                              Text("${double.parse(((snapshot.data![0]["score"] / rankMap[getRank(snapshot.data![0]["score"])]["max"]) * 100).toStringAsFixed(1))}%", style: TextStyle(fontFamily: "Itim", fontSize: 20, color: AppColors.textPrimary)),
                            ],
                          ),
                          LinearProgressIndicator(
                              value: rankMap[getRank(snapshot.data![0]["score"])]["max"] == double.infinity ? 1 : snapshot.data![0]["score"]/rankMap[getRank(snapshot.data![0]["score"])]["max"],
                              color: snapshot.data![0]["score"] != null ? rankMap[getRank(snapshot.data![0]["score"])]["color"] : AppColors.primary,
                              backgroundColor: snapshot.data![0]["score"] != null ? rankMap[getRank(snapshot.data![0]["score"])]["color"].withOpacity(0.3) : AppColors.primary.withOpacity(0.3)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Còn ${rankMap[getRank(snapshot.data![0]["score"])]["max"] - snapshot.data![0]["score"]} điểm lên ${rankMap[getRank(snapshot.data![0]["score"])]["next"]}", style: TextStyle(fontFamily: "Itim", fontSize: 16, color: AppColors.textPrimary)),
                            ],
                          ),
                          SizedBox(height: 20,),

                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width / 1.1,
                      constraints: const BoxConstraints(
                        minHeight: 200, // đặt chiều cao tối thiểu là 100
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 10,),
                              Text("Bảng Xếp Hạng", style: TextStyle(fontFamily: "Itim", fontSize: 25, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Divider(
                                color: Colors.grey, // Màu của đường kẻ
                                thickness: 1,
                                indent: 0,
                                endIndent: 9,// Độ dày
                              ),
                              Column(
                                children: [
                              for (var entry in snapshot.data![1].asMap().entries)
                                _buildRankItem(
                                    context,
                                    entry.key + 1, // đây là thứ hạng: index + 1
                                    entry.value["user_name"],
                                    entry.value["score"] != null
                                        ? rankMap[getRank(entry.value["score"])]["name"]
                                        : "NaN",
                                    formatName(entry.value["user_name"]),
                                    formatNumber(entry.value["score"]),
                                    entry.value["score"] != null
                                        ? rankMap[getRank(entry.value["score"])]["color"]
                                        : Colors.brown,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: MediaQuery.sizeOf(context).width / 1.1,
                      constraints: const BoxConstraints(
                        minHeight: 100, // đặt chiều cao tối thiểu là 100
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            width: MediaQuery.sizeOf(context).width/1.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("${snapshot.data![0]["rank"]}", style: TextStyle(fontFamily: "Itim", fontSize: 20,
                                        color: snapshot.data![0]["rank"] == 1 ? Colors.amber : (snapshot.data![0]["rank"] == 2 ? Colors.grey : (snapshot.data![0]["rank"] == 3 ? Colors.brown : AppColors.textPrimary))
                                    )),
                                    Container(
                                        margin: EdgeInsets.only(left: 10),
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.7),
                                            borderRadius: BorderRadius.all(Radius.circular(15))
                                        ),
                                        child: Center(
                                          child: Text(formatName(snapshot.data![0]["user_name"]), style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 20, fontWeight: FontWeight.bold),),
                                        )
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data![0]["user_name"], style: TextStyle(fontFamily: "Itim", fontSize: 20, color: AppColors.textPrimary)),
                                        Text(snapshot.data![0]["score"] != null ? rankMap[getRank(snapshot.data![0]["score"])]["name"] : "NaN" ,style: TextStyle(fontFamily: "Itim", fontSize: 16, fontWeight: FontWeight.bold, color: rankMap[getRank(snapshot.data![0]["score"])]["color"])),
                                      ],
                                    )
                                  ],
                                ),
                                Text(formatNumber(snapshot.data![0]["score"]), style: TextStyle(fontFamily: "Itim", fontSize: 20, color: AppColors.textPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50,),
                  ],
                ),
              )
          );
        })
      ),
    );
  }
}