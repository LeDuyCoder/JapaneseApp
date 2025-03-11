import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/word.dart';
import 'package:japaneseapp/Screen/learnScreen.dart';
import 'package:japaneseapp/Widget/wordWidget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:japaneseapp/Module/word.dart' as wordModule;

class listWordScreen extends StatefulWidget{
  final String topicName;
  final void Function() reloadDashboard;

  const listWordScreen({super.key, required this.topicName, required this.reloadDashboard});
  @override
  State<StatefulWidget> createState() => _listWordScreen();
}

class _listWordScreen extends State<listWordScreen>{
  int amountWord = 0;
  bool isButtonDisabled = true;
  bool isPressButton = false;
  AutoSizeGroup textGroup = AutoSizeGroup();


  Future<double> handledComplited (String topic) async {
    int sumComplitted = 0;

    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataWords = await db.getAllWordbyTopic(topic);

    if(dataWords.isNotEmpty) {
      for (Map<String, dynamic> word in dataWords) {
        sumComplitted += word['level'] as int ?? 0;
      }
    }

    return dataWords.isNotEmpty ? sumComplitted / (28*dataWords.length) : 0;
  }

  Future<List<dynamic>> hanldeDataWords(String topic) async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataWords = await db.getAllWordbyTopic(topic);
    double wordComplited = await handledComplited(topic);
    return [dataWords, wordComplited, dataWords.length];
  }

  Future<String> saveCustomFile(String fileName, String content) async {
    try {
      // Lấy thư mục lưu trữ tạm thời (bộ nhớ cục bộ)
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Tạo file và ghi dữ liệu
      final file = File(filePath);
      await file.writeAsString(content);

      print('File saved at: $filePath');
      return filePath;
    } catch (e) {
      print('Error saving file: $e');
      throw e;
    }
  }

  Future<void> shareFile(String filePath) async {
    try {
      // Sử dụng shareXFiles để chia sẻ file
      await Share.shareXFiles([XFile(filePath)], text: 'Check out my custom file!');
    } catch (e) {
      print('Error sharing file: $e');
    }
  }


  Future<String> hanldDataWordsQr(String topic) async {
    String idTopic = "";
    String nameTopic = "";
    
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataWords = await db.getAllWordbyTopic(topic);
    List<Map<String, dynamic>> dataTopics = await db.getAllTopic();
    for(Map<String, dynamic> dataTopic in dataTopics){
      if(dataTopic["name"] == topic){
        idTopic = dataTopic["id"];
        nameTopic = dataTopic["name"];
      }
    }

    List<Map<String, dynamic>> dataWordsQr = [];

    for(Map<String, dynamic> dataWord in dataWords){
      dataWordsQr.add(
          {
          "word": dataWord["word"],
          "mean": dataWord["mean"],
          "wayread": dataWord["wayread"]
        }
      );
    }

    String dataShare = jsonEncode(
        {
          "id": idTopic,
          "name": nameTopic,
          "listWords": dataWordsQr
        });
    return dataShare;

  }

  Future<Widget> showShareFile(String data) async {
    String filePath = await saveCustomFile("${widget.topicName}.jpdb", data);
    shareFile(filePath);
    return const Icon(Icons.share, color: Colors.black, size: 20,);

  }

  void showDialogDelete() async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(20, 195, 142, 1.0), // Màu xanh cạnh trên ngoài cùng
                        width: 10.0, // Độ dày của cạnh trên
                      ),
                    ),
                  ),
                  child: Container(
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/character/character6.png", width: MediaQuery.sizeOf(context).width*0.3,),
                        const Column(
                          children: [
                            SizedBox(height: 20),
                            AutoSizeText(
                              "Once deleted, it cannot be restored",
                              style: TextStyle(fontFamily: "indieflower", fontSize: 15),
                            ),

                            AutoSizeText(
                              "Do you want delete topic",
                              style: TextStyle(fontFamily: "indieflower"),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                DatabaseHelper db = DatabaseHelper.instance;
                                db.deleteData("topic", "name = '${widget.topicName}'");
                                db.deleteData("words", "topic = '${widget.topicName}'");
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                widget.reloadDashboard();
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width*0.3,
                                height: MediaQuery.sizeOf(context).height*0.05,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                    ]
                                ),
                                child: const Center(
                                  child: Text("Delete", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
                                ),
                              ),

                            ),
                            SizedBox(width:10,),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.3,
                                height: MediaQuery.sizeOf(context).height * 0.05,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
              );
            },
          ),
        );
      },
    );
  }

  void showDialogShareTopic() async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(20, 195, 142, 1.0), // Màu xanh cạnh trên ngoài cùng
                      width: 10.0, // Độ dày của cạnh trên
                    ),
                  ),
                ),
                child: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.sizeOf(context).width - 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const AutoSizeText(
                                  "Topic's Name: ",
                                  style: TextStyle(fontFamily: "indieflower"),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.topicName,
                                    style: const TextStyle(
                                      fontFamily: "indieflower",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis, // Xử lý nếu văn bản quá dài
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText("Amount word: ", style: TextStyle(fontFamily: "indieflower")),
                              AutoSizeText(
                                "$amountWord",
                                style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText("State: ", style: TextStyle(fontFamily: "indieflower")),
                              AutoSizeText(
                                amountWord < 15 ? "QR Code" : "Share File",
                                style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              showDialogDelete();
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width*0.3,
                              height: MediaQuery.sizeOf(context).height*0.05,
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                  ]
                              ),
                              child: const Center(
                                child: Text("Delete", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                              ),
                            ),

                          ),
                          SizedBox(width:10,),
                          GestureDetector(
                            onTap: () async {
                              if(widget.topicName.split("-").length >= 2 && isButtonDisabled){
                                showOverlay(context, "This is a shared file that you can't share");
                                isButtonDisabled = false;
                              }else {
                                if (amountWord < 15) {
                                  try {
                                    // Gọi hàm bất đồng bộ
                                    final data = await hanldDataWordsQr(
                                        widget.topicName);
                                    // Hiển thị dialog khi có dữ liệu
                                    showDialogQR(
                                        QrImageView(
                                          data: gzipCompress(data),
                                          size: 150, // Đảm bảo kích thước bên trong widget QrImageView
                                        )
                                    );
                                  } catch (e) {
                                      print("Error: $e");
                                  }
                                }
                                else {
                                  final data = await hanldDataWordsQr(
                                      widget.topicName);
                                  String path = await saveCustomFile(
                                      "${widget.topicName}.jpdb", data);
                                  shareFile(path);
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              height: MediaQuery.sizeOf(context).height * 0.05,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Center(
                                child: Text(
                                  "Share",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              );
            },
          ),
        );
      },
    );
  }

  String gzipDecompress(String compressedData) {
    List<int> compressedBytes = base64.decode(compressedData);
    List<int> decompressedBytes = GZipDecoder().decodeBytes(compressedBytes);
    return utf8.decode(decompressedBytes);
  }

  String gzipCompress(String jsonData) {
    List<int> jsonBytes = utf8.encode(jsonData);
    List<int> compressedBytes = const GZipEncoder().encode(jsonBytes);
    return base64.encode(compressedBytes);
  }

  void showDialogQR(QrImageView data){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(20, 195, 142, 1.0), // Màu xanh cạnh trên ngoài cùng
                      width: 10.0, // Độ dày của cạnh trên
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50,),
                        Container(
                          color: Colors.white,
                          child: Center(
                            child: Container(
                              height: 250,
                              width: 250,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 10
                                  )
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: data,
                              )
                            ),
                          )
                        ),
                        const SizedBox(height: 50,),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showOverlay(BuildContext context, String text) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 20,
        right: 20,
        top: 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(12),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20,
                      offset: Offset(4, -4)
                  )
                ]
            ),
            child: Text(
              text,
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
      isButtonDisabled = !isButtonDisabled;
    });
  }

  void reloadScreen(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text(
            widget.topicName,
            style: TextStyle(fontFamily: "aboshione", fontSize: 20, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialogShareTopic();
            },
            icon: Icon(Icons.menu, color: Colors.black),
          ),
          SizedBox(width: 10,),
        ],
        backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: FutureBuilder(
        future: hanldeDataWords(widget.topicName),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Center();
          }

          amountWord = snapshot.data![0].length;

          return Container(
            color: Colors.white,
            height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height - 30,
            width: MediaQuery.sizeOf(context).width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: AutoSizeText(
                            "Hoàn Thành ${(snapshot.data![1] as num).toInt()}",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Itim",
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                            group: textGroup, // Đồng bộ kích thước chữ
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: AutoSizeText(
                            "Chưa Hoàn Thành ${(snapshot.data![2] - snapshot.data![1] as num).toInt()}",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Itim",
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                            group: textGroup, // Đồng bộ kích thước chữ
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height - 180,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        children: snapshot.data![0].map<Widget>((word) {
                          return Center(
                            child: wordWidget(
                              topicName: widget.topicName,
                              wordText: wordModule.word(
                                  word["word"],
                                  word["wayread"],
                                  word["mean"],
                                  widget.topicName,
                                  word["level"]
                              ), reloadScreenListWord: () {
                                reloadScreen();
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTapDown: (event) {
                        setState(() {
                          isPressButton = true;
                        });
                      },
                      onTapUp: (event) {
                        setState(() {
                          isPressButton = false;
                        });

                        List<word> dataWords = [];
                        for (Map<String, dynamic> wordData in snapshot.data![0]) {
                          dataWords.add(
                            word(
                              wordData["word"],
                              wordData["wayread"],
                              wordData["mean"],
                              wordData["topic"],
                              wordData["level"],
                            ),
                          );
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => learnScreen(
                              dataWords: dataWords,
                              topic: widget.topicName,
                              reload: () {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                      onTapCancel: () {
                        setState(() {
                          isPressButton = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        transform: Matrix4.translationValues(0, isPressButton ? 4 : 0, 0),
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: MediaQuery.sizeOf(context).width * 0.13,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(19, 213, 47, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: isPressButton
                              ? [] // Khi nhấn, không có boxShadow
                              : [
                            BoxShadow(
                              color: Colors.green,
                              offset: Offset(5, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Học Từ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.sizeOf(context).height * 0.025,
                              fontFamily: "Itim",
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }
}