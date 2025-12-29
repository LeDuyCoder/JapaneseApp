import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Config/dataJson.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/character/presentation/pages/list_character_page.dart';

class CharacterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: DefaultTabController(
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
                ListCharacterPage(type: "hiragana", rowData: dataJson.instance.data[0]),
                ListCharacterPage(type: "katakana", rowData: dataJson.instance.data[1])
              ],
            ),
          ),
        ),
      ),
    );
  }

}