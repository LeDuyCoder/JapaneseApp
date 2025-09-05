import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:japaneseapp/Module/word.dart';

import '../Config/dataHelper.dart';
import '../Theme/colors.dart';
import '../Widget/addWordWidget.dart';


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
                  const Text(
                    "Cảnh Báo",
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
              const Text(
                "Khi lưu không thể chỉnh sữa",
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
                  label: const Text(
                    "Save",
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
                children: const [
                  Icon(Icons.check_circle,
                      color: Color(0xFF4CAF50), size: 60),
                  SizedBox(width: 10),
                  Text(
                    "Lưu Thành Công",
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
              const Text(
                "Chủ đề bạn tạo đã được tạo thành công 🎉",
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
                  label: const Text(
                    "OK",
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
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataWords = [];

    for(word vocabulary in listVocabulary){
      dataWords.add(vocabulary.toMap());
    }

    await db.insertTopic(widget.topicName, FirebaseAuth.instance.currentUser!.displayName!);
    await db.insertDataTopic(dataWords);
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
              showBottomSheetSaveData(context);
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
                            child: Text("Từ vựng tiếng nhật", style: TextStyle(
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
                                  hintText: "Japnaese Word",
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
                            child: Text("Cách đọc (Hiragana)", style: TextStyle(
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
                              controller: readWayInput,
                              decoration: InputDecoration(
                                  hintText: "Read Way",
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
                                  errorText: errorMessageReadWay
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text("Nghĩa của từ", style: TextStyle(
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
                                  hintText: "Mean",
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
                                        errorMessageJapan = "Not empty";
                                      });
                                    }else if(readWayVocabulary.isEmpty ||  readWayVocabulary == ""){
                                      setState(() {
                                        errorMessageReadWay = "Not empty";
                                      });
                                    }else if(meanVocabulary.isEmpty ||  meanVocabulary == ""){
                                      setState(() {
                                        errorMessageMean = "Not empty";
                                      });
                                    }else{
                                      for(word vocabulary in listVocabulary){
                                        if(vocabulary.vocabulary == japanVocabulary && vocabulary.mean == meanVocabulary){
                                          setState(() {
                                            errorMessageJapan = "word has exist";
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
                                          child: Text("Thêm Từ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
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
    //   Stack(
    //   children: [
    //
    //     if(isLoading)
    //
    //       Container(
    //         width: MediaQuery.sizeOf(context).width,
    //         height: double.infinity,
    //         color: const Color.fromRGBO(0, 0, 0, 0.1),
    //         child: const Center(
    //           child: CircularProgressIndicator(color: Colors.green,),
    //         ),
    //       )
    //   ],
    // );
  }

}