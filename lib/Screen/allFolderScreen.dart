import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Theme/colors.dart';

class allFolderScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _allFolderScreen();

}

class _allFolderScreen extends State<allFolderScreen>{
  String display = "flex";

  Widget boxFolderGrid() {
    return Container(
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
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 50),
          SizedBox(height: 8),
          Flexible(
            child: Text(
              "Tất cả thư mục",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 4),
          Flexible(
            child: Text(
              "2/10/2025 10:32:12",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecond,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(height: 4),
          Flexible(
            child: Text(
              "2 Chủ Đề",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecond,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget boxFolderFlex() {
    return Container(
      width: MediaQuery.sizeOf(context).width/1.3,
      height: 130,
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
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: 20,),
              Icon(Icons.folder_open, size: 50),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tất cả thư mục",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "2 Chủ Đề",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecond,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "2/10/2025 10:32:12",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecond,
                          fontSize: 12,
                        ),
                      ),


                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thư Mục Của Tôi",
          style: TextStyle(color: AppColors.primary, fontSize: 25, fontFamily: "Itim", fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundPrimary,
        scrolledUnderElevation: 0,
      ),
      body: Container(
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                      "8 Thư Mục",
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
                    boxFolderGrid(),
                    boxFolderGrid(),
                    boxFolderGrid(),
                  ],
                ),
              ),
            ):
            Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width / 1.2,
                  child: ListView(
                    children: [
                      for (int i = 0; i < 3; i++)
                        ...[
                          SizedBox(height: 10,),
                          boxFolderFlex(),
                        ]
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );

  }

}