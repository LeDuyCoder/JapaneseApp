import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Screen/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/splash/presentation/splash_screen.dart';
import '../State/FeatureState.dart';
import '../Theme/colors.dart';

class settingFeatureLearn extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _settingFeatureLearn();

}

class _settingFeatureLearn extends State<settingFeatureLearn>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          children: [
            Text("Thiết Lập Chế Độ Học", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            ListTile(
              title: const Text("Luyện Nói", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              subtitle: Text("Tính năng luyện đọc từ vựng"),
              trailing: Switch(
                value: SplashScreen.featureState.readTesting,
                activeColor: AppColors.primary,       // màu của nút (thumb) khi bật
                onChanged: (bool value) async {
                  setState(() {
                    SplashScreen.featureState.setStateFeture(KeyFeature.readTesting, value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}