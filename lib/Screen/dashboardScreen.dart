import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Module/topic.dart';
import 'package:japaneseapp/Screen/addWordScreen.dart';
import 'package:japaneseapp/Screen/qrScreen.dart';
import 'package:japaneseapp/Screen/seeMoreTopic.dart';
import 'package:japaneseapp/Screen/serchWordScreen.dart';
import 'package:japaneseapp/Screen/tutorialScreen.dart';
import 'package:japaneseapp/Widget/folerWidget.dart';

import '../Config/dataHelper.dart';
import '../Config/databaseServer.dart';
import '../Module/WordModule.dart';
import '../Module/word.dart';
import '../Widget/topicServerWidget.dart';
import '../Widget/topicWidget.dart';

class dashboardScreen extends StatefulWidget {
  const dashboardScreen({Key? key}) : super(key: key);

  // Khai báo GlobalKey static 1 lần duy nhất
  static final GlobalKey<_DashboardScreenState> globalKey =
  GlobalKey<_DashboardScreenState>();

  @override
  State<dashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<dashboardScreen> {

  Map<String, List<Map<String, dynamic>>> dataDashBoards = {};
  final TextEditingController nameFolderInput = TextEditingController();
  final TextEditingController nameTopicInput = TextEditingController();
  final TextEditingController searchWord = TextEditingController();
  final TextEditingController renameTopicInput = TextEditingController();
  String? textErrorName;
  String? textErrorTopicName;
  bool isLoadingCreateNewFolder = false;
  String amountTopic = "0 Topic";
  String? _fileContent;
  String nameTopic = "";

  Future<Map<String, List<Map<String, dynamic>>>> hanldeGetData() async {
    final db = await DatabaseHelper.instance;
    Map<String, List<Map<String, dynamic>>> data = {
      "topic": await db.getAllTopic(),
      "folder": await db.getAllFolder()
    };

    return data;
  }

  void reloadScreen(){
    print("Reloading data...");
    setState(() {

    });
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
                            'Lưu dữ liệu từ vựng không thành công vì đã tồn tại',
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
                          child: Text("Danh Sách Từ Chia Sẽ", style: TextStyle(fontFamily: "Itim", fontSize: 25)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              const Text("Tạo Bởi: ", style: TextStyle(fontFamily: "Itim", fontSize: 20),),
                              Text(data["user"], style: TextStyle(fontFamily: "IslandMoments",),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              const Text("Số Lượng Từ: ", style: TextStyle(fontFamily: "Itim", fontSize: 20),),
                              Text("${(data["listWords"] as List<dynamic>).length} Words", style: TextStyle(fontFamily: "IslandMoments"),)
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        const Text("Bạn Có Muốn Thêm Vao Danh Sách Từ Không ?", style: TextStyle(fontFamily: "Itim"),),
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
                                  child: Text("Hủy", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            SizedBox(width:10,),
                            GestureDetector(
                              onTap: () async {
                                DatabaseHelper db = DatabaseHelper.instance;
                                String nameTopic = "${data["name"]}";

                                if(!(await db.hasTopicName(nameTopic))) {
                                  await db.insertTopic(nameTopic, data["user"]);

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
                                  child: Text("Xác Nhận", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
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
                                hintText: "Tên thư mục",
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
                                          "Hủy",
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
                                        textErrorName = "Tên Thư Mục Đã Tồn Tại";
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
                                          "Tạo",
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
                                hintText: "Tên Chủ Đề",
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
                                          "Hủy",
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
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => addWordScreen(topicName: nameTopicInput.text, setIsLoad: (){
                                        setState((){
                                          isLoadingCreateNewFolder = false;
                                        });
                                      }, reload: (){
                                        setState((){});
                                      })));
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
                                          "Tạo",
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

  Future<List<topic>> getDataTopic() async {
    DatabaseServer db = new DatabaseServer();
    return db.getAllDataTopic(5).timeout(Duration(seconds: 10));
  }

  Future<bool> hastTopic(String id) async {
    DatabaseHelper db = DatabaseHelper.instance;
    return await db.hasTopicID(id);
  }

  Future<void> dowloadTopic(String id) async{
    DatabaseServer dbServer = new DatabaseServer();
    DatabaseHelper db = DatabaseHelper.instance;

    topic Topic = await dbServer.getDataTopicbyID(id);
    nameTopic = Topic.name;
    List<Map<String, dynamic>> dataWords = [];

     if(await db.hasTopicName(nameTopic)){
       await showDialogRenameTopic();
     }

    if(!await db.hasTopicName(nameTopic)){
      List<Word> listWord = await dbServer.fetchWordsByTopicID(id);
      for(Word wordDB in listWord){
        dataWords.add(
            new word(wordDB.word, wordDB.wayread, wordDB.mean, nameTopic==""?Topic.name:nameTopic, 0).toMap()
        );
      }

      await db.insertTopicID(Topic.id, nameTopic==""?Topic.name:nameTopic, Topic.owner!);
      await db.insertDataTopic(dataWords);
      reload();
    }

     Navigator.pop(context);
  }

  Future<bool> showDialogRenameTopic() async {
    await showGeneralDialog(
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
                          height: 350,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/character/character6.png", width: MediaQuery.sizeOf(context).width*0.3,),
                              Column(
                                children: [
                                  SizedBox(height: 20),
                                  AutoSizeText(
                                    "Tên Topic Đã Tồn Tại Vui Lòng Đổi Tên",
                                    style: TextStyle(fontFamily: "indieflower", fontSize: 15),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    width: MediaQuery.sizeOf(context).width - 100,
                                    height: 100,
                                    child: TextField(
                                      controller: renameTopicInput,
                                      decoration: InputDecoration(
                                        hintText: "Tên topic mới",
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
                                        errorText: textErrorTopicName,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      DatabaseHelper db = DatabaseHelper.instance;
                                      if(await db.hasTopicName(renameTopicInput.text)){
                                        setState((){
                                          textErrorTopicName = "Tên mới đã tồn tại";
                                        });
                                      }else{
                                        setState((){
                                          nameTopic = renameTopicInput.text;
                                          Navigator.pop(context);
                                          textErrorTopicName = null;
                                          renameTopicInput.text = "";
                                        });
                                      }
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
                                          "Đổi Tên",
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

    return true;
  }

  void showDialogDowloadPulic(String id) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
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
                                    "Bạn có muốn tải xuống không ?",
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
                                      dowloadTopic(id);
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
                                          "Tải",
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: hanldeGetData(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Không có dữ liệu", style: TextStyle(color: Colors.grey),));
        }

        dataDashBoards = snapshot.data as Map<String, List<Map<String, dynamic>>>;
        amountTopic = "${dataDashBoards["topic"]!.length} Topic";

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>tutorialScreen()));
                },
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.help, color: Colors.black45,)
                  ),
                ),
              )
            ],
            backgroundColor: Color(0xFF81C784),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          body: Container(
              color: Color(0xFFFFFFFF),
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
                                          color: Color(0xFFE8F5E9),
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        ),
                                        child: Icon(Icons.search),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(height: 20),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Thư Mục",
                                      style: TextStyle(fontFamily: "itim", fontSize: 30),
                                    ),
                                  ],
                                ),
                              ),
                              dataDashBoards["folder"]!.isEmpty? const Center(
                                child: Text("Không có dữ liệu", style: TextStyle(fontSize: 20, color: Colors.grey),),
                              ) : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (Map<String, dynamic> folder in dataDashBoards["folder"]!)
                                      folderWidget(idFolder: folder["id"], nameFolder: folder["namefolder"]!, reloadDashboard: () {
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
                                      "Học Phần",
                                      style: TextStyle(fontFamily: "itim", fontSize: 30),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) => seeMoreTopic(reloadScreen: (){
                                                  reload();
                                                },),
                                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                  const begin = Offset(1.0, 0.0); // bắt đầu từ bên phải
                                                  const end = Offset.zero;        // kết thúc ở chính giữa
                                                  const curve = Curves.ease;

                                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                                  var offsetAnimation = animation.drive(tween);

                                                  return SlideTransition(
                                                    position: offsetAnimation,
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 50,
                                            decoration: const BoxDecoration(),
                                            child: const Center(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Xem Thêm",
                                                    style: TextStyle(fontFamily: "Itim", fontWeight: FontWeight.bold, fontSize: 16),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Icon(Icons.arrow_right_alt)
                                                ],
                                              )
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              FutureBuilder(
                                future: getDataTopic(), // Hàm này phải trả về Future
                                builder: (context, dataTopics) {
                                  if(dataTopics.connectionState == ConnectionState.waiting){
                                    return Container();
                                  }

                                  if(dataTopics.hasData){
                                    if(dataTopics.data!.length == 0){
                                      return const Center(
                                        child: Text("Không Có Dữ Liệu"),
                                      );
                                    }else {
                                      return Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          width: MediaQuery
                                              .sizeOf(context)
                                              .width,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                for(topic item in dataTopics
                                                    .data!)
                                                  FutureBuilder(future: hastTopic(item.id), builder: (snapshot, data){
                                                    if(data.connectionState == ConnectionState.waiting){
                                                      return Container();
                                                    }

                                                    return GestureDetector(
                                                      onTap: (){
                                                        if(!data.data!){
                                                          showDialogDowloadPulic(item.id);
                                                        }
                                                      },
                                                      child: topicServerWidget(
                                                          name: item.name,
                                                          owner: item.owner ?? '',
                                                          amount: item.count!,
                                                          isDowloaded: data.data!
                                                      ),
                                                    );
                                                  })


                                              ],
                                            ),
                                          )
                                      );
                                    }
                                  }

                                  return Center(
                                    child: Text("Không Thể Kết Nối Đến Server", style: TextStyle(fontSize: 20, color: Colors.grey)),
                                  );


                                },
                              ),
                              SizedBox(height: 20,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Chủ Đề",
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
                                              color: Color(0xFFE8F5E9),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: const Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.insert_page_break, color: Colors.black,size: 20,),
                                                    SizedBox(width: 10,),
                                                    Text(
                                                      "Nhập",
                                                      style: TextStyle(fontFamily: "Itim", fontWeight: FontWeight.bold, fontSize: 16),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20,),
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
                                          id: topic["id"],
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