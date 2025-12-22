import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/module/notification.dart';
import 'package:japaneseapp/core/Screen/detailsNotificationScreen.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

import '../Service/Server/NotificationService.dart';

class notificationsScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _notificationsScreen();
}

class _notificationsScreen extends State<notificationsScreen>{

  Future<List<NotificationModel>> loadData() async {
    Notificationservice notificationservice = new Notificationservice();
    List<NotificationModel> datas = await notificationservice.getAllNotification(FirebaseAuth.instance.currentUser!.uid);
    return datas;
  }

  Future<Widget> notificationView(NotificationModel notification) async {
    final LocalDbService localDbService = LocalDbService.instance;
    bool isRead = await localDbService.readnotificationDao.isNotificationRead(notification.id);
    return GestureDetector(
      onTap: () async {
        if(!(await localDbService.readnotificationDao.isNotificationRead(notification.id))){
          await localDbService.readnotificationDao.insertReadNotification(notification.id);
        }

        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>detailsNotificationScreen(
              title: notification.title,
              description: notification.description
          )));
        });
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          width: MediaQuery.sizeOf(context).width / 1.1,
          constraints: BoxConstraints(
            minWidth: 100,
            maxHeight: 120
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    offset: Offset(2, 2)
                )
              ]
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width-100,
                      child: Text(
                        notification.title,
                        style: TextStyle(fontSize: 18),
                        maxLines: 1, // hoặc nhiều hơn nếu bạn muốn
                        overflow: TextOverflow.ellipsis, // để cho xuống dòng
                        softWrap: true,

                      ),
                    ),
                    Icon(Icons.notifications, color: isRead ? Colors.grey : AppColors.primary,)
                  ],
                ),
                Text(
                  notification.description,
                  maxLines: 2, // chỉ hiện 2 dòng
                  overflow: TextOverflow.ellipsis, // tự động thêm "..."
                  style: TextStyle(fontSize: 14),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(notification.createdAt),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        scrolledUnderElevation: 0,
        title: Text("Thông Báo", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Container(
        color: AppColors.backgroundPrimary,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Lỗi: ${snapshot.error}"));
              }
              if (snapshot.hasData) {
                final datas = snapshot.data!;
                return Column(
                  children: datas.map((e) => FutureBuilder(future: notificationView(e), builder: (ctx, data){
                    if(data.connectionState == ConnectionState.waiting){
                      return Container();
                    }

                    if(data.hasData){
                      return data.data!;
                    }
                    return Container();
                  })).toList(),
                );
              }
              return Center(child: Text("Không có dữ liệu"));
            },
          )
        )
      ),
    );
  }

}