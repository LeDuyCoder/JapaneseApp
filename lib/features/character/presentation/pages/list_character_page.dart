import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/character/bloc/character_bloc.dart';
import 'package:japaneseapp/features/character/bloc/character_event.dart';
import 'package:japaneseapp/features/character/bloc/character_state.dart';
import 'package:japaneseapp/features/character/data/datasource/character_datasource.dart';
import 'package:japaneseapp/features/character/data/repositories/character_repository_impl.dart';
import 'package:japaneseapp/features/character/presentation/widgets/box_character_combo_widget.dart';
import 'package:japaneseapp/features/character/presentation/widgets/box_character_single_widget.dart';
import 'package:japaneseapp/features/character/presentation/widgets/floating_image.dart';
import 'package:japaneseapp/features/learn/domain/enum/type_test.dart';
import 'package:japaneseapp/features/learn/presentation/pages/learn_character_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListCharacterPage extends StatelessWidget{
  final String type;
  final List<Map<String, dynamic>> rowData;


  const ListCharacterPage({super.key, required this.type, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharacterBloc(
          repo: CharacterRepositoryImpl(
              datasource: CharacterDatasource()
          )
      )..add(LoadCharacterEvent(type: type, rowData: rowData)),
      child: BlocBuilder<CharacterBloc, CharacterState>(
          builder: (context, state){
            if(state is LoadedCharacterState){
              return Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>LearnCharacterPage(
                                type: type=="hiragana"?TypeTest.hiragana:TypeTest.katakana,
                                setLevel: jsonDecode(prefs.getString(type)!)["levelSet"]
                            )));
                          },
                          child: Container(
                            width: MediaQuery
                                .sizeOf(context)
                                .width * 0.8,
                            height: MediaQuery
                                .sizeOf(context)
                                .width * 0.15,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: Text(AppLocalizations.of(context)!.character_btn_learn, style: TextStyle(
                                  fontFamily: "Itim",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: MediaQuery
                                      .sizeOf(context)
                                      .width * 0.05),),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          // Quan trọng: Cho phép GridView tự điều chỉnh chiều cao
                          physics: NeverScrollableScrollPhysics(),
                          // Tắt cuộn riêng trong GridView
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10,
                            childAspectRatio: (3 + 0.5) / 4,
                          ),
                          itemCount: rowData[0].length,
                          itemBuilder: (context, index) {
                            Iterable<String> keys = (rowData[0]).keys;
                            return GestureDetector(
                              onTap: () async {},
                              child: BoxCharaterSingleWidget(
                                word: rowData[0][keys.elementAt(index)]["text"],
                                romaji: rowData[0][keys.elementAt(index)]["romaji"],
                                isFull: state.characterCollectionEntity.groups[0].characters[index].level >= 27,
                                level: state.characterCollectionEntity.groups[0].characters[index].level,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 5,
                      ),
                      const SizedBox(height: 20,),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Dakuon", style: TextStyle(
                                fontFamily: "Itim", fontSize: 20),),
                            Text("Thêm kí tự để đổi âm", style: TextStyle(
                                fontFamily: "Itim", fontSize: 20),)
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          // Quan trọng: Cho phép GridView tự điều chỉnh chiều cao
                          physics: NeverScrollableScrollPhysics(),
                          // Tắt cuộn riêng trong GridView
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10,
                            childAspectRatio: (3 + 0.5) / 4,
                          ),
                          itemCount: rowData[1].length,
                          itemBuilder: (context, index) {
                            Iterable<String> keys = (rowData[1]).keys;
                            return GestureDetector(
                              onTap: () async {},
                              child: BoxCharaterSingleWidget(
                                word: rowData[1][keys.elementAt(index)]["text"],
                                romaji: rowData[1][keys.elementAt(index)]["romaji"],
                                isFull: state.characterCollectionEntity.groups[1].characters[index].level >= 27,
                                level: state.characterCollectionEntity.groups[1].characters[index].level,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 5,
                      ),
                      const SizedBox(height: 20,),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Kết hợp", style: TextStyle(
                                fontFamily: "Itim", fontSize: 20),),
                            Text("Thêm các ký tự nhỏ để tạo âm tiết mới",
                              style: TextStyle(
                                  fontFamily: "Itim", fontSize: 20),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          // Quan trọng: Cho phép GridView tự động co giãn
                          physics: NeverScrollableScrollPhysics(),
                          // Tắt cuộn riêng
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10,
                            childAspectRatio: 4 / 2.5,
                          ),
                          itemCount: rowData[2].length,
                          itemBuilder: (context, index) {
                            Iterable<String> keys = (rowData[2]).keys;
                            return GestureDetector(
                              onTap: () async {},
                              child: BoxCharaterComboWidget(
                                word: rowData[2][keys.elementAt(index)]["text"],
                                romaji: rowData[2][keys.elementAt(index)]["romaji"],
                                isFull: state.characterCollectionEntity.groups[2].characters[index].level >= 27,
                                level: state.characterCollectionEntity.groups[2].characters[index].level,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 5,
                      ),
                      const SizedBox(height: 20,),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nhỏ", style: TextStyle(
                                fontFamily: "Itim", fontSize: 20),),
                            Text("Nhân đôi phụ âm sau", style: TextStyle(
                                fontFamily: "Itim", fontSize: 20),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          // Quan trọng: Cho phép GridView tự điều chỉnh chiều cao
                          physics: NeverScrollableScrollPhysics(),
                          // Tắt cuộn riêng trong GridView
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10,
                            childAspectRatio: 4 / 3.5,
                          ),
                          itemCount: rowData[3].length,
                          itemBuilder: (context, index) {
                            Iterable<String> keys = (rowData[3]).keys;
                            return GestureDetector(
                              onTap: () async {},
                              child: BoxCharaterSingleWidget(
                                word: rowData[3][keys.elementAt(index)]["text"],
                                romaji: rowData[3][keys.elementAt(index)]["romaji"],
                                isFull: state.characterCollectionEntity.groups[3].characters[index].level >= 27,
                                level: state.characterCollectionEntity.groups[3].characters[index].level,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 5,
                      ),
                      const SizedBox(height: 20,),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("nguyên âm dài", style: TextStyle(
                                fontFamily: "Itim", fontSize: 20),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          shrinkWrap: true,
                          // Quan trọng: Cho phép GridView tự điều chỉnh chiều cao
                          physics: NeverScrollableScrollPhysics(),
                          // Tắt cuộn riêng trong GridView
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10,
                            childAspectRatio: (3 + 0.5) / 4,
                          ),
                          itemCount: rowData[4].length,
                          itemBuilder: (context, index) {
                            Iterable<String> keys = (rowData[4]).keys;
                            return GestureDetector(
                              onTap: () async {},
                              child: BoxCharaterSingleWidget(
                                word: rowData[4][keys.elementAt(index)]["text"],
                                romaji: rowData[4][keys.elementAt(index)]["romaji"],
                                isFull: state.characterCollectionEntity.groups[4].characters[index].level >= 27,
                                level: state.characterCollectionEntity.groups[4].characters[index].level,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              );
            }

            if(state is LoadingCharacterState){
              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingImage(
                        pathImage: "assets/character/hinh12.png",
                        width: 250,
                        height: 250
                    ),
                    Text("Loading...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  ],
                ),
              );
            }

            return Container();
          }
      ),
    );
  }

}