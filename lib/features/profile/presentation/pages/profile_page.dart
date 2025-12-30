import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/core/utils/number_formatter.dart';
import 'package:japaneseapp/features/character/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/profile/bloc/profile_bloc.dart';
import 'package:japaneseapp/features/profile/bloc/profile_event.dart';
import 'package:japaneseapp/features/profile/bloc/profile_state.dart';
import 'package:japaneseapp/features/profile/data/datasource/profile_local_datasource.dart';
import 'package:japaneseapp/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:japaneseapp/features/profile/data/repository/profile_repository_impl.dart';
import 'package:japaneseapp/features/profile/domain/repository/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget{

  final List<String> weekdays = ["M", "T", "W", "T", "F", "S", "S"];

  String getImage(int level) {
    if (level < 20) {
      return "https://res.cloudinary.com/dwvfogq0y/image/upload/v1760877322/level_1_1_vasp2z.png";
    } else if (level < 40) {
      return "https://res.cloudinary.com/dwvfogq0y/image/upload/v1760877323/level_2_1_y0tag3.png";
    } else if (level < 60) {
      return "https://res.cloudinary.com/dwvfogq0y/image/upload/v1760877323/level_3_1_tbwwan.png";
    } else if (level < 80) {
      return "https://res.cloudinary.com/dwvfogq0y/image/upload/v1760877324/level_4_1_zkp2vm.png";
    } else {
      return "https://res.cloudinary.com/dwvfogq0y/image/upload/v1760877325/level_5_1_zzmhwd.png";
    }
  }

  String getTitle(BuildContext context, int level) {
    if (level < 10) {
      return AppLocalizations.of(context)!.levelTitles_1;
    } else if (level < 20) {
      return AppLocalizations.of(context)!.levelTitles_2;
    } else if (level < 30) {
      return AppLocalizations.of(context)!.levelTitles_3;
    } else if (level < 40) {
      return AppLocalizations.of(context)!.levelTitles_4;
    } else if (level < 50) {
      return AppLocalizations.of(context)!.levelTitles_5;
    } else if (level < 60) {
      return AppLocalizations.of(context)!.levelTitles_6;
    } else if (level < 70) {
      return AppLocalizations.of(context)!.levelTitles_7;
    } else if (level < 80) {
      return AppLocalizations.of(context)!.levelTitles_8;
    } else if (level < 90) {
      return AppLocalizations.of(context)!.levelTitles_9;
    } else if (level < 100) {
      return AppLocalizations.of(context)!.levelTitles_10;
    } else if (level < 110) {
      return AppLocalizations.of(context)!.levelTitles_11;
    } else if (level < 120) {
      return AppLocalizations.of(context)!.levelTitles_12;
    } else if (level < 130) {
      return AppLocalizations.of(context)!.levelTitles_13;
    } else if (level < 150) {
      return AppLocalizations.of(context)!.levelTitles_14;
    } else {
      return AppLocalizations.of(context)!.levelTitles_15;
    }
  }

  List<Map<String, String>> getWeekDays() {
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday; // 1 = Thứ Hai, ..., 7 = Chủ Nhật
    DateTime monday =
    today.subtract(Duration(days: currentWeekday - 1)); // Lùi về Thứ Hai

    List<Map<String, String>> days = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = monday.add(Duration(days: i));
      String formattedDate = date.day.toString().padLeft(2, '0');
      String weekday = weekdays[i];
      days.add({"date": formattedDate, "weekday": weekday});
    }
    return days;
  }

  List<Map<String, String>> getWeekDayMothYears() {
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday; // 1 = Thứ Hai, ..., 7 = Chủ Nhật
    DateTime monday =
    today.subtract(Duration(days: currentWeekday - 1)); // Lùi về Thứ Hai

    List<Map<String, String>> days = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = monday.add(Duration(days: i));
      String formattedDate =
          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}";
      String weekday = weekdays[i];
      days.add({"date": formattedDate, "weekday": weekday});
    }
    print(days);
    return days;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> days = getWeekDays();
    List<Map<String, String>> daymonthYears = getWeekDayMothYears();
    DateTime today = DateTime.now();
    String todayFormatted = today.day.toString().padLeft(2, '0');

    return BlocProvider(
      create: (context) => ProfileBloc(
          ProfileRepositoryImpl(
            ProfileLocalDataSourceImpl(),
            ProfileRemoteDataSourceImpl()
          )
      )..add(LoadProfileEvent()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
          builder: (context, state){
            if(state is LoadingProfileState){
              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingImage(
                        pathImage: "assets/character/hinh12.png",
                        width: 250,
                        height: 250
                    ),
                    Text("Loading...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
                  ],
                ),
              );
            }

            if(state is LoadedProfileState){
              return Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                color: Color(0xFFFFA2B1),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 110,),
                          Image.network(
                            getImage(state.profileEntity.progress.level),
                            width: MediaQuery.sizeOf(context).width/1.9,
                            fit: BoxFit.fitWidth,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height/2.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width/5),
                              child: Column(
                                children: [
                                  Text("${state.profileEntity.progress.level}", style: TextStyle(color: AppColors.primary, fontSize: 80, fontWeight: FontWeight.bold, height: 1),),
                                  const Text("Level", style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Itim"),),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width/2,
                      height: MediaQuery.sizeOf(context).height/2.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 220,),
                          Container(
                            width: MediaQuery.sizeOf(context).width/2,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: LinearProgressIndicator(
                              value: (state.profileEntity.progress.exp) / (state.profileEntity.progress.nextExp),
                              minHeight: 5,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text("${state.profileEntity.progress.exp}/${state.profileEntity.progress.nextExp}", textAlign: TextAlign.center, style: TextStyle(color: AppColors.primary),)
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 65,),
                        Container(
                          width: MediaQuery.sizeOf(context).width/2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.profileEntity.user.displayName??"N/A", textAlign: TextAlign.center , style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors.primary),),
                            ],
                          ),
                        ),

                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.sizeOf(context).width-70,),
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            color: Colors.white,
                            child: Column(
                              children: [
                                SizedBox(height: 40,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text("${state.profileEntity.statistic.topicCount}", style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black, height: 1),),
                                        Text(AppLocalizations.of(context)!.profile_topic, style: TextStyle(fontFamily: "Itim", fontWeight: FontWeight.bold, color: Colors.grey[500], fontSize: 20),)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(getTitle(context, state.profileEntity.progress.level), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black, height: 1.7),),
                                        Text(AppLocalizations.of(context)!.profile_title, style: TextStyle(fontFamily: "Itim", fontWeight: FontWeight.bold, color: Colors.grey[500], fontSize: 20),)
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  color: Colors.grey.shade300, // Màu của đường kẻ
                                  thickness: 1,
                                  indent: 50,
                                  endIndent: 50,// Độ dày
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(2, 2),
                                            blurRadius: 10
                                        )
                                      ],
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  width: MediaQuery.sizeOf(context).width-40,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${state.profileEntity.streak.lastHistoryStreak.length}",
                                              style: TextStyle(
                                                  color: ((state.profileEntity.streak.lastHistoryStreak)
                                                      .contains(
                                                      "${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year.toString()}"))
                                                      ? Colors.orange
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30)),
                                          Icon(
                                            Icons.local_fire_department,
                                            color: ((state.profileEntity.streak.history)
                                                .contains(
                                                "${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year.toString()}"))
                                                ? Colors.orange
                                                : Colors.grey,
                                            size: 50,
                                          )
                                        ],
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.profile_date(int.parse(today.month.toString().padLeft(2, '0')), int.parse(today.year.toString())),
                                        style: TextStyle(
                                            color: AppColors.primaryLight.withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            fontFamily: "Itim"
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.sizeOf(context).width,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: weekdays.map((day) {
                                                  return Expanded(
                                                    child: Center(
                                                      child: Text(
                                                        day,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.primaryLight.withOpacity(0.8)),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            // Hiển thị ngày theo hàng ngang
                                            Container(
                                              height: 100,
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 7,
                                                  mainAxisSpacing: 1,// 7 ô theo hàng ngang
                                                  childAspectRatio: 1.2, // Căn chỉnh tỉ lệ ô
                                                ),
                                                itemCount: days.length,
                                                itemBuilder: (context, index) {
                                                  bool isToday =
                                                      days[index]["date"] == todayFormatted;
                                                  return Stack(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: isToday
                                                                    ? Colors.black
                                                                    : Colors.black
                                                                    .withOpacity(0.0)),
                                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            days[index]["date"]!,
                                                            style: const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      if ((state.profileEntity.streak.history)
                                                          .contains(
                                                          daymonthYears[index]["date"]))
                                                        Text("🔥"),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                                SizedBox(height: 100,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 60,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //coin
                              Container(
                                width: 120,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFDEDE).withOpacity(0.6),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(NumberFormatter.formatHumanReadable(state.profileEntity.wallet.coin), style: TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                                        SizedBox(width: 5),
                                        Image.asset("assets/kujicoin.png", width: 20, height: 20,),
                                      ],
                                    )
                                ),
                              ),
                              IconButton(onPressed: (){
                                //go to screen settingScreen with adnimation slide right to left
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => Container(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              }, icon: Icon(Icons.settings, size:30)),
                              SizedBox(width: 20,),
                            ],
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            if(state is ErrorProfileState){
              print(state.msg);
            }

            return Container();
          },
          listener: (context, state){}
      ),
    );
  }

}