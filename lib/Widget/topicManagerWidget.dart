import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/Screen/listWordScreen.dart';

import '../Module/topic.dart';

class topicManagerWidget extends StatelessWidget{
  final topic dataTopic;
  final void Function() removeTopic;
  final void Function() reloadDashboard;

  const topicManagerWidget({super.key, required this.dataTopic, required this.removeTopic, required this.reloadDashboard});

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // để bo góc đẹp
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white, // màu nền dark
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thanh kéo ở giữa
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Nút chọn: Học phần
              ListTile(
                leading: const Icon(Icons.remove, color: Colors.red),
                title: const Text("Xóa khỏi thư mục",
                    style: TextStyle(color: Colors.red, fontSize: 18)),
                onTap: () {
                  removeTopic();
                  Navigator.pop(context);
                },
              ),

              SizedBox(height: 10,),

              // Nút chọn: Thư mục
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => listWordScreen(id: dataTopic.id, topicName: dataTopic.name, reloadDashboard: () {
          reloadDashboard();
        },)));
      },
      child: Container(
          width: MediaQuery.of(context).size.width-20,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.sticky_note_2_outlined, size: 30),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(213, 251, 213, 0.8),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      width: MediaQuery.sizeOf(context).width*0.65,
                      child: AutoSizeText(dataTopic.name, style: TextStyle(fontSize: 20),),
                    )
                  ],
                ),
              ),
              IconButton(onPressed: (){
                _showBottomMenu(context);
              }, icon: Icon(Icons.more_horiz, color: Colors.black, size: 30,))
            ],
          )
      ),
    );
  }
}