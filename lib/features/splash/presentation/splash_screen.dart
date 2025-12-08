import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/Screen/SetUpLanguage.dart';
import 'package:japaneseapp/core/Screen/controllScreen.dart';
import 'package:japaneseapp/core/Utilities/NetworkUtils.dart';
import 'package:japaneseapp/core/State/FeatureState.dart';
import 'package:japaneseapp/features/splash/service/splash_service.dart';

class SplashScreen extends StatefulWidget {
  final Function(Locale _locale) changeLanguage;
  static late FeatureState featureState;

  const SplashScreen({super.key, required this.changeLanguage});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;
  AppUpdateInfo? _updateInfo;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    FirebaseAnalytics.instance.logEvent(
      name: 'app_open_custom',
      parameters: {'screen': 'SplashScreen'},
    );

    _initializeApp();


  }

  Future<void> _initializeApp() async {
    _controller.forward();
    await SplashService.playIntro(_audioPlayer);
    await SplashService.requestPermissions();
    await _initializeDatabase();
    await SplashService.checkForUpdate(setState);
    await _loadFeatureState();
    await SplashService.addUser();
    await _checkInternetAndNavigate();
  }


  Future<void> _loadFeatureState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("feature")) {
      SplashScreen.featureState =
          FeatureState.fromJsonString(prefs.getString("feature")!);
    } else {
      FeatureState featureState = FeatureState(false, true);
      SplashScreen.featureState = featureState;
      prefs.setString("feature", featureState.toJsonString());
    }
  }

  Future<void> _initializeDatabase() async {
    final db = LocalDbService.instance;
    await db.preferencesService.initDefaults();
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _checkInternetAndNavigate() async {
    if (await NetworkUtils.hasNetwork()) {
      _navigateToNextScreen();
    } else {
      SplashService.showNoInternetDialog(context, _checkInternetAndNavigate);
    }
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await widget.changeLanguage(Locale(sharedPreferences.getString("language") ?? "vi"));

    final Widget nextScreen = sharedPreferences.containsKey("language")
        ? controllScreen(changeLanguage: widget.changeLanguage)
        : setUpLanguage(changeLanguage: widget.changeLanguage);

    if (mounted) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, _) => nextScreen,
          transitionsBuilder: (context, animation, _, child) {
            var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
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
          color: const Color(0xFFf44041),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Image.asset("assets/icon.png", scale: 5),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'KuJiLinGo',
                    textStyle: const TextStyle(
                        fontFamily: "Itim", fontSize: 60, color: Colors.white),
                    colors: [Colors.white, Colors.grey],
                  ),
                ],
                isRepeatingAnimation: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
