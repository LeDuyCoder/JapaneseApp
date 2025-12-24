import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/manager_topic/bloc/folder_manager_bloc.dart';
import 'package:japaneseapp/features/manager_topic/bloc/folder_manager_event.dart';
import 'package:japaneseapp/features/manager_topic/bloc/folder_manager_state.dart';
import 'package:japaneseapp/features/manager_topic/data/repositories/folder_repository_impl.dart';
import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';
import 'package:japaneseapp/features/manager_topic/domain/repositories/folder_repository.dart';
import 'package:japaneseapp/features/manager_topic/domain/usecase/delete_folder.dart';
import 'package:japaneseapp/features/manager_topic/domain/usecase/get_topics_in_folder.dart';
import 'package:japaneseapp/features/manager_topic/domain/usecase/remove_topic_from_folder.dart';
import 'package:japaneseapp/features/manager_topic/presentation/pages/add_topic_page.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/bottom_menu_widget.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/no_topic_manager_widget.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/topic_manager_widget.dart';

class ManagerTopicPage extends StatefulWidget{
  final int idFolder;
  final String nameFolder;

  const ManagerTopicPage({super.key, required this.idFolder, required this.nameFolder});

  @override
  State<StatefulWidget> createState() => _ManagerTopicPageState();

}

class _ManagerTopicPageState extends State<ManagerTopicPage>{
  FolderRepository folderRepository = FolderRepositoryImpl(LocalDbService.instance);

  void _showBottomMenu(BuildContext context, void Function() onDeleteFolder) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // để bo góc đẹp
      builder: (context) {
        return BottomMenuWidget(idFolder: widget.idFolder, onDeleteFolder: onDeleteFolder,);
      },
  );
}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FolderManagerBloc(
        folderId: widget.idFolder,
        getTopics: GetTopicsInFolder(folderRepository),
        removeTopic: RemoveTopicFromFolder(folderRepository),
        deleteFolder: DeleteFolder(folderRepository),
      )..add(LoadTopics()),
      child: BlocConsumer<FolderManagerBloc, FolderManagerState>(
          builder: (context, state){
            if(state is FolderManagerLoaded){
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    actions: [
                      IconButton(
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => AddTopicPage(folderId: widget.idFolder)) );
                            context.read<FolderManagerBloc>().add(LoadTopics());
                      }, icon: const Icon(Icons.create_new_folder_outlined, color: Colors.black, size: 30,)),
                      IconButton(onPressed: (){
                        _showBottomMenu(context, (){
                          context.read<FolderManagerBloc>().deleteFolder(widget.idFolder);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      }, icon: Icon(Icons.more_vert))
                    ],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                  ),
                  body: Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          width: MediaQuery.sizeOf(context).width,
                          height: 170,
                          child: Column(
                            children: [
                              const SizedBox(height: 20,),
                              const Icon(Icons.folder_open, size: 70, color: Colors.grey,),

                              const SizedBox(height: 10,),
                              Text(widget.nameFolder, style: const TextStyle(fontSize: 30, color: Colors.grey, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.sizeOf(context).height,
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.sizeOf(context).width,
                              height: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10,),
                                    if(state.topics.isNotEmpty)
                                      for(TopicEntity topic in state.topics)...[
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: TopicManagerWidget(
                                            dataTopic: topic,
                                            removeTopic: () {
                                              context.read<FolderManagerBloc>().add(RemoveTopic(topic.id));
                                            },
                                          ),
                                        )
                                      ]
                                    else ...[
                                        NoTopicManagerWidget(folderId: widget.idFolder, reloadPage: (){
                                          context.read<FolderManagerBloc>().add(LoadTopics());
                                        },)
                                    ]
                                ],
                              ),
                            ),
                          ),
                        )
                        )
                      ]
                    ),
                  )
              );
            }

            return Container();
          },
          listener: (context, state){}
      )
    );
  }

}