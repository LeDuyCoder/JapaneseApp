import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Screen/allFolderScreen.dart';
import 'package:japaneseapp/core/Screen/seeMoreTopic.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/dashboard/bloc/dashboard_event.dart';
import 'package:japaneseapp/features/dashboard/bloc/dashboard_state.dart';
import 'package:japaneseapp/features/dashboard/data/datasource/user_remote_data_source.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/appbar_section.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/community_section.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/folder_section.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/loading_indicator.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/no_folder_section.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/topic_section.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/repository/dashboard_repository_impl.dart';
import '../../data/datasource/dashboard_local_data_source.dart';
import '../../data/datasource/dashboard_remote_data_source.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(
          repository: DashboardRepositoryImpl(
            local: DashboardLocalDataSource(),
            remote: DashboardRemoteDataSource(),
            userRemoteDataSource: UserRemoteDataSource(),
          )
      )..add(FetchDashboardData()),
      child: Scaffold(
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return LoadingIndicator();
            }//LoadingIndicator();
            if (state is DashboardLoaded) {
              return Container(
                color: AppColors.backgroundPrimary,
                child: WillPopScope(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<DashboardBloc>().add(FetchDashboardData());
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
                                      pageBuilder: (context, animation, secondaryAnimation) => allFolderScreen(),
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
                                      pageBuilder: (context, animation, secondaryAnimation) => seeMoreTopic(reloadScreen: (){}),
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
                              Text(AppLocalizations.of(context)!.dashboard_comunication, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontFamily: ""),),
                              SizedBox(width: 80,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => seeMoreTopic(reloadScreen: (){}),
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
                          SizedBox(height: 20,),
                          TopicSection(data: state.topicsLocal,),

                          // move appbar UI here
                          // HeaderTimer(), // move header UI here
                          // FolderSection(folders: state.folders),
                          // CommunitySection(topicServer: state.topicServer),
                          // TopicSection(topicsLocal: state.topicsLocal),
                        ],
                      ),
                    ),
                    onWillPop: (){
                      return Future.value(false);
                    }
                ),
              );
            }
            if (state is DashboardError) {
              return Container(); //EmptyState(message: state.message);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
