import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Screen/folderManagerScreen.dart';
import 'package:japaneseapp/Theme/colors.dart';

class folderWidget extends StatelessWidget{

  final String nameFolder;
  final String dateCreated;
  final int idFolder;
  final int amountTopic;
  final void Function() reloadDashboard;

  const folderWidget({super.key, required this.nameFolder, required this.reloadDashboard, required this.dateCreated, required this.idFolder, required this.amountTopic});

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
      padding: EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => folderManagerScreen(
                idFolder: idFolder,
                nameFolder: nameFolder,
                reloadDashBoard: () {
                  reloadDashboard();
                },
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
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
        },
        child: Container(
            width: 250,
            height: 140,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 2),
                  blurRadius: 5,
                )
              ]
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(nameFolder, style: TextStyle(color: AppColors.textSecond, fontSize: 18, fontWeight: FontWeight.bold),),
                  Divider(
                    color: Colors.grey, // Màu của đường kẻ
                    thickness: 1,
                    indent: 0,
                    endIndent: 5,// Độ dày
                  ),
                  Text(dateCreated, style: const TextStyle(color: AppColors.textSecond),),
                  SizedBox(height: 10,),
                  Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Text("${amountTopic} chủ đề", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),),
                    )
                  )
                ],
              )
            )
        ),
      ),
    );
  }

}