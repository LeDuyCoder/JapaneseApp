import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class searchWordScreen extends StatefulWidget {
  final String wordSearch;

  const searchWordScreen({super.key, required this.wordSearch});

  @override
  State<StatefulWidget> createState() => _searchWordScreen();
}

class _searchWordScreen extends State<searchWordScreen> {
  TextEditingController searchWord = TextEditingController();
  String? wordSearchState;
  int sizeArgs = 0;
  int count = 1;
  AsyncSnapshot<Map<dynamic, dynamic>>? snapshot;
  bool isLoad = false;
  bool isPress = false;

  Future<Map<dynamic, dynamic>> fetchData(String word) async {
    final String url = "https://jisho.org/api/v1/search/words?keyword=${word}"; // Thay URL API của bạn
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        sizeArgs = (data["data"] as List<dynamic>).length;
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    wordSearchState ??= widget.wordSearch;
    searchWord.text = wordSearchState!;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.68,
                height: MediaQuery.sizeOf(context).width * 0.10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: searchWord,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.translate),
                        border: InputBorder.none, // Ẩn border mặc định
                        hintText: "Từ bạn muốn tra...",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLoad = true;
                    isPress = true;
                    wordSearchState = searchWord.text;
                  });
                  //Navigator.push(context, MaterialPageRoute(builder: (ctx)=>searchWordScreen()));
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.1,
                  height: MediaQuery.sizeOf(context).width * 0.1,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(184, 241, 176, 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Icon(Icons.search),
                ),
              )
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                    color: Colors.white,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height - 30,
                    child: FutureBuilder(future: fetchData(wordSearchState!), builder: (ctx, snapshotData){

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (isPress && snapshotData.connectionState == ConnectionState.done) {
                          setState(() {
                            isLoad = false;
                            isPress = false;
                          });
                        }
                      });

                      if(snapshotData.hasData){
                        snapshot = snapshotData;
                        return (snapshot!.data!["data"] as List<dynamic>).isNotEmpty ? SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            (snapshot!.data!["data"][0]["japanese"][0] as Map<dynamic, dynamic>).containsKey("word") ? snapshot!.data!["data"][0]["japanese"][0]["word"] : snapshot!.data!["data"][0]["slug"],
                                            style: TextStyle(
                                                fontSize: MediaQuery.sizeOf(context).width * 0.1),
                                          ),
                                          Text(" - ${
                                              snapshot!.data!["data"][0]["japanese"][0]["reading"]
                                          }",
                                              style: TextStyle(
                                                  fontSize:
                                                  MediaQuery.sizeOf(context).width * 0.07)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          boxTitle(
                                              MediaQuery.sizeOf(context).width * 0.3,
                                              MediaQuery.sizeOf(context).width * 0.095,
                                              snapshot!.data!["data"][0]["is_common"] ? "Common" : "Not Common",
                                              const Color.fromRGBO(157, 220, 136, 1.0)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (snapshot!.hasData && snapshot!.data!["data"][0] != null && snapshot!.data!["data"][0]["jlpt"].isNotEmpty)
                                            boxTitle(
                                                MediaQuery.sizeOf(context).width * 0.3,
                                                MediaQuery.sizeOf(context).width * 0.095,
                                                snapshot!.data!["data"][0]["jlpt"][0],
                                                const Color.fromRGBO(220, 136, 136, 1.0)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (snapshot!.hasData && snapshot!.data!["data"][0] != null && snapshot!.data!["data"][0]["senses"][0]["parts_of_speech"].isNotEmpty)
                                            boxTitle(
                                                MediaQuery.sizeOf(context).width * 0.3,
                                                MediaQuery.sizeOf(context).width * 0.095,
                                                "【${snapshot!.data!["data"][0]["senses"][0]["parts_of_speech"][0]}】",
                                                const Color.fromRGBO(220, 203, 136, 1.0))
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Container(
                                            width: MediaQuery.sizeOf(context).width*0.9,
                                            height:  MediaQuery.sizeOf(context).width*0.1,
                                            child: AutoSizeText(
                                              "- ${hanldMean(snapshot!.data!["data"][0]["senses"][0]["english_definitions"])}",
                                              style: TextStyle(
                                                fontSize: MediaQuery.sizeOf(context).width*0.05,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      if((snapshot!.data!["data"][0]["japanese"] as List<dynamic>).length >= 2)
                                        Text("Other forms",
                                            style: TextStyle(
                                                fontSize:
                                                MediaQuery.sizeOf(context).width * 0.05)),
                                      Container(
                                        width: MediaQuery.sizeOf(context).width-20,
                                        child: Text(
                                            hanldeWayRead(snapshot!.data!["data"][0]["japanese"]),
                                            style: TextStyle(
                                                fontSize:
                                                MediaQuery.sizeOf(context).width * 0.04)),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 50,),
                                if(sizeArgs > 2)
                                  for(int i = 1; i < sizeArgs-1; i++)
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                      (snapshot!.data!["data"][i]["japanese"][0] as Map<dynamic, dynamic>).containsKey("word") ? snapshot!.data!["data"][i]["japanese"][0]["word"] : snapshot!.data!["data"][i]["slug"],
                                                style: TextStyle(
                                                    fontSize: MediaQuery.sizeOf(context).width * 0.07),
                                              ),
                                              Text(" - ${snapshot!.data!["data"][i]["japanese"][0]["reading"]}",
                                                  style: TextStyle(
                                                      fontSize:
                                                      MediaQuery.sizeOf(context).width * 0.05)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              if (snapshot!.hasData && snapshot!.data!["data"][i] != null && (snapshot!.data!["data"][i] as Map<dynamic, dynamic>).containsKey("is_common"))
                                                boxTitle(
                                                    MediaQuery.sizeOf(context).width * 0.25,
                                                    MediaQuery.sizeOf(context).width * 0.085,
                                                    snapshot!.data!["data"][i]["is_common"] ? "Common" : "Not Common",
                                                    const Color.fromRGBO(157, 220, 136, 1.0)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              if (snapshot!.hasData && snapshot!.data!["data"][i] != null && snapshot!.data!["data"][i]["jlpt"].isNotEmpty)
                                                boxTitle(
                                                    MediaQuery.sizeOf(context).width * 0.25,
                                                    MediaQuery.sizeOf(context).width * 0.085,
                                                    snapshot!.data!["data"][i]["jlpt"][0],
                                                    const Color.fromRGBO(220, 136, 136, 1.0)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            textBaseline: TextBaseline.alphabetic,
                                            children: [
                                              Container(
                                                width: MediaQuery.sizeOf(context).width*0.9,
                                                height:  MediaQuery.sizeOf(context).width*0.1,
                                                child: AutoSizeText(
                                                  "- ${hanldMean(snapshot!.data!["data"][i]["senses"][0]["english_definitions"])}",
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.sizeOf(context).width*0.04,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                              ],
                            ),
                          ),
                        ) : Center(
                          child: Center(
                            child: Image.asset("assets/404.png")
                          ),
                        );
                      }

                      return Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        ),
                      );
                    })
                )
            ),
            isLoad ?
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height,
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              )
            ) : Center(),
          ],
        )
    );
  }

  Widget boxTitle(double width, double height, String content, Color color) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            content,
            style: TextStyle(fontSize: width * 0.12),
          ),
        ));
  }

  String hanldeWayRead(List<dynamic> listData){
    StringBuffer data = StringBuffer();
    int i = 0;
    for(Map<dynamic, dynamic> stringData in listData){
      if(i==0){
        i++;
      }else {
        data.write("${stringData["word"]} 【${stringData["reading"]}】, ");
      }
    }
    return data.toString();
  }

  String hanldMean(List<dynamic> listData){
    StringBuffer data = StringBuffer();
    for(String stringData in listData){
      data.write("${stringData}, ");
    }
    return data.toString();
  }
}
