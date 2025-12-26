import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/utils/date_formatter.dart';
import 'package:japaneseapp/features/manager_topic/domain/entities/folder_entity.dart';
import 'package:japaneseapp/features/manager_topic/presentation/pages/manager_topic_page.dart';

class BoxFolderGridWidget extends StatelessWidget{
  final FolderEntity folderEntity;

  const BoxFolderGridWidget({super.key, required this.folderEntity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ManagerTopicPage(idFolder: folderEntity.id, nameFolder: folderEntity.name),
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: AppColors.grey,
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.folder_open,
                  size: 32,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 10),

              // Folder name
              Text(
                folderEntity.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 6),

              // Info phụ
              Column(
                children: [
                  Text(
                    DateFormatter.format(folderEntity.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecond,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${folderEntity.amountTopic} Chủ đề",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecond,
                    ),
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