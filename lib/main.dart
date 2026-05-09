import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:japaneseapp/core/Service/FunctionService.dart';
import 'package:japaneseapp/core/DI/auth_injection.dart';
import 'package:japaneseapp/features/ads/data/datasources/ads_counter_local_ds.dart';
import 'package:japaneseapp/features/ads/data/repositories/ads_policy_repository_impl.dart';
import 'package:japaneseapp/features/ads/domain/usecases/should_show_rewarded_ad.dart';
import 'package:japaneseapp/features/ads/presentation/cubit/AdsCubit.dart';
import 'package:japaneseapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:japaneseapp/features/auth/presentation/pages/logout/logout_cubit.dart';
import 'package:japaneseapp/features/splash/presentation/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/service/NetworkListener.dart';
import 'core/Theme/colors.dart';
import 'firebase_options.dart';
import 'core/generated/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ dotenv FIRST
  await dotenv.load(fileName: '.env');
  //
  // Fullscreen
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
  //
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  //
  // // Ads
  //
  await MobileAds.instance.initialize();
  //
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //
  // // TTS
  TtsGoogle.init(
    apiKey: dotenv.env["API_KEY_GOOGLE_TTS"]!,
  );
  //
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //
  initAuthFeature();
  //
  final sharedPreferences = await SharedPreferences.getInstance();


  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => GetIt.I<AuthBloc>(),
        ),
        BlocProvider<AdsCubit>(
          create: (_) => AdsCubit(
            CheckAndShowRewardedAd(
              AdsPolicyRepositoryImpl(
                AdsCounterLocalDataSource(sharedPreferences),
              ),
            ),
          ),
        ),
        BlocProvider<LogoutCubit>(
          create: (_) => LogoutCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('vi');

  late final NetworkListener _networkListener;

  @override
  void initState() {
    super.initState();

    // ✅ FIX: move out of build
    FunctionService.checkAndBackup();

    // ✅ FIX: init once
    _networkListener = NetworkListener();
    _networkListener.init();
  }

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },

      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.backgroundPrimary,
        ),
        useMaterial3: true,
      ),


      home: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: SplashScreen(changeLanguage: _changeLanguage)
        ),
      ),
    );
  }
}