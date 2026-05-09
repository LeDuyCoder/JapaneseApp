import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/congratulation/presentation/pages/congratulation_page.dart';
import 'package:japaneseapp/features/learn/presentation/pages/learn_page.dart';
import 'package:japaneseapp/features/topicdetail/data/models/word_model.dart';
import 'package:japaneseapp/features/topicdetail/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/topicdetail/presentation/pages/chose_type_page.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/box_card_word_widget.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/box_feature_widget.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/word_widget.dart';

import 'package:japaneseapp/features/congratulation/domain/entities/word_entity.dart' as WordEntityCongratulation;

import 'horizontal_card_scroller.dart';

class BoxTopicDetailWidget extends StatelessWidget{
  final String topicName;
  final String topicId;
  final List<WordModel> words;

  const BoxTopicDetailWidget({super.key, required this.words, required this.topicName, required this.topicId});

  @override
  Widget build(BuildContext context) {
    int amountWord = words.length;
    int amountComplited = 0;
    for(WordEntity itemWord in words){
      if(itemWord.level >= 27){
        amountComplited++;
      }
    }

    return Container(
      width: MediaQuery.sizeOf(context).width,
      color: AppColors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(topicName, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Item"),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$amountWord ${AppLocalizations.of(context)!.listword_Screen_AmountWord}", style: TextStyle(color: AppColors.textSecond.withOpacity(0.5), fontSize: 18, fontFamily: "Itim"),),
              const SizedBox(width: 30,),
              Text("$amountComplited ${AppLocalizations.of(context)!.listword_Screen_Learned}", style: TextStyle(color: AppColors.textSecond.withOpacity(0.5), fontSize: 18, fontFamily: "Itim"),)
            ],
          ),

          const SizedBox(height: 5,),
          HorizontalCardScroller(
            children: [
              for (WordModel word in words)
                BoxCardWordWidget(wordModel: word),
            ],
          ),

          const SizedBox(height: 20,),

          Row(
            children: [
                BoxFeatureWidget(
                    width: MediaQuery.sizeOf(context).width*0.4,
                    height: MediaQuery.sizeOf(context).width*0.5,
                    imagePath: "assets/character/hinh18.png",
                    title: "Ghép thẻ",
                    onTap: (){}
                ),
                BoxFeatureWidget(
                    width: MediaQuery.sizeOf(context).width*0.4,
                    height: MediaQuery.sizeOf(context).width*0.5,
                    imagePath: "assets/character/hinh12.png",
                    title: "Học từ",
                    onTap: (){}
                )
            ],
          ),

          GestureDetector(
            onTapUp: (event) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChoseTypePage(words: words, name: topicName, idTopic: topicId,)));
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.only(left: 40, right: 40),
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20,),
                  const Icon(Icons.play_arrow, color: AppColors.white, size: 25,),
                  const SizedBox(width: 10,),
                  Text(AppLocalizations.of(context)!.listword_Screen_btn_learn, style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          ),

          const SizedBox(height: 20,),

          Container(
            margin:  EdgeInsets.only(left: 40, right: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height / 1.8,
              ),
              child: SingleChildScrollView(
                child: WordWidget(wordEntitys: words, topicName: topicName, reloadScreenListWord: () {  },), // table hoặc column của bạn
              ),
            ),
          ),
        ],
      ),
    );
  }

}