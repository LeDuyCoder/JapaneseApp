import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Screen/qrScreen.dart';
import 'package:japaneseapp/Screen/serchWordScreen.dart';
import 'package:japaneseapp/Widget/folerWidget.dart';

import '../Config/dataHelper.dart';
import '../Module/word.dart';
import '../Widget/topicWidget.dart';

class dashboardScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _dashboardScreen();

}

class _dashboardScreen extends State<dashboardScreen>{

  Map<String, List<Map<String, dynamic>>> dataDashBoards = {};
  TextEditingController nameFolderInput = TextEditingController();
  TextEditingController nameTopicInput = TextEditingController();
  TextEditingController searchWord = TextEditingController();
  String? textErrorName;
  bool isLoadingCreateNewFolder = false;
  String amountTopic = "0 Topic";
  String? _fileContent;


  Future<Map<String, List<Map<String, dynamic>>>> hanldeGetData() async {
    final db = await DatabaseHelper.instance;
    Map<String, List<Map<String, dynamic>>> data = {
      "topic": await db.getAllTopic(),
      "folder": await db.getAllFolder()
    };

    return data;
  }

  Future<void> reload() async {
    await Future.delayed(Duration(seconds: 2));
    dataDashBoards = await hanldeGetData();
    setState(() {});
  }

