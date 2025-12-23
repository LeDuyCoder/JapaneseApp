import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/combination/cubit/combination_test_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/combination/cubit/combination_test_state.dart';
import 'package:japaneseapp/features/learn/presentation/widget/chose_colume_widget.dart';

class CombinationTestView extends StatefulWidget implements BaseTestView{
  final Function(bool isCorrect) onComplete;
  final BuildContext contextPage;

  final List<WordEntity> listWords;

  CombinationTestView({super.key, required this.onComplete, required this.contextPage, required this.listWords});

  @override
  VoidCallback? get onTestComplete => onComplete(false);

  @override
  State<StatefulWidget> createState() {

    return _CombinationTestView();
  }

}

class _CombinationTestView extends State<CombinationTestView>{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CombinationTestCubit(widget.listWords, onComplete: (bool isCorrect) { widget.onComplete(isCorrect); },),
      child: BlocBuilder<CombinationTestCubit, CombinationTestState>(
        builder: (context, state){
          return Container(
              color: Colors.white,
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text(
                            "Hãy nối cột A và B với nhau",
                            style: TextStyle(
                                fontSize: MediaQuery.sizeOf(context).width * 0.05,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    for (int i = 0; i < 4; i++)
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ChoseColumeWidget(
                              text: state.columA[i].word,
                              isChoose: state.selectedA == state.columA[i],
                              isCancle: state.completes.contains(state.columA[i]),
                              functionButton: () async {
                                context
                                    .read<CombinationTestCubit>()
                                    .selectA(context, state.columA[i]);
                              },
                              isWrong: false,
                            ),

                            ChoseColumeWidget(
                              text: state.typeCombination == Combinations.jpToVi ? state.columB[i].mean : state.columB[i].wayread,
                              isChoose: state.selectedB == state.columB[i],
                              isCancle: state.completes.contains(state.columB[i]),
                              functionButton: () async {
                                context
                                    .read<CombinationTestCubit>()
                                    .selectB(context, state.columB[i]);
                              },
                              isWrong: false,
                            )
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 50,
                    ),
                    // GestureDetector(
                    //   onTapDown: (_) {
                    //     setState(() {
                    //       isPress = true;
                    //     });
                    //   },
                    //   onTapUp: (_) {
                    //     setState(() {
                    //       isPress = false;
                    //     });
                    //     if (listComplete.length == 4) {
                    //       if (listComplete.length >= 4) {
                    //         playSound("sound/correct.mp3");
                    //         showModalBottomSheet(
                    //             enableDrag: false,
                    //             isDismissible: false,
                    //             context: context,
                    //             builder: (ctx) => rightTab(
                    //               nextQuestion: () {
                    //                 widget.nextQuestion();
                    //               },
                    //               isMean: false,
                    //               context: context,
                    //             ));
                    //       }
                    //     }
                    //   },
                    //   onTapCancel: () {
                    //     setState(() {
                    //       isPress = false;
                    //     });
                    //   },
                    //   child: AnimatedContainer(
                    //     duration: Duration(milliseconds: 100),
                    //     curve: Curves.easeInOut,
                    //     transform: Matrix4.translationValues(0, isPress ? 4 : 0, 0),
                    //     width: MediaQuery.sizeOf(context).width - 40,
                    //     height: MediaQuery.sizeOf(context).width * 0.15,
                    //     decoration: BoxDecoration(
                    //         color: listComplete.length == 4
                    //             ? const Color.fromRGBO(97, 213, 88, 1.0)
                    //             : Color.fromRGBO(195, 195, 195, 1.0),
                    //         borderRadius: BorderRadius.all(Radius.circular(20)),
                    //         boxShadow: isPress
                    //             ? [] // Khi nhấn, không có boxShadow
                    //             : [
                    //           BoxShadow(
                    //               color: listComplete.length == 4
                    //                   ? Colors.green
                    //                   : const Color.fromRGBO(
                    //                   177, 177, 177, 1.0),
                    //               offset: Offset(6, 6))
                    //         ]),
                    //     child: Center(
                    //       child: Text(
                    //         "CHECK",
                    //         style: TextStyle(
                    //             color: listComplete.length == 4
                    //                 ? Colors.white
                    //                 : Colors.grey,
                    //             fontSize: MediaQuery.sizeOf(context).width * 0.045,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
          );

        }
      ),
    );
  }

}