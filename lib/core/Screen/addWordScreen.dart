import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Module/word.dart';

import '../Service/Local/local_db_service.dart';
import '../Theme/colors.dart';
import '../Widget/addWordWidget.dart';
import '../generated/app_localizations.dart';

import 'package:http/http.dart' as http;


class addWordScreen extends StatefulWidget{
  final String topicName;
  final void Function() reload;
  final void Function() setIsLoad;

  const addWordScreen({super.key, required this.topicName, required this.reload, required this.setIsLoad});

  @override
  State<StatefulWidget> createState() => _addWordScreen();
}

class _addWordScreen extends State<addWordScreen>{

  TextEditingController japanWordInput = TextEditingController();
  TextEditingController readWayInput = TextEditingController();
  TextEditingController meanInput = TextEditingController();

  String? errorMessageJapan;
  String? errorMessageReadWay;
  String? errorMessageMean;

  List<word> listVocabulary = [];

  bool isLoading = false;

  /// Hiển thị popup chọn cách đọc, có thiết kế hiện đại với màu chủ đạo đỏ
  Future<String?> showReadingPickerDialog({
    required BuildContext context,
    required List<String> readings,
  }) async {
    int? selectedIndex;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Chọn cách đọc',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: readings.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedIndex == index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: isSelected ? Colors.red : Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                readings[index],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? AppColors.primary : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (selectedIndex != null) {
                              Navigator.of(context).pop(readings[selectedIndex!]);
                            }
                          },
                          child: const Text(
                            'Xác Nhận',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Huỷ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Future<void> generateWayRead(String kanji) async {
    final url = 'https://jisho.org/api/v1/search/words?keyword=$kanji';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if(!data["data"][0].containsKey("japanese")){
          readWayInput.text = kanji;
      }else{
        if(data["data"][0]["japanese"][0].length > 1){
          List<String>? listReadWays = [];
          for (var item in data["data"][0]["japanese"]) {
            if (item["reading"] != null) {
              listReadWays.add(item["reading"]);
            }
          }

          if(listReadWays.length == 2 && listReadWays[0] == listReadWays[1]){
            setState(() {
              readWayInput.text = listReadWays[0];
            });
          }else{
            String? resultChoseReading = await showReadingPickerDialog(context: context, readings: listReadWays);
            setState(() {
              readWayInput.text = resultChoseReading??"";
            });
          }
        }else{
          setState(() {
            readWayInput.text = data["data"][0]["japanese"][0]["reading"];
          });
        }
      }


    } else {
      throw Exception('Không tìm thấy thông tin cho kanji: $kanji');
    }
  }


  void showBottomSheetSaveData(BuildContext contextOrigin) {
    showModalBottomSheet(
      context: contextOrigin,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thanh kéo nhỏ
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Icon + Title
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFE21B3C), size: 50),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.addWord_bottomShet_warning_save_title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE21B3C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Content
              Text(
                AppLocalizations.of(context)!.addWord_bottomShet_warning_save_content,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE21B3C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () async {
                    try {
                      await saveData();
                      Navigator.of(context).pop(); // đóng bottom sheet
                      showBottomSheetSuccessSaveData(contextOrigin);
                    } catch (e) {
                      print("Lỗi: ${e.toString()}");
                    }
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    AppLocalizations.of(context)!.addWord_bottomShet_warning_save_btn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void showBottomSheetMinWordsRequired(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thanh kéo nhỏ
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Icon + Title
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.info_outline, color: Colors.orange, size: 50),
                  SizedBox(height: 10),
                  Text(
                    "Chưa đủ từ vựng!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Content
              const Text(
                "Bạn cần thêm ít nhất 5 từ vựng vào bộ này để có thể lưu.",
                style: TextStyle(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng bottom sheet
                  },
                  child: const Text(
                    "Đã hiểu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }


  void showBottomSheetSuccessSaveData(BuildContext contextOrigin) {
    showModalBottomSheet(
      context: contextOrigin,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thanh kéo
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Icon + Title
              Column(
                children: [
                  Icon(Icons.check_circle,
                      color: Color(0xFF4CAF50), size: 60),
                  SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.addWord_bottomShet_success_save_title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Content
              Text(
                AppLocalizations.of(context)!.addWord_bottomShet_success_save_content,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Save / Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // đóng bottom sheet
                    Navigator.pop(contextOrigin); // đóng màn addWord
                    widget.reload();
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: Text(
                    AppLocalizations.of(context)!.addWord_bottomShet_success_save_btn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }


  void deleteVocalary(word Vocabulary){
    setState(() {
      listVocabulary.remove(Vocabulary);
    });
  }

  Future<void> saveData() async {
    final db = LocalDbService.instance;
    List<Map<String, dynamic>> dataWords = [];

    for(word vocabulary in listVocabulary){
      dataWords.add(vocabulary.toMap());
    }

    await db.topicDao.insertTopic(widget.topicName, FirebaseAuth.instance.currentUser!.displayName!);
    await db.topicDao.insertDataTopic(dataWords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
          scrolledUnderElevation: 0,
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back)),
          title: Text(
            widget.topicName,
            style: const TextStyle(fontFamily: "Itim", fontSize: 30, color: AppColors.primary),
          ),
          actions: [
            IconButton(onPressed: (){
              if(listVocabulary.length <= 4){
                showBottomSheetMinWordsRequired(context);
              }else{
                showBottomSheetSaveData(context);
              }

            }, icon: const Icon(Icons.done), color: AppColors.primary,)
          ],
        ),

        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: AppColors.backgroundPrimary,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.sizeOf(context).width/1.1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      listVocabulary.length < 5 ?
                      '* Thêm tối thiếu là ${listVocabulary.length}/5 từ vựng'
                      : 'Đủ điều kiện tối thiểu 5 từ',
                      style: TextStyle(fontSize: 12, color: listVocabulary.length < 5 ? Colors.grey : Colors.green),
                    ),
                    SizedBox(height: 20,),
                    for(word vocabulary in listVocabulary)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: addWordWidget(context: context, word: vocabulary.vocabulary, wayRead: vocabulary.wayread, mean: vocabulary.mean, removeVocabulary: (){
                          deleteVocalary(vocabulary);
                        },),
                      ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 500,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, -2),
                                blurRadius: 5,
                                color: Colors.grey
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(AppLocalizations.of(context)!.addWord_Screen_Input_Japan_Label, style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Itim",
                                fontSize: 20,
                                height: 1,
                                color: AppColors.textSecond.withOpacity(0.6)
                            ),),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20, top:10, right: 20,),
                            width: MediaQuery.sizeOf(context).width/1.1,
                            height: 100,
                            child: TextField(
                              controller: japanWordInput,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.addWord_Screen_Input_Japan_Hint,
                                  hintStyle: TextStyle(color: Colors.grey), // Màu chữ gợi ý
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 20.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorText: errorMessageJapan
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(AppLocalizations.of(context)!.addWord_Screen_Input_WayRead_Label, style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Itim",
                                fontSize: 20,
                                height: 1,
                                color: AppColors.textSecond.withOpacity(0.6)
                            ),),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded( // Đây là phần quan trọng!
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
                                    height: 100,
                                    child: TextField(
                                      controller: readWayInput,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.addWord_Screen_Input_WayRead_Hint,
                                        hintStyle: TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.red, width: 3.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        errorText: errorMessageReadWay,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if(japanWordInput.text.trim().replaceAll(" ", "") != "") {
                                      await generateWayRead(japanWordInput.text);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20 , right: 10),
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Icon(Icons.create, color: Colors.white,),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(AppLocalizations.of(context)!.addWord_Screen_Input_Mean_Label, style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Itim",
                                fontSize: 20,
                                height: 1,
                                color: AppColors.textSecond.withOpacity(0.6)
                            ),),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20, top:10, right: 20,),
                            width: MediaQuery.sizeOf(context).width,
                            height: 100,
                            child: TextField(
                              controller: meanInput,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.addWord_Screen_Input_Mean_Hint,
                                  hintStyle: TextStyle(color: Colors.grey), // Màu chữ gợi ý
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 20.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorText: errorMessageMean
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    String japanVocabulary = japanWordInput.text;
                                    String readWayVocabulary = readWayInput.text;
                                    String meanVocabulary = meanInput.text;

                                    bool canAdd = true;

                                    if(japanVocabulary.isEmpty ||  japanVocabulary == ""){
                                      setState(() {
                                        errorMessageJapan = "Không được phép rỗng";
                                      });
                                    }else if(readWayVocabulary.isEmpty ||  readWayVocabulary == ""){
                                      setState(() {
                                        errorMessageReadWay = "Không được phép rỗng";
                                      });
                                    }else if(meanVocabulary.isEmpty ||  meanVocabulary == ""){
                                      setState(() {
                                        errorMessageMean = "Không được phép rỗng";
                                      });
                                    }else{
                                      for(word vocabulary in listVocabulary){
                                        if(vocabulary.vocabulary == japanVocabulary && vocabulary.mean == meanVocabulary){
                                          setState(() {
                                            errorMessageJapan = "Từ này đã tồn tại";
                                            canAdd = false;
                                          });
                                        }
                                      }

                                      if(canAdd){
                                        setState(() {
                                          listVocabulary.add(
                                              word(japanVocabulary, readWayVocabulary, meanVocabulary, widget.topicName, 0)
                                          );
                                          japanWordInput.clear();
                                          readWayInput.clear();
                                          meanInput.clear();
                                          errorMessageJapan = null;
                                        });
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: 150,
                                      height: 60,
                                      // Chiều cao thực của Container
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                      ),
                                      child: Center(
                                          child: Text(AppLocalizations.of(context)!.addWord_Screen_btn_add, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50,)
                  ],

                ),
              )
          )
        )

    );
  }

}