import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/achivement/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/rank/bloc/summary_rank_bloc.dart';
import 'package:japaneseapp/features/rank/bloc/summary_rank_event.dart';
import 'package:japaneseapp/features/rank/bloc/summary_rank_state.dart';
import 'package:japaneseapp/features/rank/data/datasource/rank_datasource.dart';
import 'package:japaneseapp/features/rank/data/repositories/rank_repository_impl.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/button_widget.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/final_rank_section.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/header_section.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/leaderboard_section.dart';
import 'package:japaneseapp/features/rank/presentation/widgets/tap_to_unlock_reward.dart';

class RankSummaryPage extends StatelessWidget{
  final String userId;

  const RankSummaryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SummaryRankBloc(
        repository: RankRepositoryImpl(datasource: RankDatasource())
      )..add(LoadSummaryRankEvent(userId: userId)),
      child: BlocConsumer<SummaryRankBloc, SummaryRankState>(
          buildWhen: (previous, current) => current is LoadedSummaryRankState,
          builder: (context, state){
            if(state is LoadingSummaryRankState){
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
                      Text("Loading...", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 25),)
                    ],
                  ),
                ),
              );
            }

            if(state is LoadedSummaryRankState){
              return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const HeaderSection(),
                        const SizedBox(height: 10),

                        FinalRankSection(userEntity: state.summaryRankEntity.rankEntity.userEntity,),
                        const SizedBox(height: 32),

                        const Row(
                          children: [
                            Expanded(
                              child: Divider(thickness: 1),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Thông tin mùa giải',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(thickness: 1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        LeaderboardSection(leaderboardEntity: state.summaryRankEntity.leaderboardEntity),
                        const SizedBox(height: 32),

                        if(state.summaryRankEntity.rankEntity.userEntity.rank <= 3)...[
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(thickness: 1),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'Phần Thưởng',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(thickness: 1),
                              ),
                            ],
                          ),
                          const TapToUnlockReward(image: AssetImage("assets/character/hinh16.png"),
                              reward: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 100,),
                                      Text("X500", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                      SizedBox(width: 10,),
                                      FloatingImage(
                                          pathImage: "assets/kujicoin.png",
                                          width: 40,
                                          height: 40
                                      )
                                    ],
                                  ),
                                ],
                              )
                          ),
                          const SizedBox(height: 20,),
                          ButtonWidget(
                            onTap: () async {
                              context.read<SummaryRankBloc>().add(RewardSummaryRankEvent(summaryRankEntity: state.summaryRankEntity));
                            },
                          )
                        ]
                        else...[
                          ButtonWidget(
                            onTap: () async {
                              context.read<SummaryRankBloc>().add(RewardSummaryRankEvent(summaryRankEntity: state.summaryRankEntity));
                            },
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              );
            }

            else{
              return Container();
            }
          },
          listener: (context, state){
            if(state is RewardCompletedState){
              Navigator.pop(context);
            }
          }
      ),
    );
  }
}