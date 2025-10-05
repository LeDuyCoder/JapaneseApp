import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:japaneseapp/Screen/SetUpLanguage.dart';
import 'package:japaneseapp/Screen/controllScreen.dart';
import 'package:japaneseapp/Screen/upRankScreen.dart';
import 'package:japaneseapp/State/FeatureState.dart';
import 'package:japaneseapp/Utilities/NetworkUtils.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';

import '../Service/Local/local_db_service.dart';
import '../Service/Server/ServiceLocator.dart';

class splashScreen extends StatefulWidget{
  final Function(Locale _locale) changeLanguage;
  static late FeatureState featureState;

  const splashScreen({super.key, required this.changeLanguage});

  @override
  State<StatefulWidget> createState() => _splashScreen();
}

class _splashScreen extends State<splashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  AppUpdateInfo? _updateInfo;

  late AudioPlayer _audioPlayer;

  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print("Lỗi khi phát âm thanh: $e");
    }
  }

  Future<void> playIntro() async {
    print("Debug");
    await playSound("sound/intro.mp3");
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Tạo AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Tạo hiệu ứng chuyển động từ trên xuống
    _animation = Tween<double>(
      begin: 0.0, // nhỏ xíu
      end: 1.0,   // full size
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // bung ra có nảy nhẹ
    ));

    requestPermissions();
    _controller.forward();
    playIntro();
    _initializeDatabase();
    checkForUpdate();
    addUser();
    loadStateFeature();
  }

  Future<void> loadStateFeature() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey("feature")) {
      splashScreen.featureState =
          FeatureState.fromJsonString(sharedPreferences.getString("feature")!);
    }else{
      FeatureState featureState = new FeatureState(false, true);
      splashScreen.featureState = featureState;
      sharedPreferences.setString("feature", featureState.toJsonString());
    }
  }


  Future<void> showNoInternetDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // không cho tắt bằng cách bấm ra ngoài
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text(
                "Không có kết nối",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            "Vui lòng kiểm tra lại kết nối mạng và thử lại.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(seconds: 2));
                checkInternet(); // hàm bạn tự định nghĩa
              },
              child: const Text("Thử lại"),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkInternet() async {
    if((await NetworkUtils.hasNetwork())){
      sendToScreen();
    }else{
      showNoInternetDialog(context);
    }
  }

  Future<void> addUser() async{
    if(FirebaseAuth.instance.currentUser != null) {
      print("demo addUsser");
      ServiceLocator.userService.addUser(FirebaseAuth.instance.currentUser!.uid,
          FirebaseAuth.instance.currentUser!.displayName!);
    }
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

    final db = LocalDbService.instance;

    await db.preferencesService.initDefaults();
    await Future.delayed(Duration(seconds: 2));

    await checkInternet();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });

      if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
        // Flexible Update (người dùng có thể tiếp tục xài app trong lúc tải)
        InAppUpdate.startFlexibleUpdate().then((_) {
          InAppUpdate.completeFlexibleUpdate();
        });

        // Hoặc Immediate Update (bắt buộc cập nhật ngay)
        // InAppUpdate.performImmediateUpdate();
      }
    }).catchError((e) {
      debugPrint("Lỗi check update: $e");
    });
  }

  void sendToScreen() async {
    
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await widget.changeLanguage(Locale(sharedPreferences.getString("language")??"vi"));

    if(sharedPreferences.containsKey("language")){
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
    }else{
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800), // Tăng thời gian chuyển đổi
          pageBuilder: (context, animation, secondaryAnimation) => setUpLanguage(changeLanguage: widget.changeLanguage,),
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
        title: 'Kujilingo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Container(
            color: Color(0xFFf44041),
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _animation, // Animation<double>
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.multiply,
                    ),
                    child: Image.asset(
                      "assets/icon.png",
                      scale: 5,
                    ),
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'KuJiLinGo',
                      textStyle: TextStyle(fontFamily: "Itim", fontSize: 60, color: Colors.white),
                      colors: [
                        Colors.white,
                        Colors.grey
                      ],
                    ),
                  ],
                  isRepeatingAnimation: true,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
            ],
            ),
          ),
        )
    );
  }

}