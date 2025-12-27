import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/learn/bloc/elapsed_time_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/elapsed_time_event.dart';
import 'package:japaneseapp/features/learn/bloc/learn_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/learn_event.dart';
import 'package:japaneseapp/features/learn/bloc/learn_state.dart';
import 'package:japaneseapp/features/learn/data/datasources/learn_local_datasource.dart';
import 'package:japaneseapp/features/learn/data/repositories/learn_repository_impl.dart';
import 'package:japaneseapp/features/learn/domain/usecase/generate_test_usecase.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_state.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/chose/view/chose_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/combination/view/combination_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/listen/view/listen_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/sort/cubit/sort_test_state.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/sort/view/sort_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/speak/view/speak_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/write/view/write_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/widget/notification_popup_widget.dart';
import 'package:japaneseapp/features/learn/presentation/widget/quit_tab.dart';

class LearnPage extends StatelessWidget{
  final String idTopic;
  static const int amountQuestion = 5;

  const LearnPage({super.key, required this.idTopic});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LearnBloc(
              LearnRepositoryImpl(
                dataSource: LearnLocalDataSourceImpl(),
              ),
            )..add(StartLearningEvent(idTopic)),
          ),

          BlocProvider(
            create: (_) => ElapsedTimeBloc()
              ..add(StartTimer()),
          ),
        ],
        child: BlocConsumer<LearnBloc, LearnState>(
            builder: (context, state){
              final elapsed = context.read<ElapsedTimeBloc>().state.elapsed;

              return Scaffold(
                body: BlocProvider(
                  create: (_) => ProgressCubit(amountQuestion),
                  child: BlocBuilder<ProgressCubit, ProgressState>(
                    builder: (context, stateProgress) {

                      if(stateProgress is ProgressInitial){
                        return Container(
                          color: Colors.white,
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Container(
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
                                                value: stateProgress.amount / amountQuestion,
                                                backgroundColor: Colors.grey[300],
                                                color: AppColors.primary,
                                                minHeight: 15,
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                          )),
                                    ],
                                  ),
                                ),
                                if(state is LearnGenerated)...[
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
                                  if(state.testEntities[stateProgress.amount].testView == TestView.ListenTestView)
                                    ListenTestView(
                                        onComplete: (isCorrect){
                                          context
                                              .read<ProgressCubit>()
                                              .increase(context, isCorrect, state.listEntites, context.read<ElapsedTimeBloc>().state.elapsed);
                                        },
                                        contextPage: context,
                                        wordEntity: state.testEntities[stateProgress.amount].wordEntity,
                                        wordEntities: state.listEntites
                                    ),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.ChoseTestView)
                                    ChoseTestView(contextPage: context, listWords: state.listEntites, word: state.testEntities[stateProgress.amount].wordEntity, onComplete: (isCorrect) {
                                      context
                                          .read<ProgressCubit>()
                                          .increase(context, isCorrect, state.listEntites, context.read<ElapsedTimeBloc>().state.elapsed);
                                    },),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.SortTestView)
                                    SortTestView(onComplete: (isCorrect){
                                      context
                                          .read<ProgressCubit>()
                                          .increase(context, isCorrect, state.listEntites, context.read<ElapsedTimeBloc>().state.elapsed);
                                    }, contextPage: context, wordEntity: state.testEntities[stateProgress.amount].wordEntity, wordEntities: state.listEntites, typeTest: Sorts.values[Random().nextInt(Sorts.values.length)]),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.SpeakTestView)
                                    SpeakTestView(contextPage: context, wordEntity: state.testEntities[stateProgress.amount].wordEntity, onComplete: (isCorrect){
                                      context
                                          .read<ProgressCubit>()
                                          .increase(context, isCorrect, state.listEntites, context.read<ElapsedTimeBloc>().state.elapsed);
                                    },),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.WriteTestView)
                                    WriteTestView(contextPage: context, wordEntity: state.testEntities[stateProgress.amount].wordEntity, onComplete: (isCorrect) {
                                      context
                                          .read<ProgressCubit>()
                                          .increase(context, isCorrect, state.listEntites, context.read<ElapsedTimeBloc>().state.elapsed);
                                    },),
                                ],
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              );
            },
            listener: (context, state){}
        ),
    );
  }
}