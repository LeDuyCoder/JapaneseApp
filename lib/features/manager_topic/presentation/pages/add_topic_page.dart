import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/manager_topic/bloc/add_topic_bloc.dart';
import 'package:japaneseapp/features/manager_topic/bloc/add_topic_event.dart';
import 'package:japaneseapp/features/manager_topic/bloc/add_topic_state.dart';
import 'package:japaneseapp/features/manager_topic/data/repositories/folder_repository_impl.dart';
import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/no_topic_widget.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/topic_infolder_widget.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/topic_widget.dart';

class AddTopicPage extends StatefulWidget{
  final int folderId;

  const AddTopicPage({super.key, required this.folderId});

  @override
  State<StatefulWidget> createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage>{
  final db = LocalDbService.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => AddTopicBloc(
            repository: FolderRepositoryImpl(LocalDbService.instance)

        )..add(LoadAllTopics(widget.folderId)),
        child: BlocConsumer<AddTopicBloc, AddTopicState>(
            builder: (context, state){

              if(state is LoadAllTopicsSuccess){
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: const Text("Thêm Chủ Đề Học Phần", style: TextStyle(color: Colors.black),),
                    leading: IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.close, size: 40,)),
                  ),
                  body: Container(
                    color: Colors.white,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 20,
                            runSpacing: 15,
                            children: [
                              if(state.topicsInFolder.isNotEmpty)...[
                                for(TopicEntity topic in state.topicsInFolder)
                                  TopicInfolderWidget(topic: topic, onTap: (){
                                    context.read<AddTopicBloc>().add(RemoveTopic(topic.id, widget.folderId));
                                  },)
                              ]else...[
                                const NoTopicWidget()
                              ]

                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'Danh Sách Chủ Đề',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Wrap(
                            spacing: 20,
                            runSpacing: 15,
                            children: [
                              for(TopicEntity topic in state.topicsOutFolder)
                                TopicWidget(topicEntity: topic, onTap: (){
                                  context.read<AddTopicBloc>().add(AddTopic(topic.id, widget.folderId));
                                },)
                            ],
                          )
                        ],
                      ),
                    )
                  ),
                );
              }

              return Container(
                color: Colors.white,
              );

            },
            listener: (context, state){}
        )
    );
  }
}