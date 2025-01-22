import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Screen/folderManagerScreen.dart';

class folderWidget extends StatelessWidget{

  final String nameFolder;
  final void Function() reloadDashboard;

  const folderWidget({super.key, required this.nameFolder, required this.reloadDashboard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>folderManagerScreen(nameFolder: nameFolder, reloadDashBoard: () {
            reloadDashboard();
          },)));
        },
        child: GestureDetector(
          child: Container(
              width: 250,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.folder_open_outlined, color: Colors.grey, size: 40,),
                    Text(this.nameFolder, style: TextStyle(fontFamily: "indieflower", fontSize: 20),)
                  ],
                ),
              )
          ),
        )
      ),
    );
  }

}