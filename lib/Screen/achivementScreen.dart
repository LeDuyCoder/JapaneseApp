import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Service/FunctionService.dart';
import '../Config/dataHelper.dart';
import '../generated/app_localizations.dart';

class achivementScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _achivementScreen();
}

class _achivementScreen extends State<achivementScreen>{
  int amountTopicComplite = 0;

  void showBottomSheetAchivementInfor(
      BuildContext ctx, String title, String description, String image, bool isOwn) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) setState) {
            return Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 200,
                      height: 200,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.white,
                            isOwn ? BlendMode.dst : BlendMode.saturation
                        ),
                        child: Image.asset(
                          image
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).width * 0.04,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  bool checkAchivement(Map<String, dynamic> data, String achivement){
    return (data["achivement"] as List<String>).contains(achivement);
  }

  bool checkStreak(int userStreak, int streak){
    return userStreak >= streak;
  }

  Future<Map<String, dynamic>> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DatabaseHelper db = await DatabaseHelper.instance;
    amountTopicComplite = await FunctionService.getTopicComplite();
    print(amountTopicComplite);

    User user = FirebaseAuth.instance.currentUser!;

    return {
      "level": prefs.getInt("level"),
      "exp": prefs.getInt("exp"),
      "nextExp": prefs.getInt("nextExp"),
      "Streak": prefs.getStringList("checkInHistoryTreak")!.length,
      "lastCheckIn": prefs.getString("lastCheckIn"),
      "checkInHistory": prefs.getStringList("checkInHistory"),
      "checkInHistoryTreak": prefs.getStringList("checkInHistoryTreak"),
      "achivement": prefs.getStringList("achivement"),
      "providerID": user.providerData[0].providerId,
      "displayName": user.providerData[0].displayName,
      "mail": user.email,
      "countTopic": (await db.getAllTopic()).length
    };
  }


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> achievements = [
      {
        "title": AppLocalizations.of(context)!.achivement_owl_title,
        "description": AppLocalizations.of(context)!.achivement_owl_description,
        "key": "cudemhockhuya",
        "image": ["assets/achivement/overnight.png", "assets/achivement/no-overnight.png"],
        "check": (data) => checkAchivement(data, "cudemhockhuya"),
      },
      {
        "title": AppLocalizations.of(context)!.achivement_tryhard_title,
        "description": AppLocalizations.of(context)!.achivement_tryhard_description,
        "key": "trithucdaysom",
        "image": ["assets/achivement/earnly.png", "assets/achivement/no-earnly.png"],
        "check": (data) => checkAchivement(data, "trithucdaysom"),
      },
      {
        "title": AppLocalizations.of(context)!.achivement_habit_title,
        "description": AppLocalizations.of(context)!.achivement_habit_description,
        "key": "Streak",
        "image": ["assets/achivement/Habitualrot.png", "assets/achivement/no-Habitualrot.png"],
        "check": (data) => checkStreak(data["Streak"], 28),
      }
    ];

    List<int> topicMilestones = [1, 5, 10, 50, 100];
    List<int> streakMilestones = [1, 5, 10, 20, 50];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        scrolledUnderElevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back, size: 30,)),
      ),
      body: FutureBuilder(future: getData(), builder: (context, snapshot){
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

        if(!snapshot.hasData){
          return Center(
            child: Container(
                height: MediaQuery.sizeOf(context).width*0.8,
                child: Image.asset("assets/404.png")
            ),
          );
        }

        //var data = snapshot.data as Map<String, dynamic>;
        return Container(
            color: Colors.white,
            child: Container(
              color: AppColors.backgroundPrimary,
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width / 1.1,
                      height: 680,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.grey,
                                offset: Offset(0, 2),
                                blurRadius: 10
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Text(AppLocalizations.of(context)!.achivement_title_one, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.primary),)),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                childAspectRatio: 4/4,
                              ),
                              itemCount: achievements.length,
                              itemBuilder: (context, index) {
                                final achievement = achievements[index];
                                String imagePath = achievement["image"][0];

                                return GestureDetector(
                                  onTap: () {
                                    if (achievement.containsKey("description")) {
                                      showBottomSheetAchivementInfor(context, achievement["title"], achievement["description"], imagePath, achievement["check"](snapshot.data!));
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: MediaQuery.sizeOf(context).height,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              Colors.white,
                                              achievement["check"](snapshot.data!) ? BlendMode.dst : BlendMode.saturation
                                          ),
                                          child: Image.asset(
                                            imagePath,
                                            scale: 3,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          achievement["title"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: "Itim",
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50,),
                    Container(
                        width: MediaQuery.sizeOf(context).width / 1.1,
                        height: 800,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 10
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text(AppLocalizations.of(context)!.achivement_title_two, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.primary),)),
                            SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 5),
                              child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2, // số cột muốn hiển thị
                                mainAxisSpacing: 5, // khoảng cách dọc
                                crossAxisSpacing: 5, // khoảng cách ngang
                                childAspectRatio: 4/4,
                                physics: const NeverScrollableScrollPhysics(), // tránh conflict với scroll cha
                                children: streakMilestones.map((streak) {
                                  String imagePath = "assets/achivement/dayStreak/${streak}day.png";

                                  return GestureDetector(
                                    onTap: () {
                                      showBottomSheetAchivementInfor(
                                        context,
                                        AppLocalizations.of(context)!.achivement_streak_title("$streak"),
                                        AppLocalizations.of(context)!.achivement_streak_description("$streak"),
                                        imagePath,
                                        checkStreak(snapshot.data!["Streak"], streak),
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            Colors.white,
                                            checkStreak(snapshot.data!["Streak"], streak)
                                                ? BlendMode.dst
                                                : BlendMode.saturation,
                                          ),
                                          child: Image.asset(imagePath, scale: 14),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .achivement_streak_title("$streak"),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: "Itim",
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )
                    ),
                    const SizedBox(height: 50,),
                    Container(
                        width: MediaQuery.sizeOf(context).width / 1.1,
                        height: 700,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 10
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text(AppLocalizations.of(context)!.achivement_title_three, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.primary),)),
                            SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: GridView.count(
                                shrinkWrap: true, // để GridView nằm gọn trong Column
                                physics: const NeverScrollableScrollPhysics(), // tránh conflict với Scroll cha
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1, // chỉnh lại tỉ lệ (thấp hơn 1 cho item cao hơn)
                                children: topicMilestones.map((topic) {
                                  String imagePath = "assets/achivement/finish/${topic}_finish.png";

                                  return GestureDetector(
                                    onTap: () {
                                      showBottomSheetAchivementInfor(
                                        context,
                                        AppLocalizations.of(context)!.achivement_topic_title("$topic"),
                                        AppLocalizations.of(context)!.achivement_topic_description("$topic"),
                                        imagePath,
                                        amountTopicComplite >= topic,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Expanded( // co giãn hình cho vừa khung
                                          child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                Colors.white,
                                                amountTopicComplite >= topic
                                                    ? BlendMode.dst
                                                    : BlendMode.saturation,
                                              ),
                                              child: Container(
                                                width: 150,
                                                height: 150,
                                                child: Image.asset(imagePath, fit: BoxFit.contain),
                                              )
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          AppLocalizations.of(context)!.achivement_topic_title("$topic"),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: "Itim",
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        )
                    ),

                  ],
                ),
              ),
            )
        );
      }),
    );
  }
}