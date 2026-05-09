import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/ui/snackbar/app_snackbar.dart';
import 'package:japaneseapp/features/learn/presentation/pages/learn_page.dart';
import 'package:japaneseapp/features/topicdetail/data/models/word_model.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/topicdetail/cubit/chose_type_cubit.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/box_feature_widget.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/card_word_widget.dart';

import '../../cubit/chose_type_state.dart';

class ChoseTypePage extends StatefulWidget {
  final String idTopic;
  final String name;
  final List<WordModel> words;

  final max_chosen = 5;

  const ChoseTypePage({
    super.key,
    required this.words, required this.name, required this.idTopic,
  });

  @override
  State<ChoseTypePage> createState() => _ChoseTypePageState();
}

class _ChoseTypePageState extends State<ChoseTypePage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChoseTypeCubit([]),

      child: BlocBuilder<ChoseTypeCubit, ChoseTypeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.name),
              scrolledUnderElevation: 0,
            ),
            body: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      BoxFeatureWidget(
                        width: MediaQuery.sizeOf(context).width*0.4,
                        height: MediaQuery.sizeOf(context).width*0.5,
                        imagePath: 'assets/character/hinh19.png',
                        title: 'Ngẫu Nhiên',
                        onTap: () { 
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LearnPage(idTopic: widget.idTopic)));
                        },
                      ),
                      BoxFeatureWidget(
                        width: MediaQuery.sizeOf(context).width*0.4,
                        height: MediaQuery.sizeOf(context).width*0.5,
                        imagePath: 'assets/character/hinh18.png',
                        title: 'Chọn Từ',
                        onTap: () {
                          if(state.choseWords.length < 5){
                            AppSnackBar.show(context, message: "Vui lòng chọn tối thiểu 5 từ", type: AppSnackBarType.error);
                          }else{
                            List<WordEntity> wordEntities = [];
                            for(var word in state.choseWords){
                              wordEntities.add(
                                  WordEntity(
                                      word: word.word,
                                      mean: word.mean,
                                      wayread: word.wayread,
                                      topic: word.topic,
                                      level: word.level
                                  )
                              );
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LearnPage(idTopic: widget.idTopic, characterEntities: wordEntities,)));
                          }
                        },
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Danh Sách", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text("Số Từ Chọn: ${state.choseWords.length} / 5", style: const TextStyle(fontSize: 15),),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10,),

                            for(WordModel word in widget.words)...[
                              CardWordWidget(
                                chosen: state.choseWords.contains(word),
                                wordModel: word,
                                onChange: () {
                                  if(state.choseWords.contains(word)){
                                    context.read<ChoseTypeCubit>().removeChoseWord(word);
                                  }else{
                                    if(state.choseWords.length < widget.max_chosen) {
                                      context
                                          .read<ChoseTypeCubit>()
                                          .addChoseWord(word);
                                    }else{
                                      AppSnackBar.show(context, message: "Số tự chọn đã đạt tối đa", type: AppSnackBarType.warning);
                                    }
                                  }
                                },
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ],
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}