  void showDialogSuccessSaveData() {
    showGeneralDialog(
      barrierDismissible: true,
      context: context,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 500), // Thời gian animation
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(20, 195, 142, 1.0),
                      width: 10.0,
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
                            'Save data vocabulary success',
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
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  reload();
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
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, -1.0);  // Vị trí ban đầu (ngoài màn hình, trên cùng)
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showDialogErrorSaveData(){
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
                      color: Colors.red, // Màu xanh cạnh trên ngoài cùng
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
                            'Successfully Failse ❌',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Save data vocabulay failed becausse it is created',
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
                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "ok",
                                        style: TextStyle(color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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

  void showDialogDataFromQR(Map<String, dynamic> data){
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
                        const Center(
                          child: Text("List Word Shared", style: TextStyle(fontFamily: "indieflower", fontSize: 25)),
                        ),
                        Row(
                          children: [
                            const Text("Device's Name: ", style: TextStyle(fontFamily: "indieflower"),),
                            Text((data["id"] as String).split("-").last, style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Amount word: ", style: TextStyle(fontFamily: "indieflower"),),
                            Text("${(data["listWords"] as List<dynamic>).length} Words", style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),)
                          ],
                        ),
                        const SizedBox(height: 10,),
                        const Text("Do You Add List Word ?", style: TextStyle(fontFamily: "indieflower"),),
                        const SizedBox(height: 20,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
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
                                child: Center(
                                  child: Text("CANCLE", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            SizedBox(width:10,),
                            GestureDetector(
                              onTap: () async {
                                DatabaseHelper db = DatabaseHelper.instance;
                                String nameTopic = "${data["name"]} - ${(data["id"] as String).split("-").last}";

                                if(!(await db.hasTopicName(nameTopic))) {
                                  await db.insertTopic(nameTopic);

                                  List<dynamic> listWords = data["listWords"];
                                  List<Map<String, dynamic>> dataInsert = [];
                                  for (dynamic data in listWords) {
                                    dataInsert.add(
                                        word(data["word"], data["wayread"],
                                            data["mean"], nameTopic, 0).toMap()
                                    );
                                  }
                                  await db.insertDataTopic(dataInsert);
                                  showDialogSuccessSaveData();
                                }else{
                                  showDialogErrorSaveData();
                                }
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width*0.3,
                                height: MediaQuery.sizeOf(context).height*0.05,
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(97, 213, 88, 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.green,
                                          offset: Offset(6, 6)
                                      )
                                    ]
                                ),
                                child: Center(
                                  child: Text("CONFIRM", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            SizedBox(width:10,),
                          ],
                        ),
                        SizedBox(height: 20,),
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

  Future<void> _pickFile() async {
    try {
      // Hiển thị trình chọn file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Lấy file được chọn
        File file = File(result.files.single.path!);

        // Đọc nội dung file
        String content = await file.readAsString();

        // Cập nhật giao diện
        setState(() {
          _fileContent = content;
        });

        showDialogDataFromQR(jsonDecode(_fileContent!));
      }
    } catch (e) {
      // Xử lý lỗi
      print("Có lỗi xảy ra: $e");
    }
  }

  void showPopupAddFolder() {
    AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: Navigator.of(context), // Cần đảm bảo context này hỗ trợ TickerProvider
    );

    Animation<Offset> animation = Tween<Offset>(
      begin: const Offset(0, -1), // Xuất hiện từ trên xuống
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    controller.forward();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return SlideTransition(
              position: animation,
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(20, 195, 142, 1.0),
                        width: 10.0,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Add New Folder',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            width: MediaQuery.sizeOf(context).width - 100,
                            height: 100,
                            child: TextField(
                              controller: nameFolderInput,
                              decoration: InputDecoration(
                                hintText: "Name folder",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 20.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red, width: 3.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorText: textErrorName,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      textErrorName = null;
                                      nameFolderInput.text = "";
                                    });
                                    controller.dispose();
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
                                    setState(() {
                                      isLoadingCreateNewFolder = true;
                                    });

                                    if (await DatabaseHelper.instance.hasFolderName(nameFolderInput.text)) {
                                      setState(() {
                                        textErrorName = "Name Folder Exist";
                                        isLoadingCreateNewFolder = false;
                                      });
                                    } else {
                                      await DatabaseHelper.instance.insertNewFolder(nameFolderInput.text);
                                      await reload();
                                      controller.dispose();
                                      Navigator.of(context).pop();
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
                                          "Create",
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
                      if (isLoadingCreateNewFolder)
                        Container(
                          height: 250,
                          color: const Color.fromRGBO(145, 145, 145, 0.3),
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showPopupAddTopic() {
    AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: Navigator.of(context),
    );

    Animation<Offset> animation = Tween<Offset>(
      begin: const Offset(0, -1), // Animation xuất hiện từ trên xuống
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    controller.forward(); // Khởi chạy animation

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return SlideTransition(
              position: animation,
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(20, 195, 142, 1.0),
                        width: 10.0,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Add New Topic',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            width: MediaQuery.sizeOf(context).width - 100,
                            height: 100,
                            child: TextField(
                              controller: nameTopicInput,
                              decoration: InputDecoration(
                                hintText: "Name Topic",
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 20.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red, width: 3.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorText: textErrorName,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      textErrorName = null;
                                      nameFolderInput.text = "";
                                    });

                                    controller.dispose(); // Hủy controller trước khi đóng
                                    Navigator.pop(context);
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
                                    setState(() {
                                      isLoadingCreateNewFolder = true;
                                    });

                                    if (await DatabaseHelper.instance.hasTopicName(nameTopicInput.text)) {
                                      setState(() {
                                        textErrorName = "Name Topic Exist";
                                        isLoadingCreateNewFolder = false;
                                      });
                                    } else {
                                      isLoadingCreateNewFolder = false;
                                      controller.dispose();
                                      Navigator.pop(context);
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
                                          "Create",
                                          style: TextStyle(color: Colors.black, fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isLoadingCreateNewFolder)
                        Container(
                          height: 250,
                          color: const Color.fromRGBO(145, 145, 145, 0.3),
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showPopupInput() {
    showGeneralDialog(
      barrierDismissible: true,
      context: context,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Align(
              alignment: Alignment.topCenter,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1), // Bắt đầu từ bên ngoài phía trên
                  end: Offset.zero,           // Đến vị trí giữa màn hình
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: Dialog(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color.fromRGBO(20, 195, 142, 1.0),
                          width: 10.0,
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Type Input',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await _pickFile();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5),
                                      child: Container(
                                        width: MediaQuery.sizeOf(context).width * 0.3,
                                        height: MediaQuery.sizeOf(context).width * 0.1,
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: const Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.file_upload_outlined, color: Colors.black, size: 20),
                                              SizedBox(width: 10),
                                              Text(
                                                "File",
                                                style: TextStyle(color: Colors.white, fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => qrScreen()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        width: MediaQuery.sizeOf(context).width * 0.3,
                                        height: MediaQuery.sizeOf(context).width * 0.1,
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(184, 241, 176, 1),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: const Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.qr_code, color: Colors.black, size: 20),
                                              SizedBox(width: 10),
                                              Text(
                                                "QR",
                                                style: TextStyle(color: Colors.black, fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: hanldeGetData(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("No data available."));
        }

        dataDashBoards = snapshot.data as Map<String, List<Map<String, dynamic>>>;

        amountTopic = "${dataDashBoards["topic"]!.length} Topic";

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              child: const Text(
                "日本語",
                style: TextStyle(fontFamily: "aboshione", fontSize: 20, color: Colors.white),
              ),
            ),
            actions: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    amountTopic,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "itim"),
                  ),
                ),
              ),
            ],
            backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          body: Container(
              color: Colors.white,
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: RefreshIndicator(
                  onRefresh: reload,
                  child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (ctx, index){
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width * 0.80,
                                      height: MediaQuery.sizeOf(context).width*0.11,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
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
                                            hintStyle: TextStyle(color: Colors.grey)
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        if(searchWord.text.isNotEmpty) {
                                          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>searchWordScreen(wordSearch: searchWord.text)));
                                        }
                                      },
                                      child: Container(
                                        width: MediaQuery.sizeOf(context).width*0.11,
                                        height: MediaQuery.sizeOf(context).width*0.11,
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(184, 241, 176, 1),
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        ),
                                        child: Icon(Icons.search),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Folder",
                                      style: TextStyle(fontFamily: "itim", fontSize: 30),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        showPopupAddFolder();
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(184, 241, 176, 1),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "+ ADD",
                                            style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              dataDashBoards["folder"]!.isEmpty? Center(
                                child: Text("No Data", style: TextStyle(fontSize: 20),),
                              ) : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (Map<String, dynamic> folder in dataDashBoards["folder"]!)
                                      folderWidget(nameFolder: folder["namefolder"]!, reloadDashboard: () {
                                        reload();
                                      }, dateCreated: folder["datefolder"],),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Topic",
                                      style: TextStyle(fontFamily: "itim", fontSize: 30),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            showPopupInput();
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(184, 241, 176, 1),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: const Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.insert_page_break, color: Colors.black,size: 20,),
                                                    SizedBox(width: 10,),
                                                    Text(
                                                      "Input",
                                                      style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20,),
                                        GestureDetector(
                                          onTap: (){
                                            showPopupAddTopic();
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(184, 241, 176, 1),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "+ ADD",
                                                style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              dataDashBoards["topic"]!.length == 0 ? 
                                 Center(
                                   child: Container(
                                     height: MediaQuery.sizeOf(context).width*0.8,
                                     width: MediaQuery.sizeOf(context).width*0.8,
                                     child: Image.asset("assets/storyset/nodata2.png",),
                                   ),
                                 ) : Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: dataDashBoards["topic"]!.length,
                                    itemBuilder: (context, index) {
                                      var topic = dataDashBoards["topic"]![index];
                                        
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: topicWidget(
                                          nameTopic: topic["name"],
                                          reloadDashBoard: () {
                                            reload();
                                          },
                                        ),
                                      );
                                    },
                                  )
                              ),
                            ],
                          ),
                        );
                      })
              )
          ),
        );
      },
    );
  }
}