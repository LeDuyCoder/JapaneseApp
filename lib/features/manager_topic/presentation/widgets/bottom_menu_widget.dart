import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/core/service/Local/local_db_service.dart';

class BottomMenuWidget extends StatelessWidget{
  final int idFolder;
  final void Function()? onDeleteFolder;

  const BottomMenuWidget({super.key, required this.idFolder, this.onDeleteFolder});

  @override
  Widget build(BuildContext context) {
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

          ListTile(
            leading: const Icon(Icons.restore_from_trash_rounded, color: Colors.red),
            title: Text(AppLocalizations.of(context)!.folderManager_bottomSheet_removeFolder,
                style: TextStyle(color: Colors.red, fontSize: 18)),
            onTap: onDeleteFolder
          ),

          SizedBox(height: 10,),

          // Nút chọn: Thư mục
        ],
      ),
    );
  }

}