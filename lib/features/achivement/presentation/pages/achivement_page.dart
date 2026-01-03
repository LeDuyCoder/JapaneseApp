import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Config/achivementJson.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/achivement/bloc/achivement_bloc.dart';
import 'package:japaneseapp/features/achivement/bloc/achivement_event.dart';
import 'package:japaneseapp/features/achivement/bloc/achivement_state.dart';
import 'package:japaneseapp/features/achivement/data/datasource/achivements_local_datasource.dart';
import 'package:japaneseapp/features/achivement/data/repositories/achievement_local_repository.dart';
import 'package:japaneseapp/features/achivement/presentation/widgets/achievement_box_widget.dart';
import 'package:japaneseapp/features/achivement/presentation/widgets/achievement_tab.dart';
import 'package:japaneseapp/features/achivement/presentation/widgets/floating_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchivementPage extends StatefulWidget {
  final SharedPreferences prefs;

  const AchivementPage({super.key, required this.prefs});

  @override
  State<StatefulWidget> createState() => _AchivementPageState();
}

class _AchivementPageState extends State<AchivementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AchivementBloc(
          repository: AchievementLocalRepository(
              widget.prefs, AchivementsLocalDatasource()))
        ..add(LoadAchivementEvent()),
      child: BlocConsumer<AchivementBloc, AchivementState>(
          builder: (context, state) {
            if (state is LoadingAchivementState) {
              return Scaffold(
                body: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  color: Colors.white,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingImage(
                          pathImage: "assets/character/hinh12.png",
                          width: 250,
                          height: 250),
                      Text(
                        "Loading...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.grey),
                      )
                    ],
                  ),
                ),
              );
            }

            if (state is LoadedAchivementState) {
              final double progress =
                  state.achivementEntity.achivemenetsOpened.length / 7;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Thành Tựu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: AppColors.primary),
                      ),
                      Text(
                        '${state.achivementEntity.achivemenetsOpened.length}/7 thành tựu đã mở khóa',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      )
                    ],
                  ),
                  scrolledUnderElevation: 0,
                ),
                body: Container(
                    color: Colors.white,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.95,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ===== TITLE & PERCENT =====
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Tiến độ thành tựu",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${(progress * 100).toStringAsFixed(1)}%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // ===== PROGRESS BAR =====
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    minHeight: 8,
                                    value: progress.clamp(0.0, 1.0),
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    valueColor: const AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // ===== COUNT =====
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${state.achivementEntity.achivemenetsOpened.length} đã mở",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      "7 tổng số",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Danh sách thành tựu",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        AchievementTabBar(controller: _tabController),
                        Expanded(
                          child:
                              TabBarView(controller: _tabController, children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  for (var item in state
                                      .achivementEntity.achivements) ...[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: AchievementBoxWidget(
                                          title: item["title"],
                                          description: item["description"],
                                          imagePath: item["img"],
                                          isUnlocked: state.achivementEntity
                                              .achivemenetsOpened
                                              .contains(item["key"])),
                                    )
                                  ]
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                     if (state.achivementEntity.achivemenetsOpened.isNotEmpty)...[
                                        for (final achievement in achivementJson.instance.data) ...[
                                          if (state.achivementEntity.achivemenetsOpened.contains(achievement["key"])) ...[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              child: AchievementBoxWidget(
                                                title: achievement["title"]!,
                                                description: achievement["description"]!,
                                                imagePath: achievement["img"]!,
                                                isUnlocked: state.achivementEntity.achivemenetsOpened.contains(achievement["key"]),
                                              ),
                                            ),
                                          ]
                                        ]
                                     ]else...[
                                       Container(
                                         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                         padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                                         decoration: BoxDecoration(
                                           color: Colors.orange.withOpacity(0.08),
                                           borderRadius: BorderRadius.circular(16),
                                           border: Border.all(
                                             color: Colors.orange.withOpacity(0.25),
                                           ),
                                         ),
                                         child: const Row(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             Icon(
                                               Icons.auto_awesome_rounded,
                                               size: 26,
                                               color: Colors.orange,
                                             ),
                                             SizedBox(width: 10),
                                             Text(
                                               "Hãy bắt đầu học để mở thành tựu đầu tiên ✨",
                                               style: TextStyle(
                                                 fontSize: 14.5,
                                                 color: Colors.orange,
                                                 fontWeight: FontWeight.w600,
                                               ),
                                             ),
                                           ],
                                         ),
                                       )
                                     ]
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      if (state.achivementEntity.achivemenetsOpened.length != 7)...[
                                        for (final achievement in achivementJson.instance.data) ...[
                                          if (!state.achivementEntity.achivemenetsOpened.contains(achievement["key"])) ...[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              child: AchievementBoxWidget(
                                                title: achievement["title"]!,
                                                description: achievement["description"]!,
                                                imagePath: achievement["img"]!,
                                                isUnlocked: state.achivementEntity.achivemenetsOpened.contains(achievement["key"]),
                                              ),
                                            ),
                                          ]
                                        ]
                                      ]else...[
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: AppColors.primary.withOpacity(0.25),
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.emoji_events_rounded,
                                                size: 28,
                                                color: AppColors.primary,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Bạn đã mở tất cả thành tựu 🎉",
                                                style: TextStyle(
                                                  fontSize: 14.5,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ]),
                        )
                      ],
                    )),
              );
            }

            return Container();
          },
          listener: (context, state) {}),
    );
  }
}
