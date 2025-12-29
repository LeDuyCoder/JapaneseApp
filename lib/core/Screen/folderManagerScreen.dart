// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:japaneseapp/core/Module/topic.dart';
// import 'package:japaneseapp/core/Screen/addTopicFolder.dart';
// import 'package:japaneseapp/core/Screen/dashboardScreen.dart';
// import 'package:japaneseapp/core/Theme/colors.dart';
// import 'package:japaneseapp/core/Widget/topicManagerWidget.dart';
//
// import '../Service/Local/local_db_service.dart';
// import '../generated/app_localizations.dart';
//
// class folderManagerScreen extends StatefulWidget{
//   final String nameFolder;
//   final int idFolder;
//   final void Function() reloadDashBoard;
//
//   const folderManagerScreen({super.key, required this.nameFolder, required this.reloadDashBoard, required this.idFolder});
//
//   @override
//   State<StatefulWidget> createState() => _folderMangerScreen();
// }
//
// class _folderMangerScreen extends State<folderManagerScreen>{
//
//   topic? topicChose;
//   List<topic> dataTopicOut = [];
//
//
//
//   Future<List<topic>> hanldeDataTopic() async {
//     final db = LocalDbService.instance;
//     List<topic> result = [];
//     result = await db.folderDao.getAllTopicInFolder(widget.idFolder);
//     return result;
//   }
//
//   void removeTopic(String topicID) async {
//     final db = LocalDbService.instance;
//     await db.folderDao.deleteTopicFromFolder(widget.idFolder, topicID);
//     widget.reloadDashBoard();
//     reload();
//   }
//
//   void reload(){
//     setState(() {});
//   }
//
//
//   void _showBottomMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent, // để bo góc đẹp
//       builder: (context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white, // màu nền dark
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Thanh kéo ở giữa
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//
//               ListTile(
//                 leading: const Icon(Icons.add_circle_outline_rounded, color: Colors.black),
//                 title: Text(AppLocalizations.of(context)!.folderManager_bottomSheet_addTopic,
//                     style: TextStyle(color: Colors.black, fontSize: 18)),
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               // Nút chọn: Học phần
//               ListTile(
//                 leading: const Icon(Icons.restore_from_trash_rounded, color: Colors.red),
//                 title: Text(AppLocalizations.of(context)!.folderManager_bottomSheet_removeFolder,
//                     style: TextStyle(color: Colors.red, fontSize: 18)),
//                 onTap: () async {
//                   final db = LocalDbService.instance;
//                   await db.folderDao.deleteFolder(widget.idFolder);
//                   reload();
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                   dashboardScreen.globalKey.currentState?.reloadScreen();
//                 },
//               ),
//
//               SizedBox(height: 10,),
//
//               // Nút chọn: Thư mục
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _showScreenAddTopic() {
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => addTopicFolder(idFolder: widget.idFolder, reloadScreen: (){
//           setState(() {
//
//           });
//         },),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(0.0, 1.0);
//           const end = Offset.zero;
//           const curve = Curves.ease;
//           final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//           return SlideTransition(
//             position: animation.drive(tween),
//             child: child,
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         actions: [
//           IconButton(onPressed: (){
//             _showScreenAddTopic();
//           }, icon: Icon(Icons.create_new_folder_outlined, color: Colors.black, size: 30,)),
//           IconButton(onPressed: (){
//             _showBottomMenu(context);
//           }, icon: Icon(Icons.more_vert))
//         ],
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(20),
//           ),
//         ),
//       ),
//       body: Container(
//         width: MediaQuery.sizeOf(context).width,
//         child: Column(
//           children: [
//             Container(
//               color: Colors.white,
//               width: MediaQuery.sizeOf(context).width,
//               height: 170,
//               child: Column(
//                 children: [
//                   SizedBox(height: 20,),
//                   Icon(Icons.folder_open, size: 70, color: Colors.grey,),
//
//                   SizedBox(height: 10,),
//                   Text(widget.nameFolder, style: const TextStyle(fontSize: 30, color: Colors.grey, fontWeight: FontWeight.bold),),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 width: MediaQuery.sizeOf(context).width,
//                 height: MediaQuery.sizeOf(context).height,
//                 child: FutureBuilder(future: hanldeDataTopic(), builder: (ctx, snapshot){
//
//
//                   if(snapshot.hasData){
//                     return Container(
//                       color: Colors.white,
//                       width: MediaQuery.sizeOf(context).width,
//                       height: double.infinity,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(height: 10,),
//                             if(snapshot.data!.isNotEmpty)
//                               for(topic dataTopic in snapshot.data!)
//                                 Padding(
//                                   padding: EdgeInsets.only(bottom: 20),
//                                   child: topicManagerWidget(dataTopic: dataTopic, removeTopic: () {
//                                     removeTopic(dataTopic.id);
//                                   }, reloadDashboard: () {
//                                     widget.reloadDashBoard();
//                                   },),
//                                 )
//                             else

//                           ],
//                         ),
//                       ),
//                     );
//                   }
//
//                   if(snapshot.hasError){
//                     return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
//                   }
//
//                   return const Center();
//                 }),
//               ),
//             )
//           ],
//         ),
//       )
//     );
//   }
//
// }