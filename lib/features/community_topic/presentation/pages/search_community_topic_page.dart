import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/community_topic/bloc/community_topic_bloc.dart';
import 'package:japaneseapp/features/community_topic/bloc/community_topic_event.dart';
import 'package:japaneseapp/features/community_topic/bloc/community_topic_state.dart';
import 'package:japaneseapp/features/community_topic/data/datasources/community_remote_datasource.dart';
import 'package:japaneseapp/features/community_topic/data/repositories/community_topic_repository_imp.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/community_topic_widget.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/not_found_topic_widget.dart';

class SearchCommunityTopicPage extends StatelessWidget{
  final TextEditingController searchTopicInput = TextEditingController();
  int limit = 5;
  Timer? _debounce;

  void onChange(String value, void Function() call){
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityTopicBloc(
          CommunityTopicRepositoryImp(
              remoteDataSource: CommunityRemoteDataSource()
          )
      )..add(LoadTopics(limit: limit)),
      child: BlocConsumer<CommunityTopicBloc, CommunityTopicState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                scrolledUnderElevation: 0,
                title: const Text("Cộng Đồng", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),),
              ),
              body: Container(
                color: Colors.white,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0), // pill shape
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26, // shadow mờ hơn
                              offset: Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchTopicInput,
                          onChanged: (value) => onChange(value, (){
                            if(value.isNotEmpty){
                              context.read<CommunityTopicBloc>().add(searchTopics(nameTopic: value));
                            }
                          }),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.black, size: 30,),
                            hintText: "Nhập tên chủ đề ...",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      if(state is CommunityTopicNoFound)...[
                        NotFoundTopicWidget()
                      ],

                      if(state is CommunityTopicLoaded)...[
                        const Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text("Bộ Sư Tập Cộng Đồng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.topics.length,
                          itemBuilder: (context, index) {

                            final topic = state.topics[index];
                            return  CommunityTopicWidget(communityTopicEntity: topic, showBottomShetDownload: (id){}, reloadState: () {
                              context.read<CommunityTopicBloc>().add(LoadTopics(limit: limit));
                            },);
                          },
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  limit+=5;
                                  context.read<CommunityTopicBloc>().add(LoadTopics(limit: limit));
                                },
                                child: const Text(
                                  "Tải Thêm",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_drop_down_outlined)
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                      ],
                      
                      if(state is CommunityTopicLoading)...[
                        Container(
                          width: MediaQuery.sizeOf(context).width,
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
                        )
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
          listener: (context, state){}
      ),
    );
  }

}