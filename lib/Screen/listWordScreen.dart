import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Module/WordModule.dart';
import 'package:japaneseapp/Module/topic.dart';
import 'package:japaneseapp/Module/word.dart';
import 'package:japaneseapp/Screen/learnScreen.dart';
import 'package:japaneseapp/Theme/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../Service/Local/local_db_service.dart';
import '../Service/Server/ServiceLocator.dart';
import '../Widget/FlashCardWidget.dart';
import '../generated/app_localizations.dart';

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

    final db = LocalDbService.instance;
    List<Map<String, dynamic>> dataWords = await db.topicDao.getAllWordbyTopic(topic);

    if(dataWords.isNotEmpty) {
      for (Map<String, dynamic> word in dataWords) {
        sumComplitted += word['level'] as int;
      }
    }

    return dataWords.isNotEmpty ? sumComplitted / (28*dataWords.length) : 0;
  }

  Future<List<dynamic>> hanldeDataWords(String topic) async {
    final db = LocalDbService.instance;
    List<Map<String, dynamic>> dataWords = await db.topicDao.getAllWordbyTopic(topic);
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
      await Share.shareXFiles([XFile(filePath)], text: 'Check out my custom file!');
    } catch (e) {
      print('Error sharing file: $e');
    }
  }

  Future<String> hanldDataWordsQr(String topic) async {
    String idTopic = "";
    String nameTopic = "";
    String user = "";

    final db = LocalDbService.instance;
    List<Map<String, dynamic>> dataWords = await db.topicDao.getAllWordbyTopic(topic);
    List<Map<String, dynamic>> dataTopics = await db.topicDao.getAllTopics();
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
            borderRadius: BorderRadius.all(Radius.circular(20)) // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                  child: Container(
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/character/character6.png", width: MediaQuery.sizeOf(context).width*0.3,),
                        Column(
                          children: [
                            SizedBox(height: 20),
                            AutoSizeText(
                              "Xóa chủ đề",
                              style: TextStyle(fontFamily: "Itim", fontSize: 25),
                            ),

                            AutoSizeText(
                              "Bạn có muốn xóa không",
                              style: TextStyle(fontFamily: "Itim", color: AppColors.textSecond.withOpacity(0.8)),
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
                                width: MediaQuery.sizeOf(context).width*0.3,
                                height: MediaQuery.sizeOf(context).height*0.05,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                    ]
                                ),
                                child: const Center(
                                  child: Text("Cancle", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
                                ),
                              ),

                            ),
                            SizedBox(width:10,),
                            GestureDetector(
                              onTap: () async {
                                final db = LocalDbService.instance;
                                db.databseDao.deleteData("topic", "name = '${widget.topicName}'");
                                db.databseDao.deleteData("words", "topic = '${widget.topicName}'");
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                widget.reloadDashboard();
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.3,
                                height: MediaQuery.sizeOf(context).height * 0.05,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Delete",
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

  void showBottomSheetPulic(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // để custom full UI
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.7,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // thanh nhỏ drag indicator
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // hình nhân vật
                    Image.asset(
                      "assets/character/character6.png",
                      width: MediaQuery.sizeOf(context).width * 0.3,
                    ),
                    const SizedBox(height: 20),

                    // nội dung text
                    Text(
                      AppLocalizations.of(context)!.listword_Screen_bottomSheet_public_title,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Itim",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.listword_Screen_bottomSheet_public_content,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Itim",
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),

                    // nút bấm
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              await pulicTopic();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.listword_Screen_bottomSheet_public_btn_pulic,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.listword_Screen_bottomSheet_public_btn_cancel,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showBottomSheetPrivate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // để bo góc full
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.35,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // drag indicator
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // hình minh họa
                    Image.asset(
                      "assets/character/character6.png",
                      width: MediaQuery.sizeOf(context).width * 0.3,
                    ),
                    const SizedBox(height: 20),

                    // nội dung
                    Text(
                        AppLocalizations.of(context)!.listword_Screen_bottomSheet_private_title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Itim",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),

                    // nút lựa chọn
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              await priveTopic();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.listword_Screen_bottomSheet_private_btn_private,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.listword_Screen_bottomSheet_private_btn_cancel,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showBottomSheetPulicSuccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag indicator
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // icon / ảnh minh họa
              const Icon(Icons.check_circle,
                  color: Color(0xFF4CAF50), size: 60),
              const SizedBox(height: 20),

              // text success
              Text(
                AppLocalizations.of(context)!.listword_Screen_bottomSheet_public_succes_title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Itim",
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context)!.listword_Screen_bottomSheet_public_succes_content,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Itim",
                  color: AppColors.textSecond.withOpacity(0.6)
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // nút OK
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.listword_Screen_bottomSheet_public_succes_btn_ok,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showBottomSheetPrivateSuccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag indicator
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // hình minh họa
              Icon(Icons.check_circle,
                  color: AppColors.primary, size: 60),
              const SizedBox(height: 20),

              // text success
              Text(
                AppLocalizations.of(context)!.listword_Screen_bottomSheet_private_success_title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Itim",
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                AppLocalizations.of(context)!.listword_Screen_bottomSheet_private_success_content,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecond.withOpacity(0.6),
                  fontFamily: "Itim",
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // nút OK
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    reloadScreen();
                  },
                  child: Text(
                      AppLocalizations.of(context)!.listword_Screen_bottomSheet_private_success_OK,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> isOwner() async{
    final db = LocalDbService.instance;
    owner = (await db.topicDao.getTopicByID(widget.id))?["user"]??"Nah";
  }

  Future<topic?> isExistTopic() async{
    await isOwner();
    topic? isTopic = await ServiceLocator.topicService.getDataTopicByID(widget.id).timeout(Duration(seconds: 10));
    return isTopic;
  }

  Future<void> pulicTopic() async{
    final db = LocalDbService.instance;
    List<Map<String, dynamic>> data = await db.topicDao.getAllWordbyTopic(widget.topicName);
    User user = FirebaseAuth.instance.currentUser!;

    topic TopicPulic = new topic(id: widget.id, name: widget.topicName, owner: user.providerData[0].displayName, count: 0);
    await ServiceLocator.topicService.insertTopic(TopicPulic);

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

    bool execInsert = await ServiceLocator.wordService.insertDataWord(listWordPulics);
    if(execInsert){
      print("Kiểm Tra");
      Navigator.pop(context);
      showBottomSheetPulicSuccess(context);
      reloadScreen();

    }else{
      print("Error");
    }


  }

  Future<void> priveTopic() async{
    ServiceLocator.topicService.deleteTopic(widget.id);
    reloadScreen();
    showBottomSheetPrivateSuccess(context);
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
                    AppLocalizations.of(context)!.listword_Screen_head_col1,
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
                    AppLocalizations.of(context)!.listword_Screen_head_col2,
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
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.listword_Screen_head_col3,
                      style: TextStyle(
                        color: AppColors.textSecond.withOpacity(0.5),
                        fontSize: 18,
                        fontFamily: "Itim",
                        fontWeight: FontWeight.bold,
                      ),
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
                          ? Text(
                        AppLocalizations.of(context)!.listword_Screen_Learned,
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
          child: Text(
            AppLocalizations.of(context)!.listword_Screen_title,
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
                  showBottomSheetPrivate(context);
                }, icon: Icon(Icons.public_sharp, color: AppColors.primary,));
              }

              return IconButton(onPressed: (){
                showBottomSheetPulic(context);
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
                    Text("${snapshot.data![0].length} ${AppLocalizations.of(context)!.listword_Screen_AmountWord}", style: TextStyle(color: AppColors.textSecond.withOpacity(0.5), fontSize: 18, fontFamily: "Itim"),),
                    SizedBox(width: 30,),
                    Text("${amountComplited} ${AppLocalizations.of(context)!.listword_Screen_Learned}", style: TextStyle(color: AppColors.textSecond.withOpacity(0.5), fontSize: 18, fontFamily: "Itim"),)
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
                    Row(
                      children: [
                        SizedBox(width: 20,),
                        Icon(Icons.play_arrow, color: AppColors.white, size: 25,),
                        SizedBox(width: 10,),
                        Text(AppLocalizations.of(context)!.listword_Screen_btn_learn, style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),)
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
    );
  }
}