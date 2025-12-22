import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Screen/downloadScreen.dart';
import 'package:japaneseapp/core/module/topic_module.dart';
import 'package:japaneseapp/core/module/word_module.dart';
import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/dashboard/domain/models/word_entity.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/tabhome/rename_topic_dialog.dart';

import '../../../../../core/service/Server/ServiceLocator.dart' show ServiceLocator;

class BottomSheetDownloadPublic extends StatelessWidget {
  final String id;
  final String nameTopic;

  const BottomSheetDownloadPublic({
    super.key,
    required this.id,
    required this.nameTopic,
  });

  Future<bool> dowloadTopic(BuildContext context) async{

    final db = LocalDbService.instance;
    String? nameTopicTemp = "";

    TopicModule? Topic = await ServiceLocator.topicService.getDataTopicByID(id);

    nameTopicTemp = Topic!.name;
    List<Map<String, dynamic>> dataWords = [];

    if(await db.topicDao.hasTopicName(nameTopic)){
      nameTopicTemp = await RenameTopicDialog.show(context);
    }

    if(!await db.topicDao.hasTopicName(nameTopic)){
      List<Word> listWord = await ServiceLocator.wordService.fetchWordsByTopicID(id);
      for(Word wordDB in listWord){
        dataWords.add(
            WordEntity(word: wordDB.word, wayread: wordDB.wayread, mean: wordDB.mean, topic: nameTopic==""?Topic.name:nameTopic, level: 0).toJson()
        );
      }

      await db.topicDao.insertTopicID(Topic.id, nameTopic==""?Topic.name:nameTopic, Topic.owner!);
      await db.topicDao.insertDataTopic(dataWords);

    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 16, left: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          SizedBox(height: 20,),
          const Icon(
            Icons.warning,
            color: Colors.orange,
            size: 60,
          ),
          const SizedBox(height: 20),

          Text(
            AppLocalizations.of(context)!
                .comunication_bottomSheet_notify_download_title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondary) =>
                      DownloadScreen(
                        nameTopic: nameTopic,
                        downloadTopic: () => dowloadTopic(context),
                      ),
                  transitionsBuilder: (context, animation, secondary, child) {
                    final tween = Tween(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.ease));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!
                      .comunication_bottomSheet_notify_download_btn,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
