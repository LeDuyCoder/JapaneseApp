import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/chose/cubit/chose_test_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/chose/cubit/chose_test_state.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/listen/cubit/listen_test_state.dart';
import 'package:japaneseapp/features/learn/presentation/widget/check_button.dart';
import 'package:japaneseapp/features/learn/presentation/widget/chose_word_widget.dart';

class ChoseTestView extends StatelessWidget implements BaseTestView{

  final Function(bool isCorrect) onComplete;
  final BuildContext contextPage;

  final List<WordEntity> listWords;
  final WordEntity word;

  const ChoseTestView({super.key, required this.contextPage, required this.onComplete, required this.listWords, required this.word});

  @override
  VoidCallback get onTestComplete => onComplete(false);

  String getDataFromType(Choses type, WordEntity wordEntity){
    switch(type){
      case Choses.kanjiWayRead:
        return wordEntity.wayread;
      case Choses.kanjiMean:
        return wordEntity.mean;
      case Choses.wayReadKanji:
        return wordEntity.word;
      case Choses.wayReadMean:
        return wordEntity.mean;
      case Choses.MeanKanji:
        return wordEntity.word;
      case Choses.meanWayRead:
        return wordEntity.wayread;
    }
  }

  void callClick(BuildContext context, WordEntity wordEntity){
    context.read<ChoseTestCubit>().select(wordEntity);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChoseTestCubit(listWords, word),
      child: BlocBuilder<ChoseTestCubit, ChoseTestState>(
          builder: (context, state){
            return Container(
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width*0.9,
                            child: AutoSizeText(
                              "Tìm từ phù hợp ${state.currentWord.word}",
                              style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.03, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChoseWordWidget(isChose: state.chosen == state.listWords[0], choseItem: () {
                            callClick(context, state.listWords[0]);
                          }, wordEntity: state.listWords[0], typeTest: state.typeTest,),
                          ChoseWordWidget(isChose: state.chosen == state.listWords[2], choseItem: () {
                            callClick(context, state.listWords[2]);
                          }, wordEntity: state.listWords[2], typeTest: state.typeTest,),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ChoseWordWidget(isChose: state.chosen == state.listWords[1], choseItem: () {
                            callClick(context, state.listWords[1]);
                          }, wordEntity: state.listWords[1], typeTest: state.typeTest,),
                          ChoseWordWidget(isChose: state.chosen == state.listWords[3], choseItem: () {
                            callClick(context, state.listWords[3]);
                          }, wordEntity: state.listWords[3], typeTest: state.typeTest,),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    CheckButton(enabled: state.chosen != null, onTap: (){
                      context.read<ChoseTestCubit>().checkAnswer(context, onComplete: (isCorrect){
                        onComplete(isCorrect);
                      });
                    })
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}