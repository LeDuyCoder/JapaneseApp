import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class DeleteDialogWidget extends StatelessWidget{
  final String nameTopic;
  final String idTopic;

  const DeleteDialogWidget({super.key, required this.nameTopic, required this.idTopic});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)) // Bo góc popup
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Container(
              child: Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/character/hinh1.png", width: MediaQuery.sizeOf(context).width*0.3,),
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        const AutoSizeText(
                          "Xóa chủ đề",
                          style: TextStyle(fontFamily: "Itim", fontSize: 25),
                        ),

                        AutoSizeText(
                          "Bạn có muốn xóa không",
                          style: TextStyle(fontFamily: "Itim", color: AppColors.textSecond.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width*0.3,
                            height: MediaQuery.sizeOf(context).height*0.05,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                ]
                            ),
                            child: const Center(
                              child: Text("Cancle", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
                            ),
                          ),

                        ),
                        SizedBox(width:10,),
                        GestureDetector(
                          onTap: () async {
                            final db = LocalDbService.instance;
                            db.databseDao.deleteData("topic", "name = '$nameTopic'");
                            db.databseDao.deleteData("words", "topic = '$idTopic'");
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: MediaQuery.sizeOf(context).height * 0.05,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Center(
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
          );
        },
      ),
    );
  }

}