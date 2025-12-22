import 'package:flutter/material.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/foler_widget.dart';

class FolderSection extends StatelessWidget {
  final List<Map<String,dynamic>> folders;
  const FolderSection({required this.folders});

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) {
      return Padding(padding: EdgeInsets.all(24), child: Text("Chưa có thư mục nào"));
    }
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var f in folders)
            FolderWidget(idFolder: f["id"], nameFolder: f["namefolder"]!, reloadDashboard: (){}, dateCreated: f["datefolder"], amountTopic: f["amountTopic"],),
        ],
      ),
    );
  }
}
