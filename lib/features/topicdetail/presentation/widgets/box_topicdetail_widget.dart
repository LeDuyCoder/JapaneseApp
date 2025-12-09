import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/topicdetail/data/models/word_model.dart';
import 'package:japaneseapp/features/topicdetail/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/word_widget.dart';

class BoxTopicDetailWidget extends StatelessWidget{
  final String topicName;
  final List<WordModel> words;

  const BoxTopicDetailWidget({super.key, required this.words, required this.topicName});

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
            height: 30,
          ),
          Text(topicName, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Item"),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${amountWord} ${AppLocalizations.of(context)!.listword_Screen_AmountWord}", style: TextStyle(color: AppColors.textSecond.withOpacity(0.5), fontSize: 18, fontFamily: "Itim"),),
              SizedBox(width: 30,),
              Text("${amountComplited} ${AppLocalizations.of(context)!.listword_Screen_Learned}", style: TextStyle(color: AppColors.textSecond.withOpacity(0.5), fontSize: 18, fontFamily: "Itim"),)
            ],
          ),
          SizedBox(height: 20,),
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
          SizedBox(height: 20,),
          GestureDetector(
            onTapUp: (event) {
              // setState(() {
              //   isPressButton = false;
              // });
              //
              // List<word> dataWords = [];
              // for (Map<String, dynamic> wordData in snapshot.data![0]) {
              //   dataWords.add(
              //     word(
              //       wordData["word"],
              //       wordData["wayread"],
              //       wordData["mean"],
              //       wordData["topic"],
              //       wordData["level"],
              //     ),
              //   );
              // }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (ctx) => learnScreen(
              //       dataWords: dataWords,
              //       topic: widget.topicName,
              //       reload: () {
              //         setState(() {});
              //       },
              //     ),
              //   ),
              // );
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.only(left: 40, right: 40),
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(40),
              ),
              child:
              Row(
                children: [
                  SizedBox(width: 20,),
                  Icon(Icons.play_arrow, color: AppColors.white, size: 25,),
                  SizedBox(width: 10,),
                  Text(AppLocalizations.of(context)!.listword_Screen_btn_learn, style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}