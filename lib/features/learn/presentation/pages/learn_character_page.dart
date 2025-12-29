import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/character/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/learn/bloc/elapsed_time_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/elapsed_time_event.dart';
import 'package:japaneseapp/features/learn/bloc/learn_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/learn_event.dart';
import 'package:japaneseapp/features/learn/bloc/learn_state.dart';
import 'package:japaneseapp/features/learn/data/datasources/learn_local_datasource.dart';
import 'package:japaneseapp/features/learn/data/repositories/learn_repository_impl.dart';
import 'package:japaneseapp/features/learn/domain/enum/type_test.dart';
import 'package:japaneseapp/features/learn/domain/usecase/generate_test_usecase.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_state.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/chose/view/chose_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/combination/view/combination_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/listen/view/listen_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/sort/view/sort_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/speak/view/speak_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/write/view/write_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/widget/notification_popup_widget.dart';
import 'package:japaneseapp/features/learn/presentation/widget/quit_tab.dart';

class LearnCharacterPage extends StatelessWidget{
  final TypeTest type;
  final int setLevel;
  final int maxQuestion = 5;

  const LearnCharacterPage({super.key, required this.type, required this.setLevel});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LearnBloc(
              LearnRepositoryImpl(
                  LearnLocalDataSourceImpl()
              )
            )..add(StartLearningCharacterEvent(type: type, setLevel: setLevel)),
          ),
          BlocProvider(
            create: (_) => ElapsedTimeBloc()
              ..add(StartTimer()),
          ),
        ],
        child: BlocConsumer<LearnBloc, LearnState>(
            builder: (context, state){

              if(state is LearnGeneratation){
                return Scaffold(
                  body: Container(
                    color: Colors.white,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingImage(
                            pathImage: "assets/character/hinh12.png",
                            width: 250,
                            height: 250
                        ),
                        Text("Loading...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                      ],
                    ),
                  ),
                );
              }

              if(state is LearnGenerated) {
                return Scaffold(
                  body: BlocProvider(
                    create: (context) => ProgressCubit(maxQuestion),
                    child: BlocBuilder<ProgressCubit, ProgressState>(
                      builder: (context, stateProgress){
                        if(stateProgress is ProgressInitial){
                          return Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height,
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Container(
                                    color: Colors.white,
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 70,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context, builder: (ctx) => const QuitTab());
                                          },
                                          icon: const Icon(Icons.close, size: 50),
                                        ),
                                        Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.only(right: 20),
                                                child: LinearProgressIndicator(
                                                  value: stateProgress.amount / maxQuestion,
                                                  backgroundColor: Colors.grey[300],
                                                  color: AppColors.primary,
                                                  minHeight: 15,
                                                  borderRadius: BorderRadius.circular(20),
                                                )
                                            )),
                                      ],
                                    ),
                                  ),

                                  if(state.testEntities[stateProgress.amount].testView == TestView.CombinationTestView)
                                    CombinationTestView(contextPage: context, listWords: state.listEntites, onComplete: (isCorrect){
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent, // để custom full UI
                                        builder: (sheetContext) {
                                          return NotificationPopupWidget(
                                            title: 'Chúc Mừng',
                                            message: 'Bạn vừa hoàn thành xuất sắc bài nối từ',
                                            onPressButton: (isCorrect) {
                                              context
                                                  .read<ProgressCubit>()
                                                  .increase(context, isCorrect, state.listEntites, context.read<ElapsedTimeBloc>().state.elapsed);
                                            },
                                            imagePath: 'assets/character/hinh10.png',
                                            isCorrect: isCorrect,

                                          );
                                        },
                                      );
                                    },),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.ChoseTestView)
                                    ChoseTestView(contextPage: context, listWords: state.listEntites, word: state.testEntities[stateProgress.amount].wordEntity, onComplete: (isCorrect) {
                                      context
                                          .read<ProgressCubit>()
                                          .increase(context, isCorrect, state.listEntites, context.read<ElapsedTimeBloc>().state.elapsed);
                                    },),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.WriteTestView)
                                    WriteTestView(contextPage: context, wordEntity: state.testEntities[stateProgress.amount].wordEntity, onComplete: (isCorrect) {
                                      context
                                          .read<ProgressCubit>()
                                          .increase(context, isCorrect, state.listEntites, context.read<ElapsedTimeBloc>().state.elapsed);
                                    }, isCharracter: true,),
                                ],
                              )
                          );
                        }

                        return Container();
                      },
                    ),
                  ),
                );
              }
              return Container(
              );
            },
            listener: (context, state){}
        )
    );
  }

}