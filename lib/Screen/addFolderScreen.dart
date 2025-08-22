import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Screen/dashboardScreen.dart';

import '../Config/dataHelper.dart';

class addFolderScreen extends StatefulWidget{
  final Function reloadScreen;


  const addFolderScreen({super.key, required this.reloadScreen});

  @override
  State<StatefulWidget> createState() => _addFolderScreen();
}

class _addFolderScreen extends State<addFolderScreen>{
  TextEditingController nameFolderInput = TextEditingController();
  String? textErrorName;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.close, size: 40,)),
        actions: [
          IconButton(
            icon: Icon(Icons.done, size: 40, color: Colors.green,),
            onPressed: () async {
              if(nameFolderInput.text == "") {
                setState(() {
                  textErrorName = "Vui Lòng Nhập Tên Thư Mục";
                });
                return;
              } else {
                if (await DatabaseHelper.instance.hasFolderName(nameFolderInput.text)) {
                  setState(() {
                    textErrorName = "Tên Thư Mục Đã Tồn Tại";
                  });
                } else {
                  await DatabaseHelper.instance.insertNewFolder(nameFolderInput.text);

                  Navigator.of(context).pop();
                  dashboardScreen.globalKey.currentState?.reloadScreen();
                }
              }
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Icon(Icons.folder_open, size: 80,),
            SizedBox(height: 10,),
            Container(
              width: 250,
              child: TextField(
                controller: nameFolderInput,
                decoration: InputDecoration(
                  labelText: "Tên Thư Mục",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  errorText: textErrorName,
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}