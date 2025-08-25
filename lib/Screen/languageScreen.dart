import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../generated/app_localizations.dart';

/// Widget hiển thị 1 lá cờ và mã quốc gia
class _FlagItem extends StatelessWidget {
  const _FlagItem({
    required this.flag,
    required this.countryCode,
  });

  final CountryFlag flag;
  final String countryCode;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // ✅ Tránh lỗi Expanded không giới hạn
      children: [
        ClipOval(
          child: SizedBox(
            width: 60,
            height: 60,
            child: FittedBox(
              fit: BoxFit.cover, // giữ nội dung đầy đủ trong khung tròn
              child: CountryFlag.fromCountryCode(
                countryCode,
                width: 80,  // lớn hơn để đảm bảo chất lượng
                height: 60,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Màn hình chọn ngôn ngữ (Language Screen)
class languageScreen extends StatefulWidget {
  const languageScreen({Key? key, required this.changeLanguage}) : super(key: key);

  final Function(Locale _locale) changeLanguage;

  @override
  State<languageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<languageScreen> {
  String languageChosen = "";

  void _showLanguageChangeSuccess() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.language_bottomsheet_success,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tạo widget hiển thị cờ dựa trên mã quốc gia
  Widget _buildCountryFlag(String countryCode) => _FlagItem(
    flag: CountryFlag.fromCountryCode(
      countryCode,
      width: 60,
      height: 60,
    ),
    countryCode: countryCode,
  );

  /// Widget chọn ngôn ngữ
  Widget choseLanguage(String code, String nameCountry) {
    return GestureDetector(
      onTap: (){
        setState(() {
          if(languageChosen != code){
            languageChosen = code;
          }
        });
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width-20,
        height: 90,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: languageChosen == code ? Color.fromRGBO(247, 255, 247, 0.7019607843137254) : Colors.white,
          border: Border.all(
            color: languageChosen == code ? Colors.green : Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          children: [
            _buildCountryFlag(code),
            SizedBox(width: 10,),
            Text(nameCountry, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)// Cờ Việt Nam
          ],
        ),
      ),
    );
  }

  Future<void> changeLanguase() async {
    if(languageChosen == "VN") widget.changeLanguage(const Locale("vi"));
    if(languageChosen == "US") widget.changeLanguage(const Locale("us"));
  }


  void setLanguageChosen() {
    if(languageChosen == ""){
      if(Localizations.localeOf(context).languageCode == "vi" ) languageChosen = "VN";
      if(Localizations.localeOf(context).languageCode == "en" ) languageChosen = "US";
    }
  }

  String changeLanguageCode(){
    if(Localizations.localeOf(context).languageCode == "vi") return "VN";
    if(Localizations.localeOf(context).languageCode == "en") return "US";
    return "";
  }

  String changLanguageFromCode(){
    if(languageChosen == "VN") return "vi";
    if(languageChosen == "US") return "us";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    setLanguageChosen();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
        ),
        title: Text(
          AppLocalizations.of(context)!.language_title,
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if(languageChosen != changeLanguageCode()){
                await changeLanguase();
                print(Localizations.localeOf(context).languageCode);
                SharedPreferences prefile = await SharedPreferences.getInstance();
                prefile.setString("language", changLanguageFromCode());
                _showLanguageChangeSuccess();
              }
            },
            icon: const Icon(Icons.check, color: Colors.green, size: 30),
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              choseLanguage("VN", "Việt Nam"),
              const SizedBox(height: 10,),
              choseLanguage("US", "English (US)"),
            ],
          ),
        ),
      )
    );
  }
}
