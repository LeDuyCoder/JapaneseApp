import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Screen/achivementScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/dataHelper.dart';

class settingScreen extends StatefulWidget{
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
                "Cảnh báo",
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
                "Khi đồng bộ, toàn bộ dữ liệu trên máy hiện tại sẽ bị xóa.",
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
                    label: const Text("Hủy", style: TextStyle(fontSize: 16)),
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
                      UpdateAsynchronyData();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text(
                      "Xác Nhận",
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
                  "Dữ liệu đã được đồng bộ hóa thành công.",
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
                  "Lỗi Tải Dữ Liệu",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Hiện không có bản đồng bộ hóa dữ liệu nào.",
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
                  "Đồng Bộ Hóa Dữ Liệu Thành Công",
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
                  "Không Có Kết Nối Internet",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Vui lòng kiểm tra kết nối internet của bạn và thử lại.",
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
    setState(() {
      isLoading = true;
    });

    if (!await hasInternet()) {
      setState(() {
        isLoading = false;
      });
      showBottomSheetNoInternet(context);
      return; // Dừng hẳn, không gọi Firestore
    }

    print("Có Internet, tiếp tục đồng bộ...");

    // --------- Có mạng thì mới chạy tiếp ----------
    DatabaseHelper db = DatabaseHelper.instance;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> dataPrefs = {
      "level": prefs.getInt("level"),
      "exp": prefs.getInt("exp"),
      "nextExp": prefs.getInt("nextExp"),
      "Streak": prefs.getStringList("checkInHistoryTreak")?.length ?? 0,
      "lastCheckIn": prefs.getString("lastCheckIn"),
      "checkInHistory": prefs.getStringList("checkInHistory"),
      "checkInHistoryTreak": prefs.getStringList("checkInHistoryTreak"),
      "achivement": prefs.getStringList("achivement"),
    };

    List<String> dataAsynchronyData = [];
    dataAsynchronyData.add((await db.getAllSynchronyData()));
    dataAsynchronyData.add(jsonEncode(dataPrefs));

    try {
      var userDoc = FirebaseFirestore.instance
          .collection("datas")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      var docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        await userDoc.update({'data': FieldValue.delete()});
      }

      await userDoc.set({'data': dataAsynchronyData}, SetOptions(merge: true));

      setState(() {
        isLoading = false;
      });

      if(!isLogout)
        showBottomSheetPushDataSuccess(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> UpdateAsynchronyData() async {
    DatabaseHelper db = DatabaseHelper.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    try {
      // Get the Firestore instance
      var userDoc = FirebaseFirestore.instance.collection("datas").doc(FirebaseAuth.instance.currentUser!.uid);

      // Get the document snapshot
      var docSnapshot = await userDoc.get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Document exists, retrieve the data
        var data = docSnapshot.data(); // This will return a Map<String, dynamic> with the document data
        String dataInDatabase = data!["data"][0];
        await db.importSynchronyData(dataInDatabase);

        Map<String, dynamic> dataPrefs = jsonDecode(data["data"][1]);
        print(dataPrefs);
        await prefs.clear();
        await prefs.setInt("level", dataPrefs["level"]);
        await prefs.setInt("exp", dataPrefs["exp"]);
        await prefs.setInt("nextExp", dataPrefs["nextExp"]);
        await prefs.setInt("Streak", dataPrefs["Streak"]);
        await prefs.setString("lastCheckIn", dataPrefs["lastCheckIn"]);
        await prefs.setStringList("checkInHistory", _convertToListString(dataPrefs["checkInHistory"]));
        await prefs.setStringList("checkInHistoryTreak", _convertToListString(dataPrefs["checkInHistoryTreak"]));
        await prefs.setStringList("achivement", _convertToListString(dataPrefs["achivement"]));

        userDoc.delete();

        showBottomSheetAsynchronySuccess(context);

      } else {
        showBottomSheetDownloadDataFail(context);
      }
    } catch (e) {
      print("Error retrieving data: $e");
    }

    setState(() {
      isLoading = false;
    });
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
                  Text("Cài đặt", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  ListTile(
                      leading: Icon(Icons.golf_course, color: Colors.black,),
                      title: Text("Thành Tựu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      subtitle: Text("Danh sách thành tựu đã đạt được"),
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
                      title: Text("Ngôn ngữ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      subtitle: Text("Chọn ngôn ngữ hiển thị"),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                      onTap: (){}
                  ),
                  ListTile(
                      leading: Icon(Icons.sync, color: Colors.black,),
                      title: Text("Đồng Bộ Dữ Liệu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      subtitle: Text("Đồng bộ dữ liệu lên đám mây"),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                      onTap: () async {
                        await synchronyData(false);
                      }
                  ),
                  ListTile(
                      leading: Icon(Icons.download, color: Colors.black,),
                      title: Text("Tải Bộ Dữ Liệu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      subtitle: Text("Tải bộ dữ liệu đã dồng bộ trên máy củ của bạn"),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                      onTap: (){
                        showBottomSheetConfirmAsynchrony(context);
                      }
                  ),
                  ListTile(
                      leading: Icon(Icons.logout, color: Colors.red,),
                      title: Text("Đăng Xuất", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),),
                      subtitle: Text("Đăng xuất khỏi tài khoản hiện tại", style: TextStyle(color: Colors.red),),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.red,),
                      onTap: () async {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        final DatabaseHelper db = DatabaseHelper.instance;
                        await synchronyData(true);
                        prefs.clear();
                        db.clearAllData();
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
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