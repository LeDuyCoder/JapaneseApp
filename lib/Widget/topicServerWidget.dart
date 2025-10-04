import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Theme/colors.dart';

import '../Service/Local/local_db_service.dart';

class topicServerWidget extends StatefulWidget{

  final String id;
  final String name;
  final String owner;
  final int amount;
  final double? width;
  final Function(String id) showBottomShetDownload;

  const topicServerWidget({super.key, required this.name, required this.owner, required this.amount, required this.id , this.width, required this.showBottomShetDownload});

  @override
  State<StatefulWidget> createState() => _topicServerWidget();
}

class _topicServerWidget extends State<topicServerWidget>{

  Future<bool> hastTopic(String id) async {
    final db = LocalDbService.instance;
    return await db.topicDao.hasTopicID(id);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if(!(await hastTopic(widget.id))){
          widget.showBottomShetDownload(widget.id);
        }
      },
      child: Ink(
        child: Container(
            margin: EdgeInsets.only(left: 5, right: 10, top: 5, bottom: 5),
            padding: const EdgeInsets.only(left: 25, right: 15),
            width: widget.width ?? 310,
            height: 120,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 5
                  )
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width*0.5,
                      child: Text(widget.name, style: TextStyle(fontSize: 20, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis, maxLines: 1,),
                    ),
                    FutureBuilder(future: hastTopic(widget.id), builder: (ctx, data){
                      if(data.hasData && data.data!){
                        return Icon(Icons.download_done, color: Colors.green,);
                      }

                      return  const Icon(Icons.public, color: Colors.grey,);
                    })
                  ],
                ),
                const Divider(
                  color: Colors.grey, // Màu của đường kẻ
                  thickness: 1,
                  indent: 0,
                  endIndent: 5,// Độ dày
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Row(
                          children: [
                            Icon(Icons.person, color: AppColors.primary,),
                            SizedBox(width: 5,),
                            Text(widget.owner, style: TextStyle(fontSize: 20, color: AppColors.textSecond.withOpacity(0.5)), overflow: TextOverflow.ellipsis, maxLines: 1,),
                          ],
                        )
                    ),
                    Row(
                      children: [
                        Icon(Icons.book, color: AppColors.primary),
                        Text("${widget.amount}", textAlign: TextAlign.right , style: TextStyle(fontSize: 20, color: AppColors.textSecond.withOpacity(0.5)), overflow: TextOverflow.ellipsis, maxLines: 1,),
                      ],
                    )
                  ],
                ),

              ],
            )
        ),
      ),
    );
  }

}