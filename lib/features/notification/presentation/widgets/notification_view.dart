import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/notification/domain/entities/notification_entity.dart';
import 'package:japaneseapp/features/notification/presentation/pages/detail_notification_page.dart';

class NotificationView extends StatelessWidget{
  final NotificationEntity notificationEntity;
  final Function() onMark;

  const NotificationView({super.key, required this.notificationEntity, required this.onMark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await onMark();
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailNotificationPage(notificationEntity: notificationEntity)));
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
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
                        notificationEntity.title,
                        style: TextStyle(fontSize: 18),
                        maxLines: 1, // hoặc nhiều hơn nếu bạn muốn
                        overflow: TextOverflow.ellipsis, // để cho xuống dòng
                        softWrap: true,

                      ),
                    ),
                    Icon(Icons.notifications, color: notificationEntity.isRead ? Colors.grey : AppColors.primary,)
                  ],
                ),
                Text(
                  notificationEntity.description,
                  maxLines: 2, // chỉ hiện 2 dòng
                  overflow: TextOverflow.ellipsis, // tự động thêm "..."
                  style: TextStyle(fontSize: 14),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(notificationEntity.createdAt),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

}