import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataJson.dart';
import 'package:japaneseapp/Screen/hiraganaScreen.dart';
import 'package:japaneseapp/Theme/colors.dart';

class charactersScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _charactersSCreen();
}

class _charactersSCreen extends State<charactersScreen>{

  Future<dynamic> loadJsonData() async {
    dynamic jsonData = dataJson.instance.data;
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder(future: loadJsonData(), builder: (ctx, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Container(
                height: 100,
                width: 100,
                child: const CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }

          if(!snapshot.hasData){
            return Center(
              child: Container(
                  height: MediaQuery.sizeOf(context).width*0.8,
                  child: Image.asset("assets/404.png")
              ),
            );
          }

          return DefaultTabController(
            length: 2, // Số lượng tab
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  flexibleSpace: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TabBar(
                        labelColor: AppColors.primary, // Màu chữ khi tab được chọn
                        unselectedLabelColor: Colors.black, // Màu chữ khi chưa chọn
                        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "Itim"),
                        unselectedLabelStyle: TextStyle(fontSize: 16),
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 3.0, color: AppColors.primary), // Gạch dưới tab
                          insets: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        tabs: [
                          Tab(text: "HIRAGANA"),
                          Tab(text: "KATAKANA"),
                        ],
                      ),
                    ],
                  ),
                ),
                body: Container(
                  child: TabBarView(
                    children: [
                      Center(child: hiraganaScreen(data: snapshot.data![0], type: "hiragana", width: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height)),
                      Center(child: hiraganaScreen(data: snapshot.data![1], type: "katakana", width: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height)),
                    ],
                  ),
                ),
            ),
          );
        }),
      )
    );
  }

}