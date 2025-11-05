import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/core/Screen/WordbookScreen.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:language_detector/language_detector.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

import '../Config/config.dart';
import '../Service/Local/local_db_service.dart';
import '../generated/app_localizations.dart';

class dictionaryScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _dictionaryScreen();
}

class _dictionaryScreen extends State<dictionaryScreen>{
  int sizeArgs = 0;
  TextEditingController inputWord = TextEditingController();
  Map<dynamic, dynamic>? data;
  String status = "wating";
  String example = "";
  late InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  int amountSearch = 0;
  bool isSearching = false;
  LinkedHashSet<String> historySearch = LinkedHashSet();

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Config.admodId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
          _interstitialAd = null;
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd(); // load mới sau khi đóng
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
      amountSearch = 0;
    } else {
      print("InterstitialAd chưa sẵn sàng");
    }
  }


  Future<String> generateExample(String word, String languageCode) async {
    final String url = "https://tatoeba.org/en/api_v0/search?query=${word}&from=jpn&to=$languageCode";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String ex = data["results"][0]["translations"][0].length == 0
            ? data["results"][0]["translations"][1][0]["text"]
            : data["results"][0]["translations"][0][0]["text"];

        return data["results"][0]["text"] + "- " + ex;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  void addHistorySearch(String text) {
    historySearch.remove(text);
    historySearch.add(text);

    if (historySearch.length > 10) {
      historySearch.remove(historySearch.first);
    }
  }

  Future<void> _callApi(String query) async {
    amountSearch++;
    example = "";
    data = await fetchData(query);
    addHistorySearch(query);

    setState(() {
      isSearching = false;
    });

    if (data != null) {
      String word = (data!["data"][0]["japanese"][0] as Map<dynamic, dynamic>)
          .containsKey("word")
          ? data!["data"][0]["japanese"][0]["word"]
          : data!["data"][0]["slug"];

      example = await generateExample(word, "vie");
      final db = LocalDbService.instance;
      bool isExist = await db.vocabularyDao.isVocabularyExist(wordJp: word, wordKana: data!["data"][0]["japanese"][0]["reading"]??"");
      data!["stored"] = isExist;
      setState(() {
        status = data == null ? "fail" : "done";
      });
    }



    setState(() {
      status = "done";
    });

    if (_isInterstitialAdReady && amountSearch >= 15) {
      _showInterstitialAd();
    }
  }


  Future<String> detectLanguage(String word) async{
    var code = await LanguageDetector.getLanguageCode(
        content: word);
    if(code == "vi"){
      return (await translateEnglish(word));
    }

    return word;
  }

  Future<String> translateEnglish(String input) async{
    try{
      final translator = GoogleTranslator();
      String translation = (await translator.translate(input, to: 'en')).toString();
      return translation;
    }catch(e){
      return input;
    }
  }

  Future<String> translateToLocalLanguage(String word, String languageCode) async{
    final translator = GoogleTranslator();
    String translation = (await translator.translate(word, to: languageCode)).toString();
    return translation;
  }

  void onChange(String value){
    if(inputWord.text.trim().isEmpty){
      setState(() {
        status = "wating";
      });
    }else{
      if(isSearching == false){
        setState(() {
          isSearching = true;
          status = "waiting";
        });
      }
    }
  }

  Future<Map<dynamic, dynamic>> fetchData(String word) async {
    String wordSearch = await detectLanguage(word);
    final String url = "https://jisho.org/api/v1/search/words?keyword=${wordSearch.toLowerCase()}"; // Thay URL API của bạn
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        sizeArgs = (data["data"] as List<dynamic>).length;
        setState(() {
          status = "done";
        });
        return sizeArgs > 0 ? data : null;
      } else {
        status = "fail";
        return {};
      }
    } catch (e) {
      status = "fail";
      return {};
    }
  }

  String hanldMean(List<dynamic> listData){
    StringBuffer data = StringBuffer();
    for(String stringData in listData){
      data.write("${stringData}, ");
    }
    return data.toString();
  }

  Widget wordSameWidget(String word){
    return GestureDetector(
      onTap: (){
        setState(() {
          inputWord.text = word;
          status = "loading";
        });

        _callApi(word);
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Giữ padding nhưng điều chỉnh cho phù hợp
        decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          word,
        ),
      ),
    );
  }

  Widget buildHistorySearch(){
    return Container(
      width: MediaQuery.sizeOf(context).width/1.05,
      constraints: BoxConstraints(
        minHeight: 50,
        maxHeight: 150
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: AppColors.grey,
                offset: Offset(0, 2),
                blurRadius: 10
            )
          ]
      ),
      child: ListView(
        children: historySearch.map((e) => GestureDetector(
          onTap: (){
            setState(() {
              inputWord.text = e;
              status = "loading";
            });

            _callApi(e);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: AppColors.grey.withOpacity(0.3),
                            width: 1
                        )
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.history),
                    Text(e, style: TextStyle(fontSize: 20, fontFamily: "Itim"),),
                  ],
                )
            ),
          ),
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.distionary_Screen_title, style: TextStyle(color: AppColors.primary, fontFamily: "Itim", fontSize: 30),),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundPrimary,
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        color: AppColors.backgroundPrimary,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      width: MediaQuery.sizeOf(context).width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0), // pill shape
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26, // shadow mờ hơn
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: onChange,
                        controller: inputWord,
                        decoration: InputDecoration(
                          border: InputBorder.none, // bỏ border mặc định
                          prefixIcon: Icon(Icons.translate, color: Colors.black, size: 30,),
                          hintText: AppLocalizations.of(context)!.distionary_Screen_hint,
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                        ),
                      )
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      status = "loading";
                    });

                    if(inputWord.text.trim().isNotEmpty) {
                      _callApi(inputWord.text.trim());
                    }
                  },
                  child: Container(
                    width: 58,
                    height: 58,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.search, color: Colors.white,),
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    if(isSearching)
                      buildHistorySearch(),
                    SizedBox(
                      height: 20,
                    ),
                    if(status == "fail")
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 10
                              )
                            ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outlined, color: AppColors.primary, size: 50,),
                            Text("Không Tìm Thấy", style: TextStyle(fontSize: 20, fontFamily: "Itim"),),
                            Text("Từ bạn vừa nhập không tìm thấy trong từ điển", style: TextStyle(fontFamily: "itim", color: AppColors.textSecond.withOpacity(0.5)),)
                          ],
                        ),
                      ),
                    if( status == "done")
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
                        width: MediaQuery.sizeOf(context).width,
                        constraints: const BoxConstraints(
                          maxHeight: 600, // 👈 minHeight cho cả container
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: SingleChildScrollView( // 👈 thêm scroll
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (data!["data"][0]["japanese"][0] as Map<dynamic, dynamic>)
                                        .containsKey("word")
                                        ? data!["data"][0]["japanese"][0]["word"]
                                        : data!["data"][0]["slug"],
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final db = LocalDbService.instance;
                                      String word = (data!["data"][0]["japanese"][0] as Map<dynamic, dynamic>)
                                          .containsKey("word")
                                          ? data!["data"][0]["japanese"][0]["word"]
                                          : data!["data"][0]["slug"];
                                      String wordKana = data!["data"][0]["japanese"][0]["reading"]??"";
                                      if(data != null && data!["stored"] == false){
                                        String mean = await translateToLocalLanguage(
                                          "${hanldMean(data!["data"][0]["senses"][0]["english_definitions"])}",
                                          "vi",
                                        );

                                        String exampleJp = "";
                                        String exampleVi = "";

                                        if(example.isNotEmpty){
                                          exampleJp = example.split("-").isNotEmpty ? example.split("-")[0] : "";
                                          exampleVi = example.split("-").isNotEmpty ? example.split("-")[1] : "";
                                        }
                                        if(example == "" || example.isEmpty){
                                          db.vocabularyDao.addVocabularyInDistionary(wordJp: word, wordKana: wordKana, wordMean: mean);
                                        }else{
                                          db.vocabularyDao.addVocabularyInDistionary(wordJp: word, wordKana: wordKana, wordMean: mean, exampleJp: exampleJp, exampleVi: exampleVi);
                                        }
                                        setState(() {
                                          status = "loading";
                                        });
                                        _callApi(word);
                                      }
                                      else{
                                        db.vocabularyDao.removeVocabulary(wordJp: word, wordKana: wordKana);
                                        setState(() {
                                          status = "loading";
                                        });
                                        _callApi(word);
                                      }
                                    }, icon: Icon(
                                    (data != null && data!["stored"] == true) ? CupertinoIcons.heart_fill : AntDesign.heart_outline,
                                    size: 30,
                                    color: (data != null && data!["stored"] == true)
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  )
                                ],
                              ),
                              Text(
                                data!["data"][0]["japanese"][0]["reading"]??"",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.textSecond.withOpacity(0.5),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                AppLocalizations.of(context)!.distionary_Screen_mean,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.textPrimary,
                                  fontFamily: "Itim",
                                ),
                              ),
                              Divider(
                                height: 2,
                                color: AppColors.grey.withOpacity(0.3),
                              ),
                              SizedBox(height: 10),
                              Container(
                                constraints: BoxConstraints(minHeight: 50),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(color: AppColors.primary, width: 2),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: FutureBuilder(
                                        future: translateToLocalLanguage(
                                          "${hanldMean(data!["data"][0]["senses"][0]["english_definitions"])}",
                                          "vi",
                                        ),
                                        builder: (ctx, dataText) {
                                          if (dataText.hasData) {
                                            return Text(
                                              dataText.data!,
                                              style: TextStyle(fontSize: 15, fontFamily: "Itim"),
                                            );
                                          }
                                          return Center();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              if (example != "" && example.isNotEmpty)
                                Container(
                                    constraints: BoxConstraints(minHeight: 50),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(color: AppColors.primary, width: 2),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            example,
                                            style: TextStyle(fontSize: 15, fontFamily: "Itim"),
                                          ),
                                        )
                                      ],
                                    )
                                ),
                              SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.distionary_Screen_info,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.textPrimary,
                                  fontFamily: "Itim",
                                ),
                              ),
                              Divider(
                                height: 2,
                                color: AppColors.grey.withOpacity(0.3),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)!.distionary_Screen_type} ${
                                        (
                                            data != null &&
                                                data?["data"] != null &&
                                                data?["data"].isNotEmpty &&
                                                data?["data"][0]["senses"] != null &&
                                                data?["data"][0]["senses"].isNotEmpty &&
                                                data?["data"][0]["senses"][0]["parts_of_speech"] != null &&
                                                data?["data"][0]["senses"][0]["parts_of_speech"].isNotEmpty
                                        )
                                            ? data!["data"][0]["senses"][0]["parts_of_speech"][0]
                                            : ""

                                    }",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.textPrimary.withOpacity(0.6),
                                      fontFamily: "Itim",
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "${AppLocalizations.of(context)!.distionary_Screen_level} ${
                                        (data != null &&
                                            data!["data"] != null &&
                                            data!["data"].isNotEmpty &&
                                            data!["data"][0]["jlpt"] != null &&
                                            data!["data"][0]["jlpt"].isNotEmpty &&
                                            data!["data"][0]["jlpt"][0].contains("-") &&
                                            data!["data"][0]["jlpt"][0].split("-").length > 1
                                        )
                                            ? data!["data"][0]["jlpt"][0].split("-")[1].toUpperCase()
                                            : "null"
                                    }",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.textPrimary.withOpacity(0.6),
                                      fontFamily: "Itim",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  for (int i = 1; i < sizeArgs; i++)
                                    wordSameWidget(
                                      (data!["data"][i]["japanese"][0] as Map<dynamic, dynamic>)
                                          .containsKey("word")
                                          ? data!["data"][i]["japanese"][0]["word"]
                                          : data!["data"][i]["slug"],
                                    ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    if(status == "loading")
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 10
                              )
                            ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 220,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),

                            SizedBox(height: 10,),
                            Container(
                              width: 180,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            SizedBox(height: 10,),
                            Divider(
                              height: 2,
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              constraints: BoxConstraints(minHeight: 50), // Thiết lập chiều cao tối thiểu
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: AppColors.primary,
                                          width: 2
                                      )
                                  )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 20,
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            if(example != "" && example.isNotEmpty)
                              Container(
                                constraints: BoxConstraints(minHeight: 50), // Thiết lập chiều cao tối thiểu
                                decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: AppColors.primary,
                                            width: 2
                                        )
                                    )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Container(
                                          width: MediaQuery.sizeOf(context).width,
                                          child: Text(
                                            example,
                                            style: TextStyle(fontSize: 15, fontFamily: "Itim"),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            SizedBox(height: 10,),
                            Container(
                              width: 220,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            SizedBox(height: 10,),
                            Divider(
                              height: 2,
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              child: Row(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 150,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              child: Wrap(
                                spacing: 8.0, // Khoảng cách giữa các widget theo chiều ngang
                                runSpacing: 8.0, // Khoảng cách giữa các dòng
                                children: [
                                  Container(
                                    width: 150,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),

                                  Container(
                                    width: 120,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                  Container(
                                    width: 90,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,)
                          ],
                        ),
                      ),

                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 400),
                              pageBuilder: (context, animation, secondaryAnimation) => WordbookScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                // Slide từ dưới lên
                                var slideTween = Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).chain(CurveTween(curve: Curves.easeOutCubic));

                                // Fade mượt
                                var fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                                    .chain(CurveTween(curve: Curves.easeOut));

                                return SlideTransition(
                                  position: animation.drive(slideTween),
                                  child: FadeTransition(
                                    opacity: animation.drive(fadeTween),
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: const Row(
                          children: [
                            Icon(Icons.book, size: 40, color: Colors.white),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Sổ từ vựng",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
        onWillPop: (){
          return Future.value(false);
        });
  }

}