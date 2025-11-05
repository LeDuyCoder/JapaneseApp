import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/core/DTO/UserDTO.dart';
import 'package:japaneseapp/core/Module/notification.dart';
import 'package:japaneseapp/core/Screen/notificationsScreen.dart';
import 'package:japaneseapp/core/Screen/rankScreen.dart';
import 'package:japaneseapp/core/Screen/storeScreen.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';
import 'package:japaneseapp/features/shop/presentation/pages/shop_page.dart';

class featureScreen extends StatefulWidget{
  final UserModel userModel;
  final Function() reload;

  const featureScreen({super.key, required this.userModel, required this.reload});

  @override
  State<StatefulWidget> createState() => _featureScreen();
}

class _featureScreen extends State<featureScreen>{

  Future<int> loadNotificationNotRead() async {
    int notificationNotRead = 0;

    final LocalDbService localDbService = LocalDbService.instance;
    List<NotificationModel> listNotifcations = await ServiceLocator.notificationservice.getAllNotification(FirebaseAuth.instance.currentUser!.uid);
    for(NotificationModel notificationModel in listNotifcations){
      if(!(await localDbService.readnotificationDao.isNotificationRead(notificationModel.id))){
        notificationNotRead++;
      }
    }

    return notificationNotRead;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundPrimary,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
          widget.reload();
        }, icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: AppColors.backgroundPrimary,
        child: FutureBuilder(future: loadNotificationNotRead(), builder: (context, data){
          if(data.connectionState == ConnectionState.waiting){
            return Container();
          }

          if(data.hasData){
            return Column(
              children: [
                ListTile(
                  leading: Badge(
                    label: Text(
                      '${data.data!}',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(Icons.notifications),
                    isLabelVisible: data.data! >= 1,
                  ),
                  title: const Row(
                    children: [
                      Text(
                        "Thông Báo",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  subtitle: const Text("Nhận tin tức từ quản trị viên"),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            notificationsScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var scaleTween = Tween<double>(begin: 0.5, end: 1.0)
                              .chain(CurveTween(curve: Curves.elasticOut)); // bật nhẹ
                          var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

                          return FadeTransition(
                            opacity: animation.drive(fadeTween),
                            child: ScaleTransition(
                              scale: animation.drive(scaleTween),
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                    leading: Icon(FontAwesome.ranking_star_solid, color: Colors.black,),
                    title: const Text("Bảng xếp hạng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    subtitle: const Text("Danh sách đua top tuần"),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => rankScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(-1.0, 0.0);
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
                    }
                ),
                ListTile(
                    leading: Icon(Icons.store, color: Colors.black,),
                    title: const Text("Cửa Hàng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    subtitle: const Text("Nơi bán sản phẩm"),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => ShopPage(userModel: widget.userModel,),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(-1.0, 0.0);
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
                    }
                ),
              ],
            );
          }

          return Container();

        }),
      ),
    );
  }

}