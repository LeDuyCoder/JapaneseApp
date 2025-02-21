import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/word.dart';
import 'package:japaneseapp/Widget/addWordWidget.dart';

class addWordScreen extends StatefulWidget{
  final String topicName;
  final void Function() reload;
  final void Function() setIsLoad;

  const addWordScreen({super.key, required this.topicName, required, required this.setIsLoad, required this.reload});

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

  void showDialogSaveData(BuildContext contextOrigin){
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Waring Store Data ⚠️',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Stored, can\'t edit',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 32, 32, 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await saveData(); // Đợi hàm saveData hoàn thành
                                    showDialogSuccessSaveData(contextOrigin); // Hiển thị dialog sau khi lưu xong
                                  } catch (e) {
                                    print("Lỗi test: ${e.toString()}");
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(184, 241, 176, 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Save",
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
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
  void showDialogSuccessSaveData(BuildContext contextOrigin){
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Successfully Save ✔️',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Save data vocabulay success',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(contextOrigin);
                                  Navigator.pop(contextOrigin);
                                  Navigator.pop(contextOrigin);
                                  widget.reload();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(184, 241, 176, 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Save",
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
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

    await db.insertTopic(widget.topicName);
    await db.insertDataTopic(dataWords);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              leading: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: const Icon(Icons.arrow_back)),
              title: Text(
                widget.topicName,
                style: TextStyle(fontFamily: "aboshione", fontSize: 20, color: Colors.white),
              ),
              actions: [
                IconButton(onPressed: (){
                  showDialogSaveData(context);
                }, icon: Icon(Icons.save), color: Colors.black,)
              ],
              backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
            ),

            body: Stack(
              children: [
                Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: double.infinity,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: listVocabulary.isEmpty ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text("No Vocabulary", style: TextStyle(fontFamily: "indieflower", fontSize: 25),),
                          )
                      ): Column(
                        children: [
                          const SizedBox(height: 20,),
                          for(word vocabulary in listVocabulary)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: addWordWidget(context: context, word: vocabulary.vocabulary, wayRead: vocabulary.wayread, mean: vocabulary.mean, removeVocabulary: (){
                                deleteVocalary(vocabulary);
                              },),
                            ),
                          SizedBox(height: 200,),
                        ],
                      ),
                    )
                ),
                //nagivator
                Container(
                  height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(40)
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, -4),
                                blurRadius: 20,
                                color: Colors.grey
                            )
                          ]
                      ),
                      height: 200,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 10, top: 16),
                                width: MediaQuery.sizeOf(context).width/2,
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
                              Container(
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 16),
                                width: MediaQuery.sizeOf(context).width/2,
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
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 10),
                                width: MediaQuery.sizeOf(context).width-100,
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
                                child: SizedBox(
                                    height: 100, // Giảm chiều cao của SizedBox
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Container(
                                            width: 70,
                                            height: 70,
                                            // Chiều cao thực của Container
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(184, 241, 176, 1),
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: Center(
                                              child: Icon(Icons.download_done),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )


        ),
        if(isLoading)
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: double.infinity,
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            child: Center(
              child: CircularProgressIndicator(color: Colors.green,),
            ),
          )
      ],
    );
  }

}