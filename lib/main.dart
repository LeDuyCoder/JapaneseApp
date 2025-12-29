import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:japaneseapp/core/Config/dataJson.dart';
import 'package:japaneseapp/core/Service/FunctionService.dart';
import 'package:japaneseapp/core/DI/auth_injection.dart';
import 'package:japaneseapp/features/ads/data/datasources/ads_counter_local_ds.dart';
import 'package:japaneseapp/features/ads/data/repositories/ads_policy_repository_impl.dart';
import 'package:japaneseapp/features/ads/domain/usecases/should_show_rewarded_ad.dart';
import 'package:japaneseapp/features/ads/presentation/cubit/AdsCubit.dart';
import 'package:japaneseapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:japaneseapp/features/character/data/datasource/character_datasource.dart';
import 'package:japaneseapp/features/splash/presentation/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/Listener/NetworkListener.dart';
import 'core/Theme/colors.dart';
import 'firebase_options.dart';
import 'core/generated/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  // Set full screen mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );

  await MobileAds.instance.initialize();
  TtsGoogle.init(apiKey: dotenv.env["API_KEY_GOOGLE_TTS"]!,);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initAuthFeature();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  CharacterDatasource characterDatasource = CharacterDatasource();
  var data = await characterDatasource.loadCharacters(type: "hiragana", rawData: dataJson.instance.data[0]);


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
              )
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();

}

class _MyApp extends State<MyApp>{

  Locale _locale = const Locale('vi');


  void _changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    FunctionService.checkAndBackup();

    //showNotification();
    return MaterialApp(
        locale: _locale,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Flutter Demo',
        navigatorKey: navigatorKey,
        builder: (context, child) {
          // init listener ở đây để toàn app đều nhận
          NetworkListener().init();
          return child!;
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.backgroundPrimary),
          useMaterial3: true,
        ),
        home: WillPopScope(
          onWillPop: (){
            return Future.value(false);
          },
          child: SplashScreen(changeLanguage: _changeLanguage,),
        )

    );
  }

}

