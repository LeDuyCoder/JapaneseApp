import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topic_privacy_bloc.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topic_privacy_event.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topic_privacy_state.dart';
import 'package:japaneseapp/features/topicdetail/data/datasources/topic_privacy_remote_datasource.dart';
import 'package:japaneseapp/features/topicdetail/data/repositories/topic_privacy_repository.dart';
import 'package:japaneseapp/features/topicdetail/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topicdetail_bloc.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topicdetail_event.dart';
import 'package:japaneseapp/features/topicdetail/bloc/topicdetail_state.dart';
import 'package:japaneseapp/features/topicdetail/data/datasources/topicdetail_local_datasource.dart';
import 'package:japaneseapp/features/topicdetail/data/repositories/Topicdetails_repository_impl.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/bottom_sheet_private.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/bottom_sheet_pulic.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/box_topicdetail_loading_widget.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/box_topicdetail_widget.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/flash_card_widget.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/menu_dialog_widget.dart';

class TopicDetailPage extends StatelessWidget{
  final String nameTopic;
  final String idTopic;
  final String owner;
  const TopicDetailPage({super.key, required this.nameTopic, required this.idTopic, required this.owner});

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
                    BlocProvider(
                      create: (_) => TopicPrivacyBloc(
                          TopicPrivacyRepositoryImpl(
                              remoteDataSource: TopicPrivacyRemoteDataSourceImpl()
                          ))..add(LoadTopicPrivacyEvent(idTopic)),
                      child: BlocConsumer<TopicPrivacyBloc, topicPrivacyState>(
                          builder: (context, state){
                            if(owner == FirebaseAuth.instance.currentUser!.displayName){
                              if(state is TopicPrivacyPublic) {
                                return IconButton(
                                    onPressed: (){
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent, // để custom full UI
                                        builder: (sheetContext) {
                                          return BottomSheetPrivate(
                                            onTap: () {
                                              context.read<TopicPrivacyBloc>().add(SetTopicPrivateEvent(idTopic, nameTopic));
                                              Navigator.pop(context);
                                            },
                                            onCancel: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.public_sharp, color: AppColors.primary,)
                                );
                              }
                              if(state is TopicPrivacyPrivate) {
                                return IconButton(
                                    onPressed: (){
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent, // để custom full UI
                                        builder: (sheetContext) {
                                          return BottomSheetPublic(
                                            context: context,
                                            onTap: () {
                                              context.read<TopicPrivacyBloc>().add(SetTopicPrivateEvent(idTopic, nameTopic));
                                              Navigator.pop(context);
                                            },
                                            onCancel: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.public_sharp, color: Colors.grey,)
                                );
                              }
                              if(state is TopicPrivacyLoading){
                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 24,
                                  height: 24,
                                  child: const CupertinoActivityIndicator(),
                                );
                              }
                            }
                            return Container();
                          },
                          listener: (context, state){}
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return MenuDialogWidget(topicName: nameTopic, amountWord: (state is TopicDetailLoaded) ? state.words.length : 0);
                          },
                        );
                      },
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
