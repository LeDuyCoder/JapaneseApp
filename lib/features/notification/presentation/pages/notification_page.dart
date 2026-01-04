import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/achivement/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/notification/bloc/notification_bloc.dart';
import 'package:japaneseapp/features/notification/bloc/notification_event.dart';
import 'package:japaneseapp/features/notification/bloc/notification_state.dart';
import 'package:japaneseapp/features/notification/data/datasource/notification_local_datasource.dart';
import 'package:japaneseapp/features/notification/data/datasource/notification_remote_datasource.dart';
import 'package:japaneseapp/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:japaneseapp/features/notification/domain/entities/notification_entity.dart';
import 'package:japaneseapp/features/notification/presentation/widgets/notification_view.dart';

class NotificationPage extends StatelessWidget{
  final String userId;

  const NotificationPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NotificationBloc(
          repository: NotificationRepositoryImpl(
              localDatasource: NotificationLocalDatasource(),
              remoteDatasource: NotificationRemoteDatasource()
          )
        )..add(LoadNotificationEvent(userId: userId)),
      child: BlocConsumer<NotificationBloc, NotificationState>(
          builder: (context, state){
            if(state is LoadedNotificationState){
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  scrolledUnderElevation: 0,
                  title: Text("Hồm Thư", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 25),),
                ),
                body: Container(
                  color: Colors.white,
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        for(NotificationEntity notification in state.listNotification)...[
                          NotificationView(notificationEntity: notification, onMark: () {
                            context.read<NotificationBloc>().add(MarkNotificationEvent(
                                notificationEntity: notification,
                                notifications: state.listNotification
                            ));
                          },)
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }

            if(state is LoadingNotificationState){
              return Scaffold(
                body: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  color: Colors.white,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingImage(
                          pathImage: "assets/character/hinh12.png",
                          width: 250,
                          height: 250
                      ),
                      Text("Loading...", style: TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              );
            }

            return Container();
          },
          listener: (context, state){}
      ),
    );
  }

}