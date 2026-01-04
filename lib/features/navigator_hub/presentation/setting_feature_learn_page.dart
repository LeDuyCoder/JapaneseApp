
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/State/FeatureState.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/splash/presentation/splash_screen.dart';

class SettingFeatureLearnPage extends StatefulWidget{
  const SettingFeatureLearnPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingFeatureLearnPage();

}

class _SettingFeatureLearnPage extends State<SettingFeatureLearnPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          children: [
            const Text("Thiết Lập Chế Độ Học", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
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