import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/WordModule.dart';
import 'package:japaneseapp/Module/topic.dart';
import 'package:japaneseapp/Module/word.dart';
import 'package:japaneseapp/Screen/learnScreen.dart';
import 'package:japaneseapp/Theme/colors.dart';
import 'package:japaneseapp/Widget/wordWidget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:japaneseapp/Module/word.dart' as wordModule;

import '../Config/databaseServer.dart';
import '../Widget/FlashCardWidget.dart';
import '../generated/app_localizations.dart';
import '../Widget/wordWidget.dart' as wd;

class listWordScreen extends StatefulWidget{
  final String topicName;
  final String id;
  final void Function() reloadDashboard;

  const listWordScreen({super.key, required this.topicName, required this.reloadDashboard, required this.id});
  @override
  State<StatefulWidget> createState() => _listWordScreen();
}

class _listWordScreen extends State<listWordScreen>{
  bool isButtonDisabled = true;
  bool isPressButton = false;
  String owner = "";
  AutoSizeGroup textGroup = AutoSizeGroup();
  int amountWord = 0;


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
    String user = "";

    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataWords = await db.getAllWordbyTopic(topic);
    List<Map<String, dynamic>> dataTopics = await db.getAllTopic();
    for(Map<String, dynamic> dataTopic in dataTopics){
      if(dataTopic["name"] == topic){
        idTopic = dataTopic["id"];
        nameTopic = dataTopic["name"];
        user = dataTopic["user"];
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
          "user": user,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.18),
                      blurRadius: 28,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(16),
                      child: Icon(Icons.share, color: Colors.blueAccent, size: 44),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.listWord_share_title(widget.topicName),
                      style: TextStyle(
                        fontFamily: "Itim",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.listWord_share_amount_word("$amountWord"),
                      style: TextStyle(
                        fontFamily: "Itim",
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            color: Colors.blue[700],
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context)!.listWord_share_type("Share File"),
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: showDialogDelete,
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            label: Text(
                              AppLocalizations.of(context)!.listWord_btn_remove,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: "Itim",
                                letterSpacing: 0.2,
                                color: Colors.red,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(color: Colors.red, width: 2),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final data = await hanldDataWordsQr(widget.topicName);
                              String path = await saveCustomFile("${widget.topicName}.jpdb", data);
                              shareFile(path);
                            },
                            icon: Icon(Icons.send, color: Colors.white),
                            label: Text(
                              AppLocalizations.of(context)!.listWord_btn_shared,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Itim",
                                letterSpacing: 0.2,
                                color: Colors.white
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                          ),
                        ),
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

  void showDialogPulic() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5), // Màu nền tối mờ
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox(); // Trả về rỗng vì dùng transitionBuilder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);

        return Transform.translate(
          offset: Offset(0, -300 + (300 * curvedValue)),
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, setState) {
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
                                    "Bạn có muốn chia sẽ không",
                                    style: TextStyle(fontFamily: "indieflower", fontSize: 15),
                                  ),

