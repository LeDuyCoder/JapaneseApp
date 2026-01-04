import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/core/State/FeatureState.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/achivement/presentation/pages/achivement_page.dart';
import 'package:japaneseapp/features/auth/presentation/pages/logout/logout_cubit.dart';
import 'package:japaneseapp/features/auth/presentation/pages/logout/logout_state.dart';
import 'package:japaneseapp/features/navigator_hub/presentation/setting_feature_learn_page.dart';
import 'package:japaneseapp/features/navigator_hub/presentation/widgets/error_bottom_sheet_widget.dart';
import 'package:japaneseapp/features/navigator_hub/presentation/widgets/no_internet_bottom_sheet_widget.dart';
import 'package:japaneseapp/features/rank/presentation/pages/rank_page.dart';
import 'package:japaneseapp/features/splash/presentation/splash_screen.dart';
import 'package:japaneseapp/features/synchronize/presentation/pages/dowload_synchronize_page.dart';
import 'package:japaneseapp/features/synchronize/presentation/pages/push_synchronize_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingPage extends StatefulWidget{

  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage>{
  bool isLoading = false;

  void showBottomSheetNoInternet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const NoInternetBottomSheetWidget(),
    );
  }

  void showBottomSheetError(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ErrorBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 30,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            color: Colors.white,
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.setting_title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ListTile(
                            leading: Icon(Icons.golf_course, color: Colors.black,),
                            title: Text(AppLocalizations.of(context)!.setting_achivement_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            subtitle: Text(AppLocalizations.of(context)!.setting_achivement_content),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black,),
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => AchivementPage(prefs: prefs),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(-1.0, 0.0);
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

                            }
                        ),
                        const SizedBox(height: 20,),
                        ListTile(
                            leading: const Icon(FontAwesome.ranking_star_solid, color: Colors.black,),
                            title: const Text("Bảng xếp hạng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            subtitle: const Text("Danh sách đua top tuần"),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black,),
                            onTap: (){
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => RankPage(userId: FirebaseAuth.instance.currentUser!.uid),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(-1.0, 0.0);
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
                            }
                        ),
                        const SizedBox(height: 20,),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        // ListTile(
                        //     leading: Icon(Icons.language, color: Colors.black,),
                        //     title: Text(AppLocalizations.of(context)!.setting_language_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        //     subtitle: Text(AppLocalizations.of(context)!.setting_language_content),
                        //     trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                        //     onTap: () {
                        //       Navigator.push(
                        //         context,
                        //         PageRouteBuilder(
                        //           pageBuilder: (context, animation, secondaryAnimation) => Container(),
                        //           transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        //             const begin = Offset(-1.0, 0.0);
                        //             const end = Offset.zero;
                        //             const curve = Curves.ease;
                        //             final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        //             return SlideTransition(
                        //               position: animation.drive(tween),
                        //               child: child,
                        //             );
                        //           },
                        //         ),
                        //       );
                        //     }
                        // ),
                        ListTile(
                            leading: Icon(Icons.sync, color: Colors.black,),
                            title: Text(AppLocalizations.of(context)!.setting_async_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            subtitle: Text(AppLocalizations.of(context)!.setting_async_content),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PushSynchronizePage()));
                            }
                        ),
                        ListTile(
                            leading: Icon(Icons.download, color: Colors.black,),
                            title: Text(AppLocalizations.of(context)!.setting_downloadAsync_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            subtitle: Text(AppLocalizations.of(context)!.setting_downloadAsync_content),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const DownSynchronizePage()));
                            }
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        ListTile(
                          title: const Text("Đồng Hồ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          subtitle: const Text("mở giao điện xem thời gian trên dashboard"),
                          trailing: Switch(
                            value: SplashScreen.featureState.timerView,
                            activeColor: AppColors.primary,
                            onChanged: (bool value) async {
                              setState(() {
                                SplashScreen.featureState.setStateFeture(KeyFeature.timerView, value);
                              });
                            },
                          ),
                        ),
                        ListTile(
                            title: const Text("Tính Năng Học", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            subtitle: const Text("Thiết lập tính năng học tập"),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black,),
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingFeatureLearnPage()));
                            }
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        BlocConsumer<LogoutCubit, LogoutState>(
                            builder: (context, state){
                              return ListTile(
                                  leading: const Icon(Icons.logout, color: Colors.red,),
                                  title: Text(AppLocalizations.of(context)!.setting_signout_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),),
                                  subtitle: Text(AppLocalizations.of(context)!.setting_signout_content, style: TextStyle(color: Colors.red),),
                                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red,),
                                  onTap: () async {
                                    context.read<LogoutCubit>().logout(context);
                                  }
                              );
                            },
                            listener: (context, state){
                              if (state is LogoutNoInternet) {
                                showBottomSheetNoInternet(context);
                              }

                              if (state is LogoutSuccess) {
                                Navigator.pop(context);
                              }

                              if (state is LogoutFailure) {
                                showBottomSheetError(context);
                              }
                            }
                        ),
                        const SizedBox(height: 50,),
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
          if(isLoading)
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: const CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
        ],
      )
    );
  }
}