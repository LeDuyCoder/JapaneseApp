import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/community_topic/presentation/pages/dowload_community_topic_page.dart';
import 'package:japaneseapp/features/dashboard/domain/models/topic_model.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/topic_server_widget.dart';

class CommunitySection extends StatelessWidget{
  final List<dynamic> data;
  final Function() refechState;

  const CommunitySection({super.key, required this.data, required this.refechState});

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
                        padding: const EdgeInsets.only(left: 50, right: 50),
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
              for(TopicEntity topicServer in data)
                topicServerWidget(
                  name: topicServer.name,
                  owner: topicServer.owner ?? '',
                  amount: topicServer.count??0,
                  id: topicServer.id,
                  onTap: (String id) async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => DowloadCommunityTopicPage(topicId: id)));
                    refechState();

                  },
                ),

          ],
        ),
      ),
    );
  }

}