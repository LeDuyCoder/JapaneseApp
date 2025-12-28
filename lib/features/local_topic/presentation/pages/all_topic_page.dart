import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/local_topic/bloc/all_topic_bloc.dart';
import 'package:japaneseapp/features/local_topic/bloc/all_topic_event.dart';
import 'package:japaneseapp/features/local_topic/bloc/all_topic_state.dart';
import 'package:japaneseapp/features/local_topic/data/datasources/topic_datasource.dart';
import 'package:japaneseapp/features/local_topic/data/repositories/topic_repository_impl.dart';
import 'package:japaneseapp/features/local_topic/presentation/cubit/all_topic_cubit.dart';
import 'package:japaneseapp/features/local_topic/presentation/cubit/all_topic_cubit_state.dart';
import 'package:japaneseapp/features/local_topic/presentation/widgets/page_button.dart';
import 'package:japaneseapp/features/local_topic/presentation/widgets/pagination_widget.dart';
import 'package:japaneseapp/features/local_topic/presentation/widgets/topic_info_box_widget.dart';
import 'package:japaneseapp/features/topicdetail/presentation/pages/topicdetail_page.dart';

class AllTopicPage extends StatelessWidget{
  LocalDbService db = LocalDbService.instance;

  AllTopicPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllTopicBloc(
          repository: TopicRepositoryImpl(
              resource: TopicDatasource(
                  db: db
              )
          )
      )..add(LoadAllTopicByPageEvent(pageSize: 5)),
      child: BlocConsumer<AllTopicBloc, AllTopicState>(
          builder: (context, state){
            return Scaffold(
              appBar: AppBar(
                title: const Text("Danh Sách Học Phần", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),),
                backgroundColor: Colors.white,
                scrolledUnderElevation: 0,
              ),
              body: Container(
                color: Colors.white,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: BlocProvider(
                  create: (_) => AllTopicCubit(),
                  child: BlocBuilder<AllTopicCubit, AllTopicCubitState>(
                    builder: (context, statePage){
                      if(state is LoadedByPageAllTopicState){
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if(statePage.page > 1)
                                    GestureDetector(
                                      onTap: (){
                                        if(statePage.page > 1){
                                          context.read<AllTopicCubit>().updatePage(statePage.page - 1);
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          "<",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  PaginationWidget(currentPage: statePage.page, totalPage: state.pages.length, onPageChanged: (page){
                                    context.read<AllTopicCubit>().updatePage(page);
                                  }),
                                  if(statePage.page != state.pages.length)
                                    GestureDetector(
                                      onTap: (){
                                        if(statePage.page < state.pages.length){
                                          context.read<AllTopicCubit>().updatePage(statePage.page + 1);
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          ">",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              for(var topic in state.pages[statePage.page - 1].topicEntities)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Column(
                                    children: [
                                      TopicInfoBoxWidget(topicEntity: topic, onTap: () async {
                                        await Navigator.push(context, MaterialPageRoute(builder: (context) => TopicDetailPage(nameTopic: topic.topicName, idTopic: topic.topicId, owner: topic.owner)));
                                        context.read<AllTopicBloc>().add(LoadAllTopicByPageEvent(pageSize: 5));
                                        context.read<AllTopicCubit>().updatePage(1);
                                      })
                                    ],
                                  ),
                                )
                            ],
                          ),
                        );
                      }

                      if(state is LoadingAllTopicState){
                        return Container(
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

                      return Container();
                    },
                  ),
                )),
            );
          },
          listener: (context, state){}
      ),
    );
  }

  


}