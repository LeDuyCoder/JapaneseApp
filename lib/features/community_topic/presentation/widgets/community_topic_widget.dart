import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/community_topic/domain/entities/community_topic_entity.dart';
import 'package:japaneseapp/features/community_topic/presentation/pages/dowload_community_topic_page.dart';

class CommunityTopicWidget extends StatefulWidget{

  final CommunityTopicEntity communityTopicEntity;
  final double? width;
  final Function(String id) showBottomShetDownload;
  final Function() reloadState;

  const CommunityTopicWidget({super.key, required this.communityTopicEntity, this.width, required this.showBottomShetDownload, required this.reloadState});


  @override
  State<StatefulWidget> createState() => _topicServerWidget();
}

class _topicServerWidget extends State<CommunityTopicWidget>{

  Future<bool> hastTopic(String id) async {
    final db = LocalDbService.instance;
    return await db.topicDao.hasTopicID(id);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if(!widget.communityTopicEntity.isExist) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DowloadCommunityTopicPage(
                  topicId: widget.communityTopicEntity.topicId)));
          widget.reloadState();
        }
      },
      child: Ink(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          width: widget.width ?? double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 6),
                blurRadius: 12,
                spreadRadius: 5
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.communityTopicEntity.nameTopic,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  widget.communityTopicEntity.isExist ? const Icon(Icons.done, color: AppColors.primary,) : Icon(CupertinoIcons.globe, color: Colors.grey,)
                ],
              ),
              Divider(
                color: Colors.grey.withOpacity(0.3),
                thickness: 1,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 140,
                        child: Text(
                          widget.communityTopicEntity.userName,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecond.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  /// WORD COUNT
                  Row(
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.communityTopicEntity.wordCount}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecond.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}