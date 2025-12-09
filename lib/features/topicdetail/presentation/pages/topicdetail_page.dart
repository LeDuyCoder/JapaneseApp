import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/topicdetail/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topicdetail_bloc.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topicdetail_event.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topicdetail_state.dart';
import 'package:japaneseapp/features/topicdetail/data/datasources/topicdetail_local_datasource.dart';
import 'package:japaneseapp/features/topicdetail/data/repositories/Topicdetails_repository_impl.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/box_topicdetail_loading_widget.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/box_topicdetail_widget.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/flash_card_widget.dart';

class TopicDetailPage extends StatelessWidget{
  final String nameTopic;
  const TopicDetailPage({super.key, required this.nameTopic});

  void showFlashCardDialog(BuildContext context, WordEntity wordEntity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: FlashCardWidget(wordEntity: wordEntity,),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TopicdetailBloc(
          TopicdetailsRepositoryImpl(
            dataSource: TopicdetailsLocalDatasourceImpl(),
          ),
        )..add(LoadTopicDetailEvent(nameTopic)),
        child: BlocConsumer<TopicdetailBloc, TopicDetailState>(
            builder: (context, state){
              return Scaffold(
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  backgroundColor: AppColors.white,
                  title: Container(
                    child: Text(
                      AppLocalizations.of(context)!.listword_Screen_title,
                      style: TextStyle(fontFamily: "Itim", fontSize: 35, color: AppColors.primary),
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    // FutureBuilder(future: isExistTopic(), builder: (context, topic){
                    //   if(topic.connectionState == ConnectionState.waiting){
                    //     return Container();
                    //   }
                    //
                    //
                    //   if(owner == FirebaseAuth.instance.currentUser!.displayName){
                    //     if(topic.hasData){;
                    //     return IconButton(onPressed: (){
                    //       showBottomSheetPrivate(context);
                    //     }, icon: Icon(Icons.public_sharp, color: AppColors.primary,));
                    //     }
                    //
                    //     return IconButton(onPressed: (){
                    //       showBottomSheetPulic(context);
                    //     }, icon: Icon(Icons.public_sharp, color: Colors.grey,));
                    //   }else{
                    //     return Container();
                    //   }
                    // }),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.menu, color: Colors.black),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
                body: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  color: AppColors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        if(state is TopicDetailLoading)
                          const Center(
                            child: BoxTopicDetailLoadingWidget(),
                          ),
                        if(state is TopicDetailLoaded)
                          BoxTopicDetailWidget(words: state.words, topicName: nameTopic,),
                      ],
                    ),
                  ),
                ),
              );
            },
            listener: (context, state){}
        )
    );
  }
}
