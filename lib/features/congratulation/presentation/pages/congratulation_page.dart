import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/utils/duration_formatter.dart';
import 'package:japaneseapp/features/achivement/domain/service/evaluators/effect_reward.dart';
import 'package:japaneseapp/features/ads/presentation/cubit/AdsCubit.dart';
import 'package:japaneseapp/features/congratulation/bloc/congratulation_bloc.dart';
import 'package:japaneseapp/features/congratulation/bloc/congratulation_event.dart';
import 'package:japaneseapp/features/congratulation/bloc/congratulation_state.dart';
import 'package:japaneseapp/features/congratulation/data/datasource/user_progress_local_datasource.dart';
import 'package:japaneseapp/features/congratulation/data/datasource/user_remote_datasource.dart';
import 'package:japaneseapp/features/congratulation/data/repositories/user_progress_repository_impl.dart';
import 'package:japaneseapp/features/congratulation/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/congratulation/domain/enum/type_congratulation.dart';
import 'package:japaneseapp/features/congratulation/presentation/widgets/animated_loading_ads_dialog.dart';
import 'package:japaneseapp/features/congratulation/presentation/widgets/animated_loading_widget.dart';
import 'package:japaneseapp/features/congratulation/presentation/widgets/floating_image.dart';

class CongratulationPage extends StatefulWidget {
  final int correctAnswer;
  final int inCorrectAnswer;
  final int totalQuestion;
  final Duration elapsed;
  final TypeCongratulation type;
  final List<WordEntity> words;

  CongratulationPage(
      {super.key,
        required this.correctAnswer,
        required this.inCorrectAnswer,
        required this.totalQuestion,
        required this.words,
        required this.elapsed,
        required this.type
      });

  @override
  State<StatefulWidget> createState() => _CongratulationPage();
}

