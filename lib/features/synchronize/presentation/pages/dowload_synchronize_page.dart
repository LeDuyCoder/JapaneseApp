import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/achivement/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/synchronize/bloc/synchronize_bloc.dart';
import 'package:japaneseapp/features/synchronize/bloc/synchronize_event.dart';
import 'package:japaneseapp/features/synchronize/bloc/synchronize_state.dart';
import 'package:japaneseapp/features/synchronize/presentation/widgets/loading_character_widget.dart';
import 'package:japaneseapp/features/synchronize/presentation/widgets/no_internet_box.dart';
import 'package:japaneseapp/features/synchronize/presentation/widgets/sync_success_widget.dart';

class DownSynchronizePage extends StatefulWidget{
  const DownSynchronizePage({super.key});

  @override
  State<StatefulWidget> createState() => _DownSynchronizePage();
}

class _DownSynchronizePage extends State<DownSynchronizePage>{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SynchronizeBloc()..add(DownloadSynchronizeEvent()),
      child: BlocConsumer<SynchronizeBloc, SynchronizeState>(
        builder: (context, state){
          if(state is LoadingSynchronizeState){
            return const Scaffold(
              body: LoadingCharacterWidget(imagePath: "assets/character/hinh8.png",),
            );
          }

          if(state is SuccessSynchronizeState){
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: const SyncSuccessWidget(message: "Dữ liêu của bạn đã đồng bộ trên server",),
              ),
            );
          }

          if(state is ErrorSynchronizeState){
            return Scaffold(
              body: NoInternetBox(
                onRetry: (){
                  context.read<SynchronizeBloc>().add(PushSynchronizeEvent());
                },
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