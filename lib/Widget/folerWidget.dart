import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Screen/folderManagerScreen.dart';

class folderWidget extends StatelessWidget{

  final String nameFolder;
  final void Function() reloadDashboard;

  const folderWidget({super.key, required this.nameFolder, required this.reloadDashboard});

  void removeFolder(BuildContext context) async {
    DatabaseHelper db = DatabaseHelper.instance;
    await db.deleteData("folders", "namefolder = '${nameFolder}'");
    Navigator.pop(context);
    reloadDashboard();
  }

  void showDialogDeleteFolder(BuildContext context){
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
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.red, // Màu xanh cạnh trên ngoài cùng
                      width: 10.0, // Độ dày của cạnh trên
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Xóa Folder',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Bạn có xác nhận muốn xóa không',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  removeFolder(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5, bottom: 10, top: 10),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                        color: Colors.red
                                      )
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Có",
                                        style: TextStyle(color: Colors.red, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 10, bottom: 10, top: 10),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Không",
                                        style: TextStyle(color: Colors.white, fontSize: 15),
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
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onLongPress: (){
          showDialogDeleteFolder(context);
        },
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