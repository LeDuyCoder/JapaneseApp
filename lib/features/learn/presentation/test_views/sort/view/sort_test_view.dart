import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/chose/cubit/chose_test_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/listen/cubit/listen_test_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/sort/cubit/sort_test_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/sort/cubit/sort_test_state.dart';
import 'package:japaneseapp/features/learn/presentation/widget/box_text_widget.dart';
import 'package:japaneseapp/features/learn/presentation/widget/check_button.dart';

class SortTestView extends StatelessWidget implements BaseTestView {
  final Function(bool isCorrect) onComplete;
  final BuildContext contextPage;

  final WordEntity wordEntity;
  final List<WordEntity> wordEntities;
  final Sorts typeTest;

  const SortTestView({super.key, required this.onComplete, required this.contextPage, required this.wordEntity, required this.wordEntities, required this.typeTest});

  @override
  VoidCallback get onTestComplete => onComplete(false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SortTestCubit(wordEntity, wordEntities, typeTest),
      child: BlocBuilder<SortTestCubit, SortTestState>(
          builder: (context, state){
            return Container(
              width: MediaQuery.sizeOf(context).width,
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Icon(Icons.translate, size: MediaQuery.sizeOf(context).width*0.07,),
                                Text(" ${AppLocalizations.of(context)!.learn_translate_title}", style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.05, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 40, right: 50),
                                  child: Image.asset("assets/character/hinh3.png", width: 150),
                                ),
                                Positioned(
                                  top: 20,
                                  left: 130,
                                  right: 50,
                                  child:  Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10,),
                                      height: 120,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(4, -4),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await context.read<SortTestCubit>().speak(state.wordEntity);
                                            },
                                            child: const Icon(Icons.volume_down_sharp, color: Colors.blue),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              typeTest == Sorts.wayReadMean ? wordEntity.wayread : typeTest == Sorts.meanKanji ? wordEntity.mean : wordEntity.word,
                                              style: const TextStyle(fontSize: 18, color: Colors.black),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          DragTarget<BoxTextWidget>(
                            onWillAccept: (data) => data != null,
                            onAccept: (data) {
                              context
                                  .read<SortTestCubit>()
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
                                                      .read<SortTestCubit>()
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
                                            .read<SortTestCubit>()
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
                                context.read<SortTestCubit>().checkAnswer(context, onComplete: (bool isCorrect) { onComplete(isCorrect); });
                              }
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}