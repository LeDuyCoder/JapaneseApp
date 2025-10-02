import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/Module/topic.dart';
import 'package:japaneseapp/Screen/addWordScreen.dart';
import 'package:japaneseapp/Screen/allFolderScreen.dart';
import 'package:japaneseapp/Screen/downloadScreen.dart';
import 'package:japaneseapp/Screen/qrScreen.dart';
import 'package:japaneseapp/Screen/seeMoreTopic.dart';
import 'package:japaneseapp/Theme/colors.dart';
import 'package:japaneseapp/Widget/folerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/dataHelper.dart';
import '../Module/WordModule.dart';
import '../Module/word.dart';
import '../Service/Server/ServiceLocator.dart';
import '../Widget/JapaneseClockText.dart';
import '../Widget/topicServerWidget.dart';
import '../Widget/topicWidget.dart';
import 'package:http/http.dart' as http;

import '../generated/app_localizations.dart';
import 'allTopicScreen.dart';

class dashboardScreen extends StatefulWidget {
  final Function(Locale _locale) changeLanguage;

  static int countAdMod = 0;
  
  const dashboardScreen({Key? key, required this.changeLanguage}) : super(key: key);

  // Khai báo GlobalKey static 1 lần duy nhất
  static final GlobalKey<_DashboardScreenState> globalKey =
  GlobalKey<_DashboardScreenState>();

  @override
  State<dashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<dashboardScreen> {

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

  bool _isOffline = false;
  bool timerView = false;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  String formatJapaneseTime(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');
    return "$hour時$minute分$second秒";
  }

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((statusList) {
      final status = statusList.isNotEmpty ? statusList.first : ConnectivityResult.none;

      if (status == ConnectivityResult.none) {
        setState(() => _isOffline = true);
      } else {
        _checkInternet(status);
      }
    });
  }

  Future<void> _checkInternet([ConnectivityResult? status]) async {
    bool hasInternet = await _hasInternetConnection(status);
    setState(() {
      _isOffline = !hasInternet;
    });
  }

  Future<bool> _hasInternetConnection([ConnectivityResult? status]) async {
    final result = status ?? await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    try {
      final response = await http
          .get(Uri.parse("https://www.gstatic.com/generate_204"))
          .timeout(const Duration(seconds: 8));
      print(response.statusCode);
      return response.statusCode == 204;
    } catch (e) {
      print("Internet check error: $e");
      return false;
    }
  }


  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> hanldeGetData() async {
    final db = await DatabaseHelper.instance;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    timerView = sharedPreferences.getBool("timerView") ?? false;

    Map<String, dynamic> data;

    try {
      // thử gọi server với timeout
      var dataServer = await ServiceLocator.topicService
          .getAllDataTopic(5)
          .timeout(const Duration(seconds: 10));

      print(dataServer);

      if (dataServer == null) {
        data = {
          "topic": await db.getAllTopic(),
          "folder": await db.getAllFolder(),
        };
      }
      else {
        // nếu server có dữ liệu → gộp local + server
        data = {
          "topic": await db.getAllTopic(),
          "folder": await db.getAllFolder(),
          "topicServer": dataServer,
        };
      }
    } on TimeoutException catch (_) {
      print(_.message);
      data = {
        "topic": await db.getAllTopic(),
        "folder": await db.getAllFolder(),
      };
    } on SocketException catch (_) {
      print(_.message);
      data = {
        "topic": await db.getAllTopic(),
        "folder": await db.getAllFolder(),
      };
    } catch (e) {
      print(e.toString());
      data = {
        "topic": await db.getAllTopic(),
        "folder": await db.getAllFolder(),
      };
    }

    return data;
  }

  void reloadScreen(){
    setState(() {});
  }

