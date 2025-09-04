import 'package:flutter/material.dart';

import '../Config/dataHelper.dart';
import '../Theme/colors.dart';
import 'folderManagerScreen.dart';

class allFolderScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _allFolderScreen();

}

class _allFolderScreen extends State<allFolderScreen>{
  String display = "grid";

  Future<Map<String, dynamic>> hanldeGetData() async {
    final db = DatabaseHelper.instance;

    Map<String, dynamic> data = {
      "folder": await db.getAllFolder(),
    };

    return data;
  }

  Widget boxFolderGrid(dynamic folder) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => folderManagerScreen(
              idFolder: folder["id"],
              nameFolder: folder["namefolder"],
              reloadDashBoard: () {
                setState(() {});
              },
            ),
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
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 50),
            SizedBox(height: 8),
            Flexible(
              child: Text(
                folder["namefolder"],
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                folder["datefolder"],
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecond,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 4),
            Flexible(
              child: Text(
                "${folder["amountTopic"]} Chủ Đề",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecond,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget boxFolderFlex(dynamic folder) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => folderManagerScreen(
              idFolder: folder["id"],
              nameFolder: folder["namefolder"],
              reloadDashBoard: () {
                setState(() {});
              },
            ),
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
        width: MediaQuery.sizeOf(context).width/1.3,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: AppColors.grey,
              offset: Offset(0, 2),
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(width: 30),
                const Icon(Icons.folder_open, size: 50),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folder["namefolder"],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text("${folder["amountTopic"]} Chủ Đề", style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 10),
                          Text(folder["datefolder"], style: const TextStyle(fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thư Mục Của Tôi",
          style: TextStyle(color: AppColors.primary, fontSize: 25, fontFamily: "Itim", fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundPrimary,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder(future: hanldeGetData(), builder: (ctx, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Container(
            color: AppColors.backgroundPrimary,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        Container(
                          width: 120,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width / 1.2,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      padding: const EdgeInsets.all(16),
                      children: [
                        for (int i = 0; i < 4; i++)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
        if(snapshot.hasData){
          return Container(
            color: AppColors.backgroundPrimary,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          display = "grid";
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: display == "grid"
                              ? AppColors.primary
                              : AppColors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Lưới",
                            style: TextStyle(
                              color: display == "grid"
                                  ? AppColors.white
                                  : AppColors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          display = "flex";
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: display == "flex"
                              ? AppColors.primary
                              : AppColors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Danh Sách",
                            style: TextStyle(
                              color: display == "flex"
                                  ? AppColors.white
                                  : AppColors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        SizedBox(width: 15),
                        Text(
                          "Tất cả thư mục",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${snapshot.data!["folder"].length} Thư Mục",
                          style: TextStyle(color: AppColors.textSecond),
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                  ],
                ),
                display == 'grid' ?
                Expanded(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width / 1.2,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      padding: const EdgeInsets.all(16),
                      children: [
                        for (dynamic folder in snapshot.data!["folder"])
                          boxFolderGrid(folder),

                      ],
                    ),
                  ),
                ):
                Expanded(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width / 1.2,
                      child: ListView(
                        children: [
                          for (dynamic folder in snapshot.data!["folder"])
                            ...[
                              const SizedBox(height: 10,),
                              boxFolderFlex(folder),
                            ]
                        ],
                      ),
                    )
                )
              ],
            ),
          );
        }

        return Container();
      }),
    );

  }

}