                                  AutoSizeText(
                                    "Khi chia sẽ ai cũng có thể tải",
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
                                      await pulicTopic();
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
                                        child: Text("Công Khai", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
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
              ),
            ),
          ),
        );
      },
    );
  }
  void showDialogPrivate() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5), // Màu nền tối mờ
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox(); // Trả về rỗng vì dùng transitionBuilder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);

        return Transform.translate(
          offset: Offset(0, -300 + (300 * curvedValue)),
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color.fromRGBO(195, 20, 35, 1.0), // Màu xanh cạnh trên ngoài cùng
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
                                    "Bạn có muốn hủy chia sẽ không",
                                    style: TextStyle(fontFamily: "indieflower", fontSize: 15),
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
                                      await priveTopic();
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
                                        child: Text("Hủy", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
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
                                          "Không",
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
              ),
            ),
          ),
        );
      },
    );
  }
  void showDialogPulicSuccess() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5), // Màu nền tối mờ
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox(); // Trả về rỗng vì dùng transitionBuilder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);

        return Transform.translate(
          offset: Offset(0, -300 + (300 * curvedValue)),
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, setState) {
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
                                    "Công Khai Thành Công",
                                    style: TextStyle(fontFamily: "indieflower", fontSize: 15),
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
                                          "OK",
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
              ),
            ),
          ),
        );
      },
    );
  }
  void showDialogPrivateSuccess() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5), // Màu nền tối mờ
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox(); // Trả về rỗng vì dùng transitionBuilder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);

        return Transform.translate(
          offset: Offset(0, -300 + (300 * curvedValue)),
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color.fromRGBO(195, 20, 20, 1.0), // Màu xanh cạnh trên ngoài cùng
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
                                    "Hủy Công Khai Thành Công",
                                    style: TextStyle(fontFamily: "indieflower", fontSize: 15),
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
                                          "OK",
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
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> isOwner() async{
    DatabaseHelper db = DatabaseHelper.instance;
    owner = (await db.getTopicByID(widget.id))["user"];
  }

  Future<topic?> isExistTopic() async{
    DatabaseServer db = new DatabaseServer();
    await isOwner();
    topic? isTopic = await db.getDataTopicbyID(widget.id).timeout(Duration(seconds: 10));
    return isTopic;
  }

  Future<void> pulicTopic() async{
    DatabaseHelper db = DatabaseHelper.instance;
    DatabaseServer dbServer = new DatabaseServer();
    List<Map<String, dynamic>> data = await db.getAllWordbyTopic(widget.topicName);
    User user = FirebaseAuth.instance.currentUser!;



    topic TopicPulic = new topic(id: widget.id, name: widget.topicName, owner: user.providerData[0].displayName, count: 0);
    await dbServer.insertTopic(TopicPulic);

    List<Word> listWordPulics = [];
    for(Map<String, dynamic> word in data){
      listWordPulics.add(new Word(
          word: word["word"],
          mean: word["mean"],
          wayread: word["wayread"],
          level: 0,
          topicID: widget.id
      ));
    }

    bool execInsert = await dbServer.insertDataWord(listWordPulics);
    if(execInsert){
      print("Kiểm Tra");
      Navigator.pop(context);
      reloadScreen();
      showDialogPulicSuccess();
    }else{
      print("Error");
    }


  }

  Future<void> priveTopic() async{
    DatabaseHelper db = DatabaseHelper.instance;
    DatabaseServer dbServer = new DatabaseServer();
    dbServer.deleteTopic(widget.id);
    Navigator.pop(context);
    reloadScreen();
    showDialogPrivateSuccess();
  }

  void showFlashCardDialog(BuildContext context, String word, String mean, String wayread) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: FlashCardWidget(word: word, mean: mean, wayread: wayread,),
        );
      },
    );
  }

  Widget wordWidget(List<dynamic> listWord) {
    return Column(
      children: [
        Table(
          border: const TableBorder(
            horizontalInside: BorderSide(width: 1, color: Colors.grey), // gạch ngang giữa các hàng
          ),
          columnWidths: const {
            0: FlexColumnWidth(1.8), // cột 1 rộng hơn
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1.1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Tiếng Nhật",
                    style: TextStyle(
                      color: AppColors.textSecond.withOpacity(0.5),
                      fontSize: 18,
                      fontFamily: "Itim",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Nghĩa",
                    style: TextStyle(
                      color: AppColors.textSecond.withOpacity(0.5),
                      fontSize: 18,
                      fontFamily: "Itim",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Trạng Thái",
                    style: TextStyle(
                      color: AppColors.textSecond.withOpacity(0.5),
                      fontSize: 18,
                      fontFamily: "Itim",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Body
            for (dynamic wordItem in listWord[0])
              TableRow(
                children: [
                  InkWell(
                    onTap: () {
                      showFlashCardDialog(context, wordItem["word"], wordItem["mean"], wordItem["wayread"]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${wordItem["word"]}",
                            style: const TextStyle(
                              color: AppColors.textSecond,
                              fontSize: 18,
                              fontFamily: "Itim",
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "${wordItem["wayread"]}",
                            style: const TextStyle(
                              color: AppColors.textSecond,
                              fontSize: 18,
                              fontFamily: "Itim",
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      showFlashCardDialog(context, wordItem["word"], wordItem["mean"], wordItem["wayread"]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        wordItem["mean"],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: AppColors.textSecond,
                          fontSize: 18,
                          fontFamily: "Itim",
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      showFlashCardDialog(context, wordItem["word"], wordItem["mean"], wordItem["wayread"]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: (wordItem["level"] / 2) >= 100.0
                          ? const Text(
                        "Hoàn Thành",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSucessState),
                      )
                          : Text(
                        "${(wordItem["level"] / 2)}%",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecond,
                          fontSize: 18,
                          fontFamily: "Itim",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        )

      ],
    );
  }

  Widget wordWidgetLoading() {
    return Column(
      children: [
        Table(
          border: TableBorder(
            horizontalInside: BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)), // gạch ngang giữa các hàng
          ),
          columnWidths: const {
            0: FlexColumnWidth(1.8), // cột 1 rộng hơn
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1.1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header
            TableRow(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ],
            ),

            // Body

            TableRow(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ],
            ),
          ],
        )

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        title: Container(
          child: const Text(
            "Chủ Đề",
            style: TextStyle(fontFamily: "Itim", fontSize: 35, color: AppColors.primary),
          ),
        ),
        centerTitle: true,
        actions: [
          FutureBuilder(future: isExistTopic(), builder: (context, topic){
            if(topic.connectionState == ConnectionState.waiting){
              return Container();
            }
            

            if(owner == FirebaseAuth.instance.currentUser!.displayName){
              if(topic.hasData){;
                return IconButton(onPressed: (){
                  showDialogPrivate();
                }, icon: Icon(Icons.public_sharp, color: AppColors.primary,));
              }

              return IconButton(onPressed: (){
                showDialogPulic();
              }, icon: Icon(Icons.public_sharp, color: Colors.grey,));
            }else{
              return Container();
            }
          }),
          IconButton(
            onPressed: () {
              showDialogShareTopic();
            },
            icon: Icon(Icons.menu, color: Colors.black),
          ),
          SizedBox(width: 10,),
        ],
      ),
      body: FutureBuilder(future: hanldeDataWords(widget.topicName), builder: (ctx, snapshot){


        if(snapshot.connectionState == ConnectionState.waiting){
          return Container(
            width: MediaQuery.sizeOf(context).width,
            color: AppColors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    SizedBox(width: 30,),
                    Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Container(
                  margin:  const EdgeInsets.only(left: 40, right: 30),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height / 1.8,
                    ),
                    child: SingleChildScrollView(
                      child: wordWidgetLoading(), // table hoặc column của bạn
                    ),
                  ),
                ),
                SizedBox(height: 60,),
                GestureDetector(
                  child: Container(
                    width:MediaQuery.sizeOf(context).width/1.3,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(40)
                    ),
                  ),
                )
              ],
            ),
          );
        }

        if(snapshot.hasData){

          amountWord = snapshot.data![0].length;
          int amountComplited = 0;
          for(dynamic itemWord in snapshot.data![0]){
            if(itemWord["level"] >= 27){
              amountComplited++;
            }
          }

          return Container(
            width: MediaQuery.sizeOf(context).width,
            color: AppColors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(widget.topicName, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Item"),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${snapshot.data![0].length} từ vựng", style: TextStyle(color: AppColors.textSecond.withOpacity(0.5), fontSize: 18, fontFamily: "Itim"),),
                    SizedBox(width: 30,),
                    Text("${amountComplited} đã thuộc", style: TextStyle(color: AppColors.textSecond.withOpacity(0.5), fontSize: 18, fontFamily: "Itim"),)
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  margin:  EdgeInsets.only(left: 40, right: 30),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height / 1.8,
                    ),
                    child: SingleChildScrollView(
                      child: wordWidget(snapshot.data!), // table hoặc column của bạn
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
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
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child:
                    const Row(
                      children: [
                        SizedBox(width: 20,),
                        Icon(Icons.play_arrow, color: AppColors.white, size: 25,),
                        SizedBox(width: 10,),
                        Text("Học Ngay", style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }

        return Container();
      })
      // body: FutureBuilder(
      //   future: hanldeDataWords(widget.topicName),
      //   builder: (ctx, snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center();
      //     }
      //
      //     amountWord = snapshot.data![0].length;
      //
      //     return Container(
      //       color: Colors.white,
      //       height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height - 30,
      //       width: MediaQuery.sizeOf(context).width,
      //       child: SingleChildScrollView(
      //         scrollDirection: Axis.vertical,
      //         child: Column(
      //           children: [
      //             SizedBox(height: 10,),
      //             Container(
      //               width: MediaQuery.sizeOf(context).width,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Flexible(
      //                     child: AutoSizeText(
      //                       AppLocalizations.of(context)!.listWord_word_complete("${(snapshot.data![1] as num).toInt()}"),
      //                       style: const TextStyle(
      //                         fontSize: 20,
      //                         fontFamily: "Itim",
      //                         color: Colors.green,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                       minFontSize: 10,
      //                       maxLines: 1,
      //                       group: textGroup, // Đồng bộ kích thước chữ
      //                     ),
      //                   ),
      //                   SizedBox(width: 10),
      //                   Flexible(
      //                     child: AutoSizeText(
      //                       AppLocalizations.of(context)!.listWord_word_learning("${(snapshot.data![2] - snapshot.data![1] as num).toInt()}"),
      //                       style: const TextStyle(
      //                         fontSize: 20,
      //                         fontFamily: "Itim",
      //                         color: Colors.red,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                       minFontSize: 10,
      //                       maxLines: 1,
      //                       group: textGroup, // Đồng bộ kích thước chữ
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(height: 10,),
      //             Container(
      //               height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height - 180,
      //               padding: EdgeInsets.symmetric(horizontal: 10),
      //               child: SingleChildScrollView(
      //                 scrollDirection: Axis.vertical,
      //                 child: GridView.count(
      //                   shrinkWrap: true,
      //                   physics: NeverScrollableScrollPhysics(),
      //                   crossAxisSpacing: 10,
      //                   mainAxisSpacing: 10,
      //                   crossAxisCount: 3,
      //                   childAspectRatio: 1,
      //                   children: snapshot.data![0].map<Widget>((word) {
      //                     return Center(
      //                       child: wd.wordWidget(
      //                         topicName: widget.topicName,
      //                         wordText: wordModule.word(
      //                             word["word"],
      //                             word["wayread"],
      //                             word["mean"],
      //                             widget.topicName,
      //                             word["level"]
      //                         ), reloadScreenListWord: () {
      //                           reloadScreen();
      //                         },
      //                       ),
      //                     );
      //                   }).toList(),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(height: 10),
      //             Align(
      //               alignment: Alignment.bottomCenter,
      //               child: GestureDetector(
      //                 onTapDown: (event) {
      //                   setState(() {
      //                     isPressButton = true;
      //                   });
      //                 },
      //                 onTapUp: (event) {
      //                   setState(() {
      //                     isPressButton = false;
      //                   });
      //
      //                   List<word> dataWords = [];
      //                   for (Map<String, dynamic> wordData in snapshot.data![0]) {
      //                     dataWords.add(
      //                       word(
      //                         wordData["word"],
      //                         wordData["wayread"],
      //                         wordData["mean"],
      //                         wordData["topic"],
      //                         wordData["level"],
      //                       ),
      //                     );
      //                   }
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (ctx) => learnScreen(
      //                         dataWords: dataWords,
      //                         topic: widget.topicName,
      //                         reload: () {
      //                           setState(() {});
      //                         },
      //                       ),
      //                     ),
      //                   );
      //                 },
      //                 onTapCancel: () {
      //                   setState(() {
      //                     isPressButton = false;
      //                   });
      //                 },
      //                 child: AnimatedContainer(
      //                   duration: Duration(milliseconds: 100),
      //                   curve: Curves.easeInOut,
      //                   transform: Matrix4.translationValues(0, isPressButton ? 4 : 0, 0),
      //                   width: MediaQuery.sizeOf(context).width * 0.8,
      //                   height: MediaQuery.sizeOf(context).width * 0.13,
      //                   decoration: BoxDecoration(
      //                     color: Color.fromRGBO(97, 213, 88, 1.0),
      //                     borderRadius: BorderRadius.all(Radius.circular(20)),
      //                     boxShadow: isPressButton
      //                         ? [] // Khi nhấn, không có boxShadow
      //                         : [
      //                       BoxShadow(
      //                         color: Colors.green,
      //                         offset: Offset(5, 6),
      //                       ),
      //                     ],
      //                   ),
      //                   child: Center(
      //                     child: Text(
      //                       AppLocalizations.of(context)!.listWord_btn_learn,
      //                       style: TextStyle(
      //                         color: Colors.white,
      //                         fontSize: MediaQuery.sizeOf(context).height * 0.025,
      //                         fontFamily: "Itim",
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               )
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // )
    );
  }
}