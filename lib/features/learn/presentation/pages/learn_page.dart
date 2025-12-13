import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/learn/bloc/learn_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/learn_event.dart';
import 'package:japaneseapp/features/learn/bloc/learn_state.dart';
import 'package:japaneseapp/features/learn/data/datasources/learn_local_datasource.dart';
import 'package:japaneseapp/features/learn/data/repositories/learn_repository_impl.dart';
import 'package:japaneseapp/features/learn/domain/usecase/generate_test_usecase.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/progress_state.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/combination/view/combination_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/widget/notification_popup_widget.dart';

class LearnPage extends StatelessWidget{
  final String nameTopic;
  static const int amountQuestion = 5;

  const LearnPage({super.key, required this.nameTopic});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => LearnBloc(
          LearnRepositoryImpl(
            dataSource: LearnLocalDataSourceImpl(),
          ),
        )..add(StartLearningEvent(nameTopic)),
        child: BlocConsumer<LearnBloc, LearnState>(
            builder: (context, state){
              return Scaffold(
                body: BlocProvider(
                  create: (_) => ProgressCubit(),
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
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
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
                                    CombinationTestView(contextPage: context, listWords: state.listEntites, onComplete: (){
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent, // để custom full UI
                                        builder: (sheetContext) {
                                          return NotificationPopupWidget(
                                            title: 'Chúc Mừng',
                                            message: 'Bạn vừa hoàn thành xuất sắc bài nối từ',
                                            onPressButton: () {
                                              context
                                                  .read<ProgressCubit>()
                                                  .increase();
                                            },
                                            imagePath: 'assets/character/hinh10.png',

                                          );
                                        },
                                      );
                                    },),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.ListenTestView)
                                    Center(child: Text("ListenTestView"),),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.ReadTestView)
                                    Center(child: Text("ReadTestView"),),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.SortTestView)
                                    Center(child: Text("SortTestView"),),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.SpeakTestView)
                                    Center(child: Text("SpeakTestView"),),
                                  if(state.testEntities[stateProgress.amount].testView == TestView.WriteTestView)
                                    Center(child: Text("WriteTestView"),),
                                ],

                                // if(state is LearnGenerated)...[
                                //   CombinationTestView(contextPage: context, listWords: state.listEntites, onComplete: (){
                                //     showModalBottomSheet(
                                //       context: context,
                                //       isScrollControlled: true,
                                //       backgroundColor: Colors.transparent, // để custom full UI
                                //       builder: (sheetContext) {
                                //         return NotificationPopupWidget(
                                //           title: 'Chúc Mừng',
                                //           message: 'Bạn vừa hoàn thành xuất sắc bài nối từ',
                                //           onPressButton: () {
                                //             context
                                //                 .read<ProgressCubit>()
                                //                 .increase();
                                //           },
                                //           imagePath: 'assets/character/hinh10.png',
                                //
                                //         );
                                //       },
                                //     );
                                //   },),
                                // ]
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