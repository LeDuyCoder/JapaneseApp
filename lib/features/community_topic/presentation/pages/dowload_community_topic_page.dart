import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/community_topic/bloc/dowload_topic_bloc.dart';
import 'package:japaneseapp/features/community_topic/bloc/dowload_topic_event.dart';
import 'package:japaneseapp/features/community_topic/bloc/dowload_topic_state.dart';
import 'package:japaneseapp/features/community_topic/data/datasources/dowload_topic_remote_datasource.dart';
import 'package:japaneseapp/features/community_topic/data/repositories/dowload_topic_repository_imp.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/dowload_success_widget.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/download_widget.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/word_topic_widget.dart';

class DowloadCommunityTopicPage extends StatelessWidget{
  final String topicId;

  const DowloadCommunityTopicPage({super.key, required this.topicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DowloadTopicBloc(
          DowloadTopicRepositoryImpl(
            dataSource: DowloadTopicRemoteDataSource()
          )
      )..add(DowloadTopicLoad(topicId: topicId)),
      child: BlocConsumer<DowloadTopicBloc, DowloadTopicState>(
          builder: (context, state){
            if(state is DowloadTopicWaiting){
              return Scaffold(
                body: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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

            if(state is DowloadTopicLoadState){
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Tải chủ đề", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),),
                  scrolledUnderElevation: 0,
                  backgroundColor: Colors.white,
                ),
                body: Container(
                  color: Colors.white,
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(state.dowloadTopicEntity.communityTopicEntity.nameTopic, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),),
                      Text("Tác giả: ${state.dowloadTopicEntity.communityTopicEntity.userName} - Số Lượng: ${state.dowloadTopicEntity.communityTopicEntity.wordCount}", style: const TextStyle(fontSize: 15, color: Colors.grey),),
                      const SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        constraints: const BoxConstraints(
                          maxHeight: 550
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for(WordEntity word in state.dowloadTopicEntity.wordEntities)...[
                                WordTopicWidget(wordEntity: word)
                              ]
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          context.read<DowloadTopicBloc>().add(DowloadTopic(dowloadTopicEntity: state.dowloadTopicEntity));
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935), // đỏ hiện đại
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Tải topic",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            if(state is DowloadingTopic){
              return const Scaffold(
                body: DownloadWidget()
              );
            }

            if(state is DowloadTopicSucces){
              return Scaffold(
                  body: DowloadSucessWidget()
              );
            }

            return Container(
              color: CupertinoColors.white,
            );
          },
          listener: (context, state){
            if(state is DowloadTopicLoadState){
              if(state.effectReward != null){
                state.effectReward!.showEffectReward(context);
              }
            }
          }
      ),
    );
  }
}