import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Module/topic.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/Widget/topicServerWidget.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/tabhome/bottom_sheet_dowload_pulic.dart';

class CommunitySection extends StatelessWidget{
  final List<dynamic> data;
  const CommunitySection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if(data.isEmpty)
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 180,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.sizeOf(context).width,
                  height: 180,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.folder, color: AppColors.grey, size: 50,),
                      const Text("Không có dữ liệu", style: TextStyle(fontFamily: "" ,color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: Text("Hiện tại không có thư mục nào. Hãy đăng thư mục đầu tiên của bạn",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.textSecond.withOpacity(0.5),
                              fontSize: 15,
                              height: 1.8,
                              fontFamily: ""
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if(data.isNotEmpty)
              for(topic topicServer in data)
                topicServerWidget(
                  name: topicServer.name,
                  owner: topicServer.owner ?? '',
                  amount: topicServer.count??0,
                  id: topicServer.id,
                  showBottomShetDownload: (String id) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => BottomSheetDownloadPublic(
                        id: id,
                        nameTopic: topicServer.name,
                      ),
                    );
                  },
                ),

          ],
        ),
      ),
    );
  }

}