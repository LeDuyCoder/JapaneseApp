import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Module/WordModule.dart';
import 'package:japaneseapp/core/Module/topic.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';

abstract class TopicPrivacyRemoteDataSource{
  Future<bool> isTopicPrivate(String idTopic);
  Future<void> setTopicPrivacy(String idTopic, String nameTopic);
}

class TopicPrivacyRemoteDataSourceImpl implements TopicPrivacyRemoteDataSource{

  Future<bool> pulicTopic(String idTopic, String nameTopic) async{
    final db = LocalDbService.instance;
    List<Map<String, dynamic>> data = await db.topicDao.getAllWordbyTopic(nameTopic);
    User user = FirebaseAuth.instance.currentUser!;

    topic TopicPulic = new topic(id: idTopic, name: nameTopic, owner: user.providerData[0].displayName, count: 0);
    await ServiceLocator.topicService.insertTopic(TopicPulic);

    List<Word> listWordPulics = [];
    for(Map<String, dynamic> word in data){
      listWordPulics.add(new Word(
          word: word["word"],
          mean: word["mean"],
          wayread: word["wayread"],
          level: 0,
          topicID: idTopic
      ));
    }

    bool execInsert = await ServiceLocator.wordService.insertDataWord(listWordPulics);
    return execInsert;
  }

  Future<void> priveTopic(String idTopic) async{
    ServiceLocator.topicService.deleteTopic(idTopic);
  }

  @override
  Future<bool> isTopicPrivate(String idTopic) async {
    topic? isTopic = await ServiceLocator.topicService.getDataTopicByID(idTopic).timeout(Duration(seconds: 10));
    print(isTopic);
    return isTopic == null;
  }

  @override
  Future<void> setTopicPrivacy(String idTopic, nameTopic) async {
    if(await isTopicPrivate(idTopic)){
      await pulicTopic(idTopic, nameTopic);
    } else {
      await priveTopic(idTopic);
    }
  }


}