  String getUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    String fullname = user?.displayName ?? "";
    if (fullname.trim().isEmpty) return "";
    List<String> parts = fullname.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      String first = parts[parts.length - 2][0].toUpperCase();
      String second = parts.last[0].toUpperCase();
      return first + second;
    }
  }

  Future<void> reload() async {
    await Future.delayed(Duration(seconds: 2));
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
                          child: Text("Danh Sách Từ Chia Sẽ", style: TextStyle(fontSize: 25)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              const Text("Tạo Bởi: ", style: TextStyle(fontFamily: "", fontSize: 20),),
                              Text(data["user"], style: TextStyle(fontFamily: "IslandMoments",),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              const Text("Số Lượng Từ: ", style: TextStyle(fontFamily: "", fontSize: 20),),
                              Text("${(data["listWords"] as List<dynamic>).length} Words", style: TextStyle(fontFamily: "IslandMoments"),)
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        const Text("Bạn Có Muốn Thêm Vao Danh Sách Từ Không ?", style: TextStyle(fontFamily: ""),),
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
                                child: const Center(
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
                                child: const Center(
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
                              'Thêm Thư Mục Mới',
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
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add_circle_outline, color: AppColors.primary, size: 28),
                              SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(context)!.popup_add_topic,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontFamily: "",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: MediaQuery.sizeOf(context).width - 100,
                            child: TextField(
                              controller: nameTopicInput,
                              style: const TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.popup_add_topic_hint,
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 18.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(
                                      0xFFC1C1C1), width: 2.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(
                                      0xFFC1C1C1), width: 2.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorText: textErrorName,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    textErrorName = null;
                                    nameFolderInput.text = "";
                                  });
                                  controller.dispose();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close, color: Colors.red),
                                label: Text(
                                  AppLocalizations.of(context)!.popup_add_topic_btn_cancle,
                                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  setState(() {
                                    isLoadingCreateNewFolder = true;
                                  });

                                  if (await DatabaseHelper.instance.hasTopicName(nameTopicInput.text)) {
                                    setState(() {
                                      textErrorName = AppLocalizations.of(context)!.popup_add_topic_exit;
                                      isLoadingCreateNewFolder = false;
                                    });
                                  } else {
                                    isLoadingCreateNewFolder = false;
                                    String nameTopic = nameTopicInput.text;
                                    nameFolderInput.clear();
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => addWordScreen(
                                          topicName: nameTopic,
                                          setIsLoad: () {
                                            setState(() {
                                              isLoadingCreateNewFolder = false;
                                            });
                                          },
                                          reload: () {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    );

                                  }
                                },
                                icon: const Icon(Icons.check_circle, color: Colors.white),
                                label: Text(
                                  AppLocalizations.of(context)!.popup_add_topic_btn_create,
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (isLoadingCreateNewFolder)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(color: Colors.green),
                            ),
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
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Chọn phương thức nhập',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF388E3C),
                            fontFamily: "",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await _pickFile();
                                },
                                child: Container(
                                  height: 70,
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade400,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.file_upload_outlined, color: Colors.white, size: 28),
                                        SizedBox(height: 6),
                                        Text(
                                          "Từ File",
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => qrScreen()));
                                },
                                child: Container(
                                  height: 70,
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(184, 241, 176, 1),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.qr_code, color: Colors.black, size: 28),
                                        SizedBox(height: 6),
                                        Text(
                                          "Từ QR",
                                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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

  Future<bool> dowloadTopic(String id) async{

    DatabaseHelper db = DatabaseHelper.instance;

    topic? Topic = await ServiceLocator.topicService.getDataTopicByID(id);
    nameTopic = Topic!.name;
    List<Map<String, dynamic>> dataWords = [];

     if(await db.hasTopicName(nameTopic)){
       await showDialogRenameTopic();
     }

    if(!await db.hasTopicName(nameTopic)){
      List<Word> listWord = await ServiceLocator.wordService.fetchWordsByTopicID(id);
      for(Word wordDB in listWord){
        dataWords.add(
            new word(wordDB.word, wordDB.wayread, wordDB.mean, nameTopic==""?Topic.name:nameTopic, 0).toMap()
        );
      }

      await db.insertTopicID(Topic.id, nameTopic==""?Topic.name:nameTopic, Topic.owner!);
      await db.insertDataTopic(dataWords);
      reload();
    }

    return true;
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

  void showBottomSheetDowloadPulic(String id, String nameTopic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning,
                color: Colors.orange, // màu icon
                size: 60,
              ),
              const SizedBox(height: 20),
              AutoSizeText(
                AppLocalizations.of(context)!.comunication_bottomSheet_notify_download_title,
                style: TextStyle(fontFamily: "", fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => DownloadScreen(nameTopic: nameTopic, downloadTopic: () async {
                            return dowloadTopic(id);
                          },),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.2,
                      height: MediaQuery.sizeOf(context).height * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.comunication_bottomSheet_notify_download_btn,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.backgroundPrimary,
            scrolledUnderElevation: 0,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "KujiLingo",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 40,
                    fontFamily: "",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: Text(
                      getUserName(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: RefreshIndicator(
              onRefresh: reload,
              child:Container(
                width: MediaQuery.sizeOf(context).width,
                color: AppColors.backgroundPrimary,
                child: FutureBuilder(future: hanldeGetData(), builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return ListView(
                      children: [
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(AppLocalizations.of(context)!.dashboard_folder, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontFamily: ""),),
                            SizedBox(width: 80,),
                            Text(AppLocalizations.of(context)!.dashboard_folder_seemore, style: TextStyle(color: AppColors.primary, fontSize: 18),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                            height: 160,
                            width: MediaQuery.sizeOf(context).width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Container(
                                      width: 250,
                                      height: 140,
                                      decoration: const BoxDecoration(
                                          color: AppColors.backgroundCardLoad,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 2),
                                              blurRadius: 5,
                                            )
                                          ]
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10, top: 0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 180,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                width: 220,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                  SizedBox(width: 10,),
                                  Container(
                                      width: 250,
                                      height: 140,
                                      decoration: const BoxDecoration(
                                          color: AppColors.backgroundCardLoad,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 2),
                                              blurRadius: 5,
                                            )
                                          ]
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10, top: 0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 180,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                width: 220,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              )
                                            ],
                                          )
                                      )
                                  ),
                                ],
                              ),
                            )
                        ),
                        SizedBox(height: 10,),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Cộng Đồng", style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontFamily: ""),),
                            SizedBox(width: 80,),
                            Text("Xem Tất Cả", style: TextStyle(color: AppColors.primary, fontSize: 18),),
                          ],
                        ),
                        Container(
                          height: 140,
                          width: MediaQuery.sizeOf(context).width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 5, right: 10),
                                    padding: const EdgeInsets.only(left: 10, right: 15),
                                    width: 310,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                        color: AppColors.backgroundCardLoad,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 2),
                                              blurRadius: 5
                                          )
                                        ]
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20,),
                                        Container(
                                          width: 180,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                            ),
                                            Container(
                                              width: 50,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 5, right: 10),
                                    padding: const EdgeInsets.only(left: 10, right: 15),
                                    width: 310,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                        color: AppColors.backgroundCardLoad,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 2),
                                              blurRadius: 5
                                          )
                                        ]
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20,),
                                        Container(
                                          width: 180,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                            ),
                                            Container(
                                              width: 50,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(AppLocalizations.of(context)!.dashboard_topic, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontFamily: ""),),
                            SizedBox(width: 80,),
                            Text(AppLocalizations.of(context)!.dashboard_topic_seemore, style: TextStyle(color: AppColors.primary, fontSize: 18),),

                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                                    child: GestureDetector(
                                      onTap: (){
                                      },
                                      child: Container(
                                          width: MediaQuery.sizeOf(context).width,
                                          height: 120,
                                          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                          decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(0, 2),
                                                  blurRadius: 10,
                                                )
                                              ],
                                              color: AppColors.backgroundCardLoad,
                                              borderRadius: BorderRadius.all(Radius.circular(20))
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 20,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 180,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey.withOpacity(0.3),
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 70,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey.withOpacity(0.3),
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey.withOpacity(0.3),
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                      ),
                                                      SizedBox(height: 10,),
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
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey.withOpacity(0.3),
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                      ),
                                                      SizedBox(height: 10,),
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
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey.withOpacity(0.3),
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey.withOpacity(0.3),
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )

                                            ],
                                          )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                        )
                      ],
                    );
                  }
                  if(snapshot.hasData){
                    return ListView(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        if (_isOffline)
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 70,
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              width: 250,
                              height: 70,
                              padding: const EdgeInsets.only(left: 30, right: 30),
                              decoration: BoxDecoration(
                                  color: AppColors.bakcgroundOffline,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(
                                      color: AppColors.lineOffline
                                  )
                              ),
                              child: Center(
                                child: RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Không có kết nối mạng. ",
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Một số tính năng có thể không khả dụng.",
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 20,),
                        if(timerView)
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time_filled_rounded, color: AppColors.primary,),
                                  SizedBox(width: 10,),
                                  JapaneseClockText(
                                    style: TextStyle(fontSize: 24, color: AppColors.primary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(AppLocalizations.of(context)!.dashboard_folder, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontFamily: ""),),
                            const SizedBox(width: 80,),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => allFolderScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.dashboard_folder_seemore, style: TextStyle(color: AppColors.primary, fontSize: 18, fontFamily: ""),),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),

                        if(snapshot.data!["folder"]!.length == 0)
                          Container(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.folder_open, size: 48, color: Colors.grey.shade600),
                                const SizedBox(height: 12),
                                Text(
                                  AppLocalizations.of(context)!.dashboard_folder_nodata_title,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppLocalizations.of(context)!.dashboard_folder_nodata_content,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          )
                        ,

                        if(snapshot.data!["folder"]!.length != 0)
                          Container(
                              height: 160,
                              width: MediaQuery.sizeOf(context).width,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (Map<String, dynamic> folder in snapshot.data!["folder"]!)
                                      folderWidget(idFolder: folder["id"], nameFolder: folder["namefolder"]!, reloadDashboard: reloadScreen, dateCreated: folder["datefolder"], amountTopic: folder["amountTopic"],),
                                  ],
                                ),
                              )
                          ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(AppLocalizations.of(context)!.dashboard_comunication, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontFamily: ""),),
                            SizedBox(width: 80,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => seeMoreTopic(reloadScreen: reloadScreen),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.dashboard_comunication_seemore, style: TextStyle(fontFamily: "", color: AppColors.primary, fontSize: 18),),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if(snapshot.data!.containsKey("topicServer") && snapshot.data!.isEmpty)
                                  Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 180,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 180,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: AppColors.grey,
                                                offset: Offset(0, 2),
                                                blurRadius: 10
                                            )
                                          ]
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.folder, color: AppColors.grey, size: 50,),
                                          const Text("Không có dữ liệu", style: TextStyle(fontFamily: "" ,color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),),
                                          Padding(
                                            padding: EdgeInsets.only(left: 50, right: 50),
                                            child: Text("Hiện tại không có thư mục nào. Hãy đăng thư mục đầu tiên của bạn",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors.textSecond.withOpacity(0.5),
                                                  fontSize: 15,
                                                  height: 1.8,
                                                  fontFamily: ""
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if(snapshot.data!.containsKey("topicServer") && snapshot.data!.isNotEmpty)
                                  for(topic topicServer in snapshot.data?["topicServer"])
                                    topicServerWidget(
                                      name: topicServer.name,
                                      owner: topicServer.owner ?? '',
                                      amount: topicServer.count??0,
                                      id: topicServer.id,
                                      showBottomShetDownload: (String id) {
                                        showBottomSheetDowloadPulic(id, topicServer.name);
                                      },
                                    ),
                                if(!snapshot.data!.containsKey("topicServer"))
                                  ...[
                                    Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 250,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                        width: MediaQuery.sizeOf(context).width,
                                        height: 250,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColors.grey,
                                                  offset: Offset(0, 2),
                                                  blurRadius: 10
                                              )
                                            ]
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("Không thể kết nối", style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 50, right: 50),
                                              child: Text("Vui lòng kiểm tra lại internet của bạn và thử lại để xem nội dung cộng đồng",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppColors.textSecond,
                                                    fontSize: 15,
                                                    height: 1.8
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            InkWell(
                                              onTap: () {
                                                reloadScreen();
                                              },
                                              borderRadius: BorderRadius.circular(60),
                                              child: Container(
                                                width: 140,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius: BorderRadius.circular(60),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(ZondIcons.reload, color: AppColors.white),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Thử Lại",
                                                      style: TextStyle(
                                                        color: AppColors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(AppLocalizations.of(context)!.dashboard_topic, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontFamily: ""),),
                            const SizedBox(width: 80,),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => allTopicScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.0), // tạo vùng click thoải mái hơn
                                child: Text(
                                  AppLocalizations.of(context)!.dashboard_topic_seemore,
                                  style: TextStyle(color: AppColors.primary, fontSize: 18, fontFamily: ""),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child:  snapshot.data?["topic"].length > 0
                                  ? Column(
                                  children: [
                                    for (Map<String, dynamic> topicLocal in snapshot.data?["topic"])
                                      topicWidget(
                                        id: topicLocal["id"],
                                        nameTopic: topicLocal["name"],
                                        reloadDashBoard: () {
                                          reloadScreen();
                                        },
                                      ),
                                  ]
                              )
                                  : Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.grey,
                                          blurRadius: 10,
                                          offset: Offset(0, -2)
                                      )
                                    ]
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.topic, size: 48, color: Colors.grey.shade600),
                                    const SizedBox(height: 12),
                                    Text(
                                      AppLocalizations.of(context)!.dashboard_topic_nodata_title,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      AppLocalizations.of(context)!.dashboard_topic_nodata_content,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        )
                      ],
                    );
                  }
                  return Container();
                }),
              )
          )
      ),
    );


  }
}