class _CongratulationPage extends State<CongratulationPage>
    with TickerProviderStateMixin {
  late AnimationController _controllerProcess;
  late Animation<double> _animationProcess;
  bool loadingAds = false;
  bool watchedAds = false;

  @override
  void initState() {
    super.initState();

    _controllerProcess = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animationProcess = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _controllerProcess, curve: Curves.easeInOut),
    );
  }

  void startProgressAnimation(double endValue) {
    _animationProcess = Tween<double>(begin: 0.0, end: endValue).animate(
      CurvedAnimation(parent: _controllerProcess, curve: Curves.easeInOut),
    );

    _controllerProcess.forward(from: 0); // bắt đầu lại từ 0 mỗi lần gọi
  }

  Future<void> _showEffectsSequentially(
      BuildContext context,
      List<EffectReward> rewards,
      ) async {
    for (final reward in rewards) {
      if (!context.mounted) return;
      await reward.showEffectReward(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CongratulationBloc(
          UserProgressRepositoryImpl(
              UserProgressLocalDataSource(), UserRemoteDatasource()),
          widget.correctAnswer,
          widget.inCorrectAnswer,
          widget.totalQuestion,
          widget.elapsed
        )..add(CongratulationStarted(
            widget.correctAnswer, widget.inCorrectAnswer, widget.words, widget.type)),
      child: BlocConsumer<CongratulationBloc, CongratulationState>(
          builder: (context, state) {
            final bloc = context.read<CongratulationBloc>();
            final blocCubit = context.read<AdsCubit>();

            if (state is CongratulationLoaded) {
              startProgressAnimation((state.exp + state.expPlus) / state.nextExp);
              return Scaffold(
                body: Container(
                  width: MediaQuery.sizeOf(context).width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                child: Image.asset("assets/animation/6k2.gif"),
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height,
                                color: Colors.white.withOpacity(0.15),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.red.withOpacity(0.6),
                                              spreadRadius: 1,
                                              blurRadius: 15, // độ mờ
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          HeroIcons.trophy,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        "Chúc Mừng",
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 40,
                                            fontFamily: "Itim"),
                                      ),
                                      const Text(
                                        "Bạn đã hoàn thành",
                                        style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: 25,
                                            fontFamily: "Itim",
                                            height: 0.8),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        width:
                                        MediaQuery.sizeOf(context).width /
                                            1.1,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color:
                                          AppColors.grey.withOpacity(0.15),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Bài Học",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "itim",
                                                fontSize: 18,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Thời gian hoàn thành: ",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: "itim",
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  DurationFormatter.format(widget.elapsed),
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontFamily: "itim",
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width:
                                        MediaQuery.sizeOf(context).width /
                                            1.1,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "+${state.expPlus}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40,
                                                  fontFamily: "Itim",
                                                  height: 0.8),
                                            ),
                                            const Text(
                                              "Điểm Kinh Nghiệm",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontFamily: "Itim",
                                                  height: 1.2),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Tiến Trình Level",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${state.exp}/${state.nextExp}",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: SizedBox(
                                          height: 10,
                                          child: AnimatedBuilder(
                                            animation: _animationProcess,
                                            builder: (context, child) {
                                              return LinearProgressIndicator(
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(360)),
                                                value: _animationProcess.value,
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.2),
                                                valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                                    AppColors.primary),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Cấp ${state.level}",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text("Cấp ${state.level + 1}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.grey.withOpacity(0.5)
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          if (state.expRankPlus > 0)
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    TweenAnimationBuilder<int>(
                                                      tween: IntTween(
                                                          begin: 0,
                                                          end: state
                                                              .expRankPlus),
                                                      duration: const Duration(
                                                          milliseconds: 800),
                                                      builder: (context, value,
                                                          child) {
                                                        return Text(
                                                          "+$value",
                                                          style:
                                                          const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 30,
                                                            fontFamily: "Itim",
                                                            height: 0.8,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const FloatingImage(
                                                        pathImage: "assets/exp.png",
                                                        width: 50,
                                                        height: 50
                                                    )
                                                  ],
                                                ),
                                                const Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    "Điểm Rank",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          if (state.expRankPlus > 0 &&
                                              state.coinPlus > 0)
                                            const SizedBox(width: 50),
                                          if (state.coinPlus > 0)
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    TweenAnimationBuilder<int>(
                                                      tween: IntTween(
                                                          begin: 0,
                                                          end: state.coinPlus
                                                      ),
                                                      duration: const Duration(
                                                          milliseconds: 800),
                                                      builder: (context, value,
                                                          child) {
                                                        return Text(
                                                          "+$value",
                                                          style:
                                                          const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 30,
                                                            fontFamily: "Itim",
                                                            height: 0.8,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const FloatingImage(
                                                        pathImage: "assets/kujicoin.png",
                                                        width: 40,
                                                        height: 50
                                                    )
                                                  ],
                                                ),
                                                const Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    "kujicoin",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            )
                                        ],
                                      ),
                                      const SizedBox(height: 50),
                                      const Text(
                                        "Bài tiếp theo",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () async
                                        {
                                          if(!watchedAds){
                                            showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(20),
                                                  ),
                                                  title: const Text(
                                                      "🎉 X2 Kujicoin?"),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Center(
                                                        child: Image.asset("assets/character/hinh13.png", width: 200, height: 200),
                                                      ),
                                                      const Text(
                                                        "Bạn có muốn xem quảng cáo để x2 số Kujicoin nhận được không? 💰",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            height: 1.4),
                                                      ),
                                                      const SizedBox(height: 20),

                                                      /// 👇 ACTIONS – luôn nằm ngang
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          ElevatedButton.icon(
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.grey.shade300,
                                                                foregroundColor: Colors.black,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 20,
                                                                  vertical: 12,
                                                                )
                                                            ),
                                                            onPressed: () async {

                                                              await blocCubit.tryShowRewarded();

                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                            },
                                                            icon: const Icon(Icons.close),
                                                            label: const Text("Hủy"),
                                                          ),
                                                          const SizedBox(width: 12),
                                                          ElevatedButton.icon(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.amber.shade700,
                                                              foregroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 20,
                                                                vertical: 12,
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              bloc.add(ShowAdsRewardEvent(
                                                                  state.coinPlus,
                                                                  state.expRankPlus,
                                                                  state.expPlus
                                                              ));

                                                              loadingAds = true;
                                                            },
                                                            icon: const Icon(Icons.play_circle_fill),
                                                            label: const Text("Xem Quảng Cáo"),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                          else{
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Container(
                                          width:
                                          MediaQuery.sizeOf(context).width /
                                              1.1,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          child: const Center(
                                            child: Text(
                                              "Bắt Đầu Lượt Học Tiếp",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if(state is CongratulationLoading){
              return const AnimatedLoading();
            }


            return Container(
              color: Colors.white,
            );
          },
          listener: (context, state) async {
            if(state is CongratulationLoaded){
              if(state.effectRewards.isNotEmpty){
                _showEffectsSequentially(context, state.effectRewards);
              }
            }

            if(state is CongratulationLoadingAds){
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => const AnimatedLoadingAdsDialog(),
              );
            }
            else{
              if(loadingAds){
                Navigator.pop(context);
                Navigator.pop(context);
                loadingAds = false;
                watchedAds = true;
              }
            }
          }),
    );
  }
}
