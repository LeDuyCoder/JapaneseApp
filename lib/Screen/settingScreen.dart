import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/FunctionService.dart';
import 'package:japaneseapp/Screen/achivementScreen.dart';
import 'package:japaneseapp/Screen/languageScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/dataHelper.dart';
import '../generated/app_localizations.dart';

class settingScreen extends StatefulWidget{
  final Function(Locale _locale) changeLanguage;

  const settingScreen({super.key, required this.changeLanguage});

  @override
  State<StatefulWidget> createState() => _settingScreen();
}

class _settingScreen extends State<settingScreen>{
  bool isLoading = false;

  void showCustomDialog(BuildContext context, String title, String message, Color borderColor) {
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
            ),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: borderColor,
                      width: 10.0,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.045, fontFamily: "Itim"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        message,
                        style: TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.04, fontFamily: "Itim"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        SizedBox(width: 20)
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showBottomSheetConfirmAsynchrony(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.bottomSheet_Warning_title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontFamily: "Itim",
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.bottomSheet_Warning_Description,
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width * 0.045,
                  fontFamily: "Itim",
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    label: Text(AppLocalizations.of(context)!.bottomSheet_Warning_btn_cancle, style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      updateAsynchronyData();
                    },
                    icon: const Icon(Icons.check),
                    label: Text(
                      AppLocalizations.of(context)!.bottomSheet_Warning_btn_ok,
                      style: TextStyle(fontSize: 16),
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

  void showBottomSheetPushDataSuccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color.fromRGBO(20, 195, 142, 1.0), size: 48),
                SizedBox(height: 16),
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.bottomSheetAsync_Success_Description,
                  style: TextStyle(fontSize: 16, fontFamily: "Itim"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.bottomSheetAsync_Success_Btn, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBottomSheetDownloadDataFail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.bottomSheet_Error_title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.bottomSheet_Error_description,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBottomSheetAsynchronySuccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color.fromRGBO(20, 195, 142, 1.0), size: 48),
                SizedBox(height: 16),
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.bottomSheetAsync_Success_Description,
                  style: TextStyle(fontSize: 16, fontFamily: "Itim"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<String> _convertToListString(dynamic list) {
    if (list == null) return [];
    return List<String>.from(list.map((item) => item.toString()));
  }

  void showBottomSheetNoInternet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(12.0),
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.bottomSheet_Nointernet_title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.bottomSheet_Nointernet_Description,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.bottomSheet_Nointernet_Btn, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> hasInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // Nếu không có kết nối vật lý (wifi/mobile) thì false
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Nếu có kết nối vật lý, ping thử google
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> synchronyData(bool isLogout) async {
    setState(() => isLoading = true);

    if (!await hasInternet()) {
      setState(() => isLoading = false);
      showBottomSheetNoInternet(context);
      return;
    }

    if(await FunctionService.synchronyData()){
      if (!isLogout) showBottomSheetPushDataSuccess(context);
    }else{
      setState(() => isLoading = false);
    }

  }

  Future<void> updateAsynchronyData() async {
    setState(() => isLoading = true);

    try {
      final db = DatabaseHelper.instance;
      final prefs = await SharedPreferences.getInstance();

      final userDoc = FirebaseFirestore.instance
          .collection("datas")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        showBottomSheetDownloadDataFail(context);
        return;
      }

      final data = docSnapshot.data();
      if (data == null || data["data"] == null) {
        showBottomSheetDownloadDataFail(context);
        return;
      }

      final Map<String, dynamic> dataMap = Map<String, dynamic>.from(data["data"]);

      // Restore SQLite
      final String sqliteData = dataMap["sqlite"] ?? "";
      if (sqliteData.isNotEmpty) {
        await db.importSynchronyData(sqliteData);
      }

      // Restore SharedPreferences
      final Map<String, dynamic> dataPrefs =
      Map<String, dynamic>.from(dataMap["prefs"] ?? {});

      if (dataPrefs.containsKey("level")) {
        await prefs.setInt("level", dataPrefs["level"]);
      }
      if (dataPrefs.containsKey("exp")) {
        await prefs.setInt("exp", dataPrefs["exp"]);
      }
      if (dataPrefs.containsKey("nextExp")) {
        await prefs.setInt("nextExp", dataPrefs["nextExp"]);
      }
      if (dataPrefs.containsKey("Streak")) {
        await prefs.setInt("Streak", dataPrefs["Streak"]);
      }
      if (dataPrefs.containsKey("lastCheckIn")) {
        await prefs.setString("lastCheckIn", dataPrefs["lastCheckIn"]);
      }
      if (dataPrefs.containsKey("checkInHistory")) {
        await prefs.setStringList(
          "checkInHistory",
          _convertToListString(dataPrefs["checkInHistory"]),
        );
      }
      if (dataPrefs.containsKey("checkInHistoryTreak")) {
        await prefs.setStringList(
          "checkInHistoryTreak",
          _convertToListString(dataPrefs["checkInHistoryTreak"]),
        );
      }
      if (dataPrefs.containsKey("achivement")) {
        await prefs.setStringList(
          "achivement",
          _convertToListString(dataPrefs["achivement"]),
        );
      }

      // Nếu muốn xóa backup sau khi tải về thì giữ lại:
      // await userDoc.delete();

      showBottomSheetAsynchronySuccess(context);
    } catch (e, st) {
      debugPrint("❌ Error retrieving data: $e");
      debugPrintStack(stackTrace: st);
      showBottomSheetDownloadDataFail(context);
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  ListTile(
                      leading: Icon(Icons.golf_course, color: Colors.black,),
                      title: Text(AppLocalizations.of(context)!.setting_achivement_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      subtitle: Text(AppLocalizations.of(context)!.setting_achivement_content),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                      onTap: (){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => achivementScreen(),
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
                  SizedBox(height: 20,),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  ListTile(
                      leading: Icon(Icons.language, color: Colors.black,),
                      title: Text(AppLocalizations.of(context)!.setting_language_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      subtitle: Text(AppLocalizations.of(context)!.setting_language_content),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => languageScreen(changeLanguage: widget.changeLanguage,),
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
                  ListTile(
                      leading: Icon(Icons.sync, color: Colors.black,),
                      title: Text(AppLocalizations.of(context)!.setting_async_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      subtitle: Text(AppLocalizations.of(context)!.setting_async_content),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                      onTap: () async {
                        await synchronyData(false);
                      }
                  ),
                  ListTile(
                      leading: Icon(Icons.download, color: Colors.black,),
                      title: Text(AppLocalizations.of(context)!.setting_downloadAsync_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      subtitle: Text(AppLocalizations.of(context)!.setting_downloadAsync_content),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                      onTap: () async {
                        if(!await hasInternet()){
                            showBottomSheetNoInternet(context);
                        }else{
                            showBottomSheetConfirmAsynchrony(context);
                        }
                      }
                  ),
                  ListTile(
                      leading: Icon(Icons.logout, color: Colors.red,),
                      title: Text(AppLocalizations.of(context)!.setting_signout_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),),
                      subtitle: Text(AppLocalizations.of(context)!.setting_signout_content, style: TextStyle(color: Colors.red),),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.red,),
                      onTap: () async {
                        if(await hasInternet()){
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          final DatabaseHelper db = DatabaseHelper.instance;
                          await synchronyData(true);
                          prefs.clear();
                          db.clearAllData();
                          await FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        }else{
                          showBottomSheetNoInternet(context);
                        }
                      }
                  ),
                ],
              )
          ),
          if(isLoading)
            Container(
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