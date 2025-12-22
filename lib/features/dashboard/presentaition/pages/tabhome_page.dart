import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Screen/allFolderScreen.dart';
import 'package:japaneseapp/core/Screen/allTopicScreen.dart';
import 'package:japaneseapp/core/Screen/seeMoreTopic.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/dashboard/bloc/tabhome_bloc.dart';
import 'package:japaneseapp/features/dashboard/bloc/tabhome_event.dart';
import 'package:japaneseapp/features/dashboard/bloc/tabhome_state.dart';
import 'package:japaneseapp/features/dashboard/data/datasource/tabhome_local_data_source.dart';
import 'package:japaneseapp/features/dashboard/data/datasource/tabhome_remote_data_source.dart';
import 'package:japaneseapp/features/dashboard/data/datasource/user_remote_data_source.dart';
import 'package:japaneseapp/features/dashboard/data/repository/tabhome_repository_impl.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/appbar_section.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/community_section.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/folder_section.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/loading_indicator.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/no_folder_section.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/topic_section.dart';

class TabHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TabHomeBloc(
          repository: TabHomeRepositoryImpl(
            local: TabHomeLocalDataSource(),
            remote: TabHomeRemoteDataSource(),
            userRemoteDataSource: UserRemoteDataSource(),
          )
      )..add(FetchTabHomeData()),
      child: Scaffold(
        body: BlocBuilder<TabHomeBloc, TabHomeState>(
          builder: (context, state) {
            if (state is TabHomeLoading) {
              return LoadingIndicator();
            }//LoadingIndicator();
            if (state is TabHomeLoaded) {
              return Container(
                color: AppColors.backgroundPrimary,
                child: WillPopScope(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<TabHomeBloc>().add(FetchTabHomeData());
                      },
                      child: ListView(
                        children: [
                          AppSection(user: state.userModel,),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(AppLocalizations.of(context)!.dashboard_folder, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontFamily: ""),),
                              const SizedBox(width: 80,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => Container(),//allFolderScreen(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Text(AppLocalizations.of(context)!.dashboard_folder_seemore, style: TextStyle(color: AppColors.primary, fontSize: 18, fontFamily: ""),),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          if(state.folders.isNotEmpty)
                            FolderSection(folders: state.folders,)
                          else
                            NoFolderSection(),

                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(AppLocalizations.of(context)!.dashboard_comunication, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontFamily: ""),),
                              SizedBox(width: 80,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => Container(),//seeMoreTopic(reloadScreen: (){}),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Text(AppLocalizations.of(context)!.dashboard_comunication_seemore, style: TextStyle(fontFamily: "", color: AppColors.primary, fontSize: 18),),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          CommunitySection(data: state.topicServer,),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(AppLocalizations.of(context)!.dashboard_topic, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontFamily: ""),),
                              const SizedBox(width: 80,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => allTopicScreen(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0), // tạo vùng click thoải mái hơn
                                  child: Text(
                                    AppLocalizations.of(context)!.dashboard_topic_seemore,
                                    style: TextStyle(color: AppColors.primary, fontSize: 18, fontFamily: ""),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          TopicSection(data: state.topicsLocal, contextDashboard: context,),
                        ],
                      ),
                    ),
                    onWillPop: (){
                      return Future.value(false);
                    }
                ),
              );
            }
            if (state is TabHomeError) {
              return Container(
                child: Text(state.message),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
