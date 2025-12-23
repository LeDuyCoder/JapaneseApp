import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/listen/cubit/listen_test_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/listen/cubit/listen_test_state.dart';
import 'package:japaneseapp/features/learn/presentation/widget/box_text_widget.dart';
import 'package:japaneseapp/features/learn/presentation/widget/check_button.dart';

class ListenTestView extends StatefulWidget implements BaseTestView{

  final Function(bool isCorrect) onComplete;
  final BuildContext contextPage;

  final WordEntity wordEntity;
  final List<WordEntity> wordEntities;

  const ListenTestView({super.key, required this.onComplete, required this.contextPage, required this.wordEntity, required this.wordEntities});

  @override
  VoidCallback? get onTestComplete => onComplete(false);

  @override
  State<StatefulWidget> createState() => _ListenTestView();
}

class _ListenTestView extends State<ListenTestView>{
  bool readFirst = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListenTestCubit(widget.wordEntity, widget.wordEntities, widget.onComplete),
      child: BlocBuilder<ListenTestCubit, ListenTestState>(
          builder: (context, state){
            if(readFirst){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ListenTestCubit>().speak(
                  context.read<ListenTestCubit>().state.currentWord,
                );

                readFirst = false;
              });
            }

            return Container(
              width: MediaQuery.sizeOf(context).width,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Text(AppLocalizations.of(context)!.learn_listen_title, style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.025, fontWeight: FontWeight.bold, fontFamily: "Itim"),),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width*0.5,
                                child: Image.asset("assets/character/hinh2.png", width: MediaQuery.sizeOf(context).height*0.2),
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width*0.5,
                                child: Center(
                                  child: GestureDetector(
                                    onTapUp: (_) async {
                                      await context.read<ListenTestCubit>().speak(state.currentWord);
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.easeInOut,
                                      transform: Matrix4.translationValues(0, 0, 0),
                                      height: MediaQuery.sizeOf(context).width*0.3,
                                      width: MediaQuery.sizeOf(context).width*0.3,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Icon(Icons.volume_up_rounded, color: Colors.white, size:50,),
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ),
                          DragTarget<BoxTextWidget>(
                            onWillAccept: (data) => data != null,
                            onAccept: (data) {
                              context
                                  .read<ListenTestCubit>()
                                  .selectCharacter(data.text, data.index);
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height*0.15,
                                color: Colors.white,
                                child: Center(
                                  child: Stack(
                                    children: [
                                      if (candidateData.isNotEmpty)
                                        Container(
                                          color: const Color.fromRGBO(0, 0, 0, 0.05),
                                        ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Divider(color: Colors.grey),
                                          SizedBox(
                                            height: state.userAnswer.isEmpty ? 60 : 10,
                                          ),
                                          Wrap(
                                            spacing: 10,
                                            runSpacing: 10,
                                            children: state.userAnswer
                                                .asMap()
                                                .entries
                                                .map(
                                                  (entry) => GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<ListenTestCubit>()
                                                      .removeCharacter(entry.value, entry.key);
                                                },
                                                child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10),
                                                    child: BoxTextWidget(text: entry.value, index: entry.key).buildWidget()
                                                ),
                                              ),
                                            )
                                                .toList(),
                                          ),
                                          const SizedBox(height: 20),
                                          const Divider(color: Colors.grey),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          if(state.listCharacter.isNotEmpty) ...[
                            SizedBox(height: MediaQuery.sizeOf(context).height*0.01),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: Wrap(
                                  spacing: 20,
                                  runSpacing: 10,
                                  children: (state.listCharacter.isNotEmpty)
                                      ? state.listCharacter
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final int index = entry.key;
                                    final String item = entry.value;

                                    return GestureDetector(
                                      onTap: () {
                                        context
                                            .read<ListenTestCubit>()
                                            .selectCharacter(item, index);
                                      },
                                      child: Draggable<BoxTextWidget>(
                                        key: ValueKey('$item-$index'), // tránh trùng key
                                        data: BoxTextWidget(text: item, index: index),
                                        feedback: Center(
                                          child: Material(
                                            type: MaterialType.transparency,
                                            child: BoxTextWidget(text: item, index: index).buildWidget(),
                                          ),
                                        ),
                                        childWhenDragging:
                                        BoxTextWidget(text: item, index: index).buildWidget(),
                                        child: BoxTextWidget(text: item, index: index).buildWidget(),
                                      ),
                                    );
                                  })
                                      .toList()
                                      : [Container()],
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 50,),
                          CheckButton(
                              enabled: state.userAnswer.isNotEmpty,
                              onTap: (){
                                context.read<ListenTestCubit>().checkAnswer(context, widget.onComplete);
                              }
                          )
                          // Container(
                          //   width: MediaQuery.sizeOf(context).width,
                          //   child: Center(
                          //     child: GestureDetector(
                          //         onTapUp: (_) async {
                          //         },
                          //         child: Container(
                          //           width: MediaQuery.sizeOf(context).width - 20,
                          //           height: MediaQuery.sizeOf(context).width*0.15,
                          //           decoration: state.userAnswer.isEmpty
                          //               ? const BoxDecoration(
                          //             color: Color.fromRGBO(223, 223, 223, 1.0),
                          //             borderRadius: BorderRadius.all(Radius.circular(20)),
                          //           )
                          //               : const BoxDecoration(
                          //             color: Color.fromRGBO(49, 230, 62, 1.0),
                          //             borderRadius: BorderRadius.all(Radius.circular(20)),
                          //             boxShadow: [
                          //               BoxShadow(
                          //                 color: Colors.green,
                          //                 offset: Offset(6, 6),
                          //               ),
                          //             ],
                          //           ),
                          //           child: Center(
                          //             child: Text(
                          //               AppLocalizations.of(context)!.learn_btn_check,
                          //               style: TextStyle(
                          //                 fontSize: 20,
                          //                 color: state.userAnswer.isEmpty
                          //                     ? const Color.fromRGBO(166, 166, 166, 1.0)
                          //                     : Colors.white,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ),
                          //         )
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

}