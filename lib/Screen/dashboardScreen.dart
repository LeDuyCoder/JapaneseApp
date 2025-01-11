import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Screen/addWordScreen.dart';
import 'package:japaneseapp/Widget/folerWidget.dart';

import '../Config/dataHelper.dart';
import '../Widget/topicWidget.dart';

class dashboardScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _dashboardScreen();

}

class _dashboardScreen extends State<dashboardScreen>{

  Map<String, List<Map<String, dynamic>>> dataDashBoards = {};

  TextEditingController nameFolderInput = TextEditingController();
  TextEditingController nameTopicInput = TextEditingController();
  String? textErrorName;
  bool isLoadingCreateNewFolder = false;


  Future<Map<String, List<Map<String, dynamic>>>> hanldeGetData() async {
    final db = await DatabaseHelper.instance;
    Map<String, List<Map<String, dynamic>>> data = {
      "topic": await db.getAllTopic(),
      "folder": await db.getAllFolder()
    };

    print(await db.getAllWordbyTopic("Travel"));
    return data;
  }

  Future<void> reload() async {
    dataDashBoards = await hanldeGetData();
    setState(() {});
  }

  void showPopupAddFolder() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(20, 195, 142, 1.0), // Màu xanh cạnh trên ngoài cùng
                      width: 10.0, // Độ dày của cạnh trên
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Add New Folder',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          width: MediaQuery.sizeOf(context).width - 100,
                          height: 100,
                          child: TextField(
                            controller: nameFolderInput,
                            decoration: InputDecoration(
                              hintText: "Name folder",
                              hintStyle: TextStyle(color: Colors.grey), // Màu chữ gợi ý
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 20.0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorText: textErrorName,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    textErrorName = null;
                                    nameFolderInput.text = "";
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 32, 32, 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState((){
                                    isLoadingCreateNewFolder = !isLoadingCreateNewFolder;
                                  });

                                  if(await DatabaseHelper.instance.hasFolderName(nameFolderInput.text)){
                                    setState(() {
                                      textErrorName = "Name Folder Exist";
                                    });
                                  }else{
                                    await DatabaseHelper.instance.insertNewFolder(nameFolderInput.text);
                                    await reload();
                                    Navigator.of(context).pop();
                                  }

                                  setState((){
                                    isLoadingCreateNewFolder = !isLoadingCreateNewFolder;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(184, 241, 176, 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Create",
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    isLoadingCreateNewFolder
                        ? Container(
                      height: 250,
                      color: const Color.fromRGBO(145, 145, 145, 0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      ),
                    )
                        : const SizedBox(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showPopupAddTopic() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(20, 195, 142, 1.0), // Màu xanh cạnh trên ngoài cùng
                      width: 10.0, // Độ dày của cạnh trên
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Add New Topic',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          width: MediaQuery.sizeOf(context).width - 100,
                          height: 100,
                          child: TextField(
                            controller: nameTopicInput,
                            decoration: InputDecoration(
                              hintText: "Name Topic",
                              hintStyle: TextStyle(color: Colors.grey), // Màu chữ gợi ý
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 20.0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorText: textErrorName,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    textErrorName = null;
                                    nameFolderInput.text = "";
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 32, 32, 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState((){
                                    isLoadingCreateNewFolder = !isLoadingCreateNewFolder;
                                  });

                                  if(await DatabaseHelper.instance.hasTopicName(nameTopicInput.text)){
                                    setState(() {
                                      textErrorName = "Name Topic Exist";
                                    });
                                  }else{
                                    //tranfer to screen add word
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => addWordScreen(topicName: nameTopicInput.text)));
                                  }

                                  setState((){
                                    isLoadingCreateNewFolder = !isLoadingCreateNewFolder;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(184, 241, 176, 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Create",
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    isLoadingCreateNewFolder
                        ? Container(
                      height: 250,
                      color: const Color.fromRGBO(145, 145, 145, 0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      ),
                    )
                        : const SizedBox(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          child: Text(
              "日本語",
            style: TextStyle(fontFamily: "aboshione", fontSize: 20, color: Colors.white),
          ),
        ),
        actions: const [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                "4 Topic",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: hanldeGetData(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No data available."));
            }

            dataDashBoards = snapshot.data as Map<String, List<Map<String, dynamic>>>;


            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Folder",
                          style: TextStyle(fontFamily: "indieflower", fontSize: 30),
                        ),
                        GestureDetector(
                            onTap: (){
                              showPopupAddFolder();
                            },
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(184, 241, 176, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  "+ ADD",
                                  style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                  dataDashBoards["folder"]!.isEmpty? Center(
                    child: Text("No Data", style: TextStyle(fontSize: 20),),
                  ) : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (Map<String, dynamic> folder in dataDashBoards["folder"]!)
                          folderWidget(nameFolder: folder["namefolder"]!),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Topic",
                          style: TextStyle(fontFamily: "indieflower", fontSize: 30),
                        ),
                        GestureDetector(
                          onTap: (){
                            showPopupAddTopic();
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(184, 241, 176, 1),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Center(
                              child: Text(
                                "+ ADD",
                                style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 3,
                      children: dataDashBoards["topic"]!.map((topic) => topicWidget(nameTopic: topic["name"])).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}