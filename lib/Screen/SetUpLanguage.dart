import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllScreen.dart';

class setUpLanguage extends StatefulWidget{
  final Function(Locale _locale) changeLanguage;

  const setUpLanguage({super.key, required this.changeLanguage});

  @override
  State<StatefulWidget> createState() => _setUpLanguage();
}


class _setUpLanguage extends State<setUpLanguage>{
  String languageCodeChose = "VN";
  String languageCodeSave = "vi";

  Widget languageWidget(String langaugeCode, String languageName, String languageNameLanguage, String languageCodesave){
    return GestureDetector(
      onTap: (){
        setState(() {
          languageCodeChose = langaugeCode;
          languageCodeSave = languageCodesave;
        });
      },
      child: Container(
          width: MediaQuery.sizeOf(context).width / 1.1,
          height: 100,
          decoration: BoxDecoration(
              color: langaugeCode == languageCodeChose ? Color.fromRGBO(
                  255, 243, 243, 1.0) : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: AppColors.grey,
                    offset: Offset(0, -1),
                    blurRadius: 5
                )
              ],
              border: Border.all(
                  color: langaugeCode == languageCodeChose ? AppColors.primary : Colors.white.withOpacity(0),
                  width: 2
              ),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(langaugeCode, style: TextStyle(fontSize: 28, fontFamily: "Itim", fontWeight: FontWeight.bold),),
                SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(languageName, style: TextStyle(fontSize: 20, fontFamily: "Itim", fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                    Text(languageNameLanguage, style: TextStyle(fontSize: 20, fontFamily: "Itim", color: AppColors.textSecond.withOpacity(0.6)), textAlign: TextAlign.left),
                  ],
                ),
                Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(langaugeCode == languageCodeChose ? Icons.check_circle : Icons.check_circle_outline, size: 30, color: langaugeCode == languageCodeChose ? AppColors.primary : Colors.black),
                    )
                )
              ],
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundPrimary,
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Text("KuJiLinGo", style: TextStyle(color: AppColors.primary, fontSize: 60, fontFamily: "Itim", fontWeight: FontWeight.bold),),
              Text("Học tiếng Nhật mọi lúc, mọi nời", style: TextStyle(color: AppColors.textSecond.withOpacity(0.6), fontSize: 22, fontFamily: "Itim", height: 0.5),),
              SizedBox(height: 50,),
              Text("Chọn ngôn ngữ chính của bạn", textAlign: TextAlign.center ,style: TextStyle(color: AppColors.textSecond.withOpacity(1), fontSize: 30, fontFamily: "Itim", height: 1),),
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Chọn ngôn ngữ bạn muốn sử dụng làm ngôn ngữ chính trong ứng dụng. Bạn có thể thay đổi thiết lập này sau trong phần cài đặt.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecond.withOpacity(0.6), fontSize: 17, fontFamily: "Itim", height: 1),),
              ),
              const SizedBox(height: 50,),
              languageWidget("VN", "Tiếng Việt", "Vietnamese", "vi"),
              const SizedBox(height: 20,),
              languageWidget("US", "Tiếng Anh", "English", "en"),
              const SizedBox(height: 20,),
              languageWidget("JP", "Tiếng Nhật", "Japanese", "ja"),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefile = await SharedPreferences.getInstance();
                  prefile.setString("language", languageCodeSave);

                  widget.changeLanguage(Locale(languageCodeSave));

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
                },
                child: Container(
                    width: MediaQuery.sizeOf(context).width / 1.1,
                    height: 60,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.grey.withOpacity(0.5),
                              offset: Offset(0, -1),
                              blurRadius: 5
                          )
                        ],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Tiếp Tục", style: TextStyle(fontSize: 20, fontFamily: "Itim", fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

}