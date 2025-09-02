import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Screen/controllScreen.dart';
import 'package:japaneseapp/Screen/loginScreen.dart';
import 'package:japaneseapp/Screen/tabScreen.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Config/databaseServer.dart';
import '../main.dart';

class splashScreen extends StatefulWidget{
  final Function(Locale _locale) changeLanguage;

  const splashScreen({super.key, required this.changeLanguage});

  @override
  State<StatefulWidget> createState() => _splashScreen();
}

class _splashScreen extends State<splashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  String version_check = "", message_old_version = "";
  String version = "1.4.2";
  @override
  void initState() {
    super.initState();

    // Tạo AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Tạo hiệu ứng chuyển động từ trên xuống
    _animation = Tween<Offset>(
      begin: Offset(0, -0.5), // Bắt đầu từ ngoài màn hình (trên cùng)
      end: Offset(0, 0),   // Kết thúc ở vị trí ban đầu
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Đường cong hiệu ứng
    ));

    requestPermissions();

    // Bắt đầu hoạt ảnh
    _controller.forward();
    _initializeDatabase();
  }


  Duration getDelayUntilNext11PM() {
    DateTime now = DateTime.now();
    DateTime next11PM = DateTime(now.year, now.month, now.day, 23, 0, 0);

    if (now.isAfter(next11PM)) {
      // Nếu đã qua 23:00, đặt lịch cho ngày hôm sau
      next11PM = next11PM.add(Duration(days: 1));
    }

    return next11PM.difference(now);
  }


  void showDialogNotificationVersion() {
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
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: AutoSizeText(
                                      message_old_version, // Nội dung văn bản
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                      style: TextStyle(fontFamily: "indieflower"),
                                    ),
                                  ),
                                ],
                              ),
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
                              onTap: () async {
                                if (!(await checkFlag("firstJoint"))) {
                                  await setFlag("firstJoint", true);
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TabScreen(changeLanguage: widget.changeLanguage,)));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => loginScreen())
                                  );
                                }
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
                                  child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                ),
                              ),

                            ),
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


  Future<bool> checkFlag(String flagKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(flagKey) ?? false; // Nếu flag không tồn tại, trả về false
  }
  
  Future<void> requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  Future<void> setFlag(String flagKey, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(flagKey, value);
  }

  Future<void> _initializeDatabase() async {
    // Khởi tạo cơ sở dữ liệu và gọi await để chờ cơ sở dữ liệu được tạo

    DatabaseHelper db = DatabaseHelper.instance;

    await db.createDataLevel();
    await Future.delayed(Duration(seconds: 3));

    bool isConnected = await InternetConnectionChecker.instance.hasConnection;
    if(isConnected) {
      await fetchData();
      if(version_check == version) {
        sendToScreen();
      }else{
        showDialogNotificationVersion();
      }
    }else{
      sendToScreen();
    }
  }

  void sendToScreen() async {
    
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await widget.changeLanguage(Locale(sharedPreferences.getString("language")??"vi"));

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800), // Tăng thời gian chuyển đổi
        pageBuilder: (context, animation, secondaryAnimation) => controllScreen(changeLanguage: widget.changeLanguage,),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOut));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  Future<void> fetchData() async {
    const String apiUrl = 'https://api.npoint.io/e00f658fac808c7f708d';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        version_check = data["version"];
        message_old_version = data["noteWrongVersion"];
      } else {
        print('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng bộ nhớ
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Japanese App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Container(
            color: Colors.white,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _animation,
                  child: Image.asset(
                    "assets/logo.png",
                    scale: 0.8,
                  ),
                ),
                const Text("日本語", style: TextStyle(fontFamily: "aboshione", fontSize: 50),),
                const Text("Application", style: TextStyle(fontFamily: "islandmoment", fontSize: 50),),
            ],
            ),
          ),
        )
    );
  }

}