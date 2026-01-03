import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Config/rank_manager.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/achivement/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/rank/bloc/rank_bloc.dart';
import 'package:japaneseapp/features/rank/bloc/rank_event.dart';
import 'package:japaneseapp/features/rank/bloc/rank_state.dart';
import 'package:japaneseapp/features/rank/data/datasource/leaderboard_datasource.dart';
import 'package:japaneseapp/features/rank/data/datasource/user_datasource.dart';
import 'package:japaneseapp/features/rank/data/repositories/leaderboard_repository_impl.dart';
import 'package:japaneseapp/features/rank/data/repositories/user_repository_impl.dart';
import 'package:japaneseapp/features/rank/domain/usecase/show_summary_rank.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/rank_circular_progress.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/rank_leaderboard.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/tilted_rank_ring.dart';

class RankPage extends StatefulWidget{
  final String userId;

  const RankPage({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() => _RankPageState();

}

class _RankPageState extends State<RankPage>{

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
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RankBloc(
            LeaderboardRepositoryImpl(datasource: LeaderboardDatasource()),
            UserRepositoryImpl(datasource: UserDatasource())
        )..add(LoadRankEvent(userId: widget.userId)),
        child: BlocConsumer<RankBloc, RankState>(
            buildWhen: (previous, current) => current is LoadedRankState,
            builder: (context, state){
              if(state is LoadingRankState){
                return Scaffold(
                  body: Container(
                    color: Colors.white,
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
                        Text("Loading...", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize:  25),)
                      ],
                    ),
                  ),
                );
              }

              if(state is LoadedRankState){
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Bảng Xếp Hạng", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20),),
                    backgroundColor: Colors.white,
                    scrolledUnderElevation: 0,
                  ),
                  body: Container(
                    color: Colors.white,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 80,),
                                TiltedRankRing(
                                    child: RankCircularProgress(
                                      percent: (state.userEntity.score - RankManager.rankMap[getRank(state.userEntity.score)]["pre_max"]) / RankManager.rankMap[getRank(state.userEntity.score)]["max"],
                                      size: 210,
                                    )
                                )
                              ],
                            ),
                            SizedBox(
                              width: 180,
                              height: 180,
                              child: Image.asset(RankManager.rankMap[getRank(state.userEntity.score)]["image"]),
                            ),
                            Column(
                              children: [
                                SizedBox(height: 200,),
                                Text("${RankManager.rankMap[getRank(state.userEntity.score)]["name"]}",
                                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: RankManager.rankMap[getRank(state.userEntity.score)]["color"]),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${state.userEntity.score - RankManager.rankMap[getRank(state.userEntity.score)]["pre_max"]} ", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: RankManager.rankMap[getRank(state.userEntity.score)]["color"]),),
                            Text("/ ${RankManager.rankMap[getRank(state.userEntity.score)]["max"]}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Text("Hạng ${state.userEntity.rank}"),
                        Expanded(child: RankLeaderboard(users: state.leaderboardEntity))
                        
                      ],
                    ),
                  ),
                );
              }

              return Container(
                color: Colors.white,
              );
            },
            listener: (context, state){
              if(state is RewardRankState){
                ShowSummaryRankUsecase.call(context, FirebaseAuth.instance.currentUser!.uid);
              }
            }
        ),
    );
  }

}