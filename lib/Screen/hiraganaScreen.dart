import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Screen/learnCharactersScreen.dart';

import '../generated/app_localizations.dart';
import 'congraculationCharacterScreen.dart';

class hiraganaScreen extends StatefulWidget{

  final String type;
  final dynamic data;
  final double width;

  const hiraganaScreen({super.key, this.data, required this.type, required this.width});

  @override
  State<StatefulWidget> createState() => _hiraganaScreen();

}

class _hiraganaScreen extends State<hiraganaScreen>{

  final FlutterTts _flutterTts = FlutterTts();
  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  Future<Map<String, dynamic>> loadDataCharacters() async {
    DatabaseHelper db = DatabaseHelper.instance;
    return db.getDataCharacter(widget.type);
  }

  void reloadScreen(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: loadDataCharacters(), builder: (ctx, snapshotData){
      if(snapshotData.connectionState == ConnectionState.waiting){
        return Center(
          child: Container(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          ),
        );
      }


      if(snapshotData.hasData) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: Colors.white,
              width: MediaQuery
                  .sizeOf(context)
                  .width,
              height: widget.width,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery
                      .sizeOf(context)
                      .height * 0.02,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>learnCharactersScreen(typeCharacter: widget.type, contextScreen: ctx, loadScreen: () {
                        reloadScreen();
                      },)));
                      //Navigator.push(context, MaterialPageRoute(builder: (ctx)=>congraculationChacterScreen(listWordsTest: [], listWordsWrong: [], timeTest: 1000, topic: '', reload: () {  },)));
                    },
                    child: Container(
                      width: MediaQuery
                          .sizeOf(context)
                          .width * 0.8,
                      height: MediaQuery
                          .sizeOf(context)
                          .width * 0.15,
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF2E7D32),
                                offset: Offset(6, 6)
                            )
                          ]
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
                  const SizedBox(height: 18,),
                  SizedBox(
                    height: widget.width*0.740,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              itemCount: widget.data[0].length,
                              itemBuilder: (context, index) {
                                Iterable<String> keys = (widget.data[0] as Map<
                                    String,
                                    dynamic>).keys;
                                return GestureDetector(
                                  onTap: () async {
                                    await readText((widget.data[0][keys.elementAt(
                                        index)] as Map<String, dynamic>)
                                        .containsKey("sound") ? widget.data[0][keys
                                        .elementAt(index)]["sound"] : widget
                                        .data[0][keys.elementAt(index)]["text"],
                                        1.0);
                                    //print("Chọn: ${widget.data[0][keys.elementAt(index)]}");
                                  },
                                  child: boxCharacterSingle(
                                      widget.data[0][keys.elementAt(index)]["text"],
                                      widget.data[0][keys.elementAt(
                                          index)]["romaji"],
                                      ((snapshotData.data!["1"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[0][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["1"][widget.data[0][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0) >= 27,
                                      (snapshotData.data!["1"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[0][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["1"][widget.data[0][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0,
                                      context
                                    //snapshotData.data["1"]
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
                              physics: NeverScrollableScrollPhysics(),
                              // Tắt cuộn riêng
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 10,
                                childAspectRatio: (3 + 0.5) / 4,
                              ),
                              itemCount: widget.data[1].length,
                              itemBuilder: (context, index) {
                                Iterable<String> keys = (widget.data[1] as Map<
                                    String,
                                    dynamic>).keys;
                                return GestureDetector(
                                  onTap: () async {
                                    await readText((widget.data[1][keys.elementAt(
                                        index)] as Map<String, dynamic>)
                                        .containsKey("sound") ? widget.data[0][keys
                                        .elementAt(index)]["sound"] : widget
                                        .data[1][keys.elementAt(index)]["text"],
                                        1.0);
                                  },
                                  child: boxCharacterSingle(
                                      widget.data[1][keys.elementAt(index)]["text"],
                                      widget.data[1][keys.elementAt(
                                          index)]["romaji"],
                                      ((snapshotData.data!["2"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[1][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["1"][widget.data[1][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0) >= 27,
                                      (snapshotData.data!["2"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[1][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["1"][widget.data[1][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0,
                                      context
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
                              itemCount: widget.data[2].length,
                              itemBuilder: (context, index) {
                                Iterable<String> keys = (widget.data[2] as Map<
                                    String,
                                    dynamic>).keys;
                                return GestureDetector(
                                  onTap: () async {
                                    await readText((widget.data[2][keys.elementAt(
                                        index)] as Map<String, dynamic>)
                                        .containsKey("sound") ? widget.data[0][keys
                                        .elementAt(index)]["sound"] : widget
                                        .data[2][keys.elementAt(index)]["text"],
                                        1.0);
                                  },
                                  child: boxCharacterCombo(
                                      widget.data[2][keys.elementAt(index)]["text"],
                                      widget.data[2][keys.elementAt(index)]["romaji"],
                                      ((snapshotData.data!["3"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[2][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["3"][widget.data[2][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0) == 27,
                                      (snapshotData.data!["3"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[2][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["3"][widget.data[2][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0,
                                      context
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
                              // Quan trọng: Cho phép GridView tự động co giãn
                              physics: NeverScrollableScrollPhysics(),
                              // Tắt cuộn riêng
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 10,
                                childAspectRatio: 4 / 3.5,
                              ),
                              itemCount: widget.data[3].length,
                              itemBuilder: (context, index) {
                                Iterable<String> keys = (widget.data[3] as Map<
                                    String,
                                    dynamic>).keys;
                                return GestureDetector(
                                  onTap: () async {
                                    await readText((widget.data[3][keys.elementAt(
                                        index)] as Map<String, dynamic>)
                                        .containsKey("sound") ? widget.data[0][keys
                                        .elementAt(index)]["sound"] : widget
                                        .data[3][keys.elementAt(index)]["text"],
                                        1.0);
                                  },
                                  child: boxCharacterSingle(
                                      widget.data[3][keys.elementAt(index)]["text"],
                                      widget.data[3][keys.elementAt(
                                          index)]["romaji"],
                                      ((snapshotData.data!["4"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[3][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["4"][widget.data[3][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0) == 27,
                                      (snapshotData.data!["4"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[3][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["4"][widget.data[3][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0,
                                      context
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
                              // Quan trọng: Cho phép GridView tự động co giãn
                              physics: NeverScrollableScrollPhysics(),
                              // Tắt cuộn riêng
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 10,
                                childAspectRatio: 3.5 / 4,
                              ),
                              itemCount: widget.data[4].length,
                              itemBuilder: (context, index) {
                                Iterable<String> keys = (widget.data[4] as Map<
                                    String,
                                    dynamic>).keys;
                                return GestureDetector(
                                  onTap: () async {
                                    await readText((widget.data[4][keys.elementAt(
                                        index)] as Map<String, dynamic>)
                                        .containsKey("sound") ? widget.data[0][keys
                                        .elementAt(index)]["sound"] : widget
                                        .data[4][keys.elementAt(index)]["text"],
                                        1.0);
                                  },
                                  child: boxCharacterSingle(
                                      widget.data[4][keys.elementAt(index)]["text"],
                                      widget.data[4][keys.elementAt(
                                          index)]["romaji"],
                                      ((snapshotData.data!["5"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[4][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["5"][widget.data[4][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0) == 27,
                                      (snapshotData.data!["5"] as Map<
                                          dynamic,
                                          dynamic>).containsKey(
                                          widget.data[4][keys.elementAt(
                                              index)]["text"]) ? snapshotData
                                          .data!["5"][widget.data[4][keys.elementAt(
                                          index)]["text"]][0]["level"] : 0,
                                      context
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );

      }

      return Center(
        child: Text(snapshotData.error.toString()),
      );
    });
  }


  Widget boxCharacterCombo(String word, String romaji, bool isFull, int level, BuildContext context) {
    return word.isNotEmpty
        ? SizedBox(
      child: Container(
        decoration: BoxDecoration(
          color: isFull ? Color.fromRGBO(255, 255, 224, 1.0) : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: isFull ? Color.fromRGBO(238, 230, 0, 1.0) : Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: isFull ? Color.fromRGBO(238, 230, 0, 1.0) : Colors.grey.shade400,
              offset: Offset(4, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              word,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * 0.015,
                fontFamily: "Itim",
                color: isFull ? const Color.fromRGBO(255, 196, 0, 1.0) : Colors.black,
              ),
              minFontSize: 10,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            AutoSizeText(
              romaji,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * 0.015,
                fontFamily: "Itim",
                color: isFull ? const Color.fromRGBO(255, 196, 0, 1.0) : Colors.black,
              ),
              minFontSize: 5,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.2,
              height: MediaQuery.sizeOf(context).width * 0.015,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                color: isFull ? const Color.fromRGBO(255, 216, 0, 1.0) : Colors.green,
                value: level / 27,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                minHeight: 8,
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          ],
        ),
      ),
    )
        : SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.15,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }


  Widget boxCharacterSingle(String word, String romaji, bool isFull, int level, BuildContext context) {
    return word.isNotEmpty
        ? SizedBox(
      // Đặt chiều cao cố định
      child: Container(
        decoration: BoxDecoration(
          color: isFull ? Color.fromRGBO(255, 255, 224, 1.0) : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
              color: isFull ? Color.fromRGBO(238, 230, 0, 1.0) : Colors.grey),
          boxShadow: [
            BoxShadow(
                color: isFull
                    ? Color.fromRGBO(238, 230, 0, 1.0)
                    : Colors.grey.shade400,
                offset: Offset(4, 4))
          ],
        ),
        // Thêm padding để căn chỉnh đẹp hơn
        child: Column(
          mainAxisSize: MainAxisSize.min, // Tránh chiếm toàn bộ không gian
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              word,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * 0.02,
                fontFamily: "Itim",
                color: isFull
                    ? const Color.fromRGBO(255, 196, 0, 1.0)
                    : Colors.black,
              ),
              minFontSize: 10, // Giảm để tránh mất chữ
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            AutoSizeText(
              romaji,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * 0.015,
                fontFamily: "Itim",
                color: isFull
                    ? const Color.fromRGBO(255, 196, 0, 1.0)
                    : Colors.black,
              ),
              minFontSize: 5,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.1, // Tăng kích thước thanh tiến trình
              height: MediaQuery.sizeOf(context).width * 0.015,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                color: isFull
                    ? const Color.fromRGBO(255, 216, 0, 1.0)
                    : Colors.green,
                value: level / 27,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    )
        : SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.15, // Đặt chiều cao cố định
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

}