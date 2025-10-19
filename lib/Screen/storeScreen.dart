import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/DTO/FrameDTO.dart';
import 'package:japaneseapp/DTO/UserDTO.dart';
import 'package:japaneseapp/Service/Local/local_db_service.dart';
import 'package:japaneseapp/Service/Server/FrameAvatarService.dart';
import 'package:japaneseapp/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/Theme/colors.dart';

import '../Utilities/NumberFormatter.dart';

class storeScreen extends StatefulWidget{
  final UserDTO userDTO;

  const storeScreen({super.key, required this.userDTO});

  @override
  State<StatefulWidget> createState() => _storeScreen();
}

class _storeScreen extends State<storeScreen>{

  Future<List<FrameDTO>> loadFrameShop() async {
    FrameAvatarService frameAvatarService = new FrameAvatarService();
    return await frameAvatarService.getAllFrame();
  }


  void showBuySuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // không cho tắt khi bấm ra ngoài
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon success
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  "Mua Thành Công",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),

                // Message
                const Text(
                  "Bạn đã sở hữu vật phẩm thành công🎉🎉🎉",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // OK button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBuyFailDialog(BuildContext context, {String? reason}) {
    showDialog(
      context: context,
      barrierDismissible: true, // cho phép bấm ra ngoài để đóng
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon warning
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_rounded,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  "Mua Không Thành Công",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),

                // Message
                Text(
                  reason ?? "Something went wrong. Please try again.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> showConfirmBuyDialog(BuildContext context, String url, Color colorBackground, {String? itemName}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // không cho tắt khi bấm ra ngoài
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.45,
                        colors: [
                          colorBackground.withOpacity(0.01),
                          colorBackground
                        ],
                      ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Image.network(url, width: 100, height: 100,),
                  ),

                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  "Xác Nhận Mua",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green
                  ),
                ),
                const SizedBox(height: 8),

                // Message
                Text(
                  "Bạn có muốn mua ${itemName ?? 'vật phẩm này'}?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          "Hủy",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          "Mua",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> buyProduct(String idProduct, int price, TypeProductEnum typeProduct) async {
    final db = LocalDbService.instance;
    if(widget.userDTO.coin < price){
      showBuyFailDialog(context, reason: "Bạn không đủ KuJiCoin để mua");
    }else{
      widget.userDTO.coin = widget.userDTO.coin - price;
      await ServiceLocator.userService.reduceCoin(FirebaseAuth.instance.currentUser!.uid, price);
      await db.userItemsDao.insertUserItem(typeProduct.name, idProduct);
      setState(() {});
      showBuySuccessDialog(context);
    }
  }

  Widget FrameItemShop({required String imgUrl, required String title, required String price, required Function() action, required Color color, required bool isHaving}){
    return Container(
      width: MediaQuery.sizeOf(context).width/2.2,
      height: MediaQuery.sizeOf(context).width/1.8,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.55,
            colors: [
              Colors.white.withOpacity(0.15),
              color
            ],
          ),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.network(imgUrl, width: 120, height: 120),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).width/4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if(!isHaving)
                          ...[
                            Icon(Icons.lock, color: AppColors.primary, size: 15,),
                            SizedBox(width: 5,),
                          ],
                        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Giá:", style: TextStyle(fontSize: 18),),
                        SizedBox(width: 10,),
                        Text(price, style: TextStyle(fontSize: 18)),
                        SizedBox(width: 5,),
                        Image.asset("assets/kujicoin.png", width: 20, height: 20,),
                      ],
                    ),
                    SizedBox(height: 5,),
                    GestureDetector(
                      onTap: (){
                        action();
                      },
                      child: Center(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.35,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isHaving ? Colors.grey : Colors.green,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              isHaving ? "Đã mua" : "Mua",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget tabFrameShop(){
    return FutureBuilder(future: loadFrameShop(), builder: (context, dataFrameReturn){
      if(dataFrameReturn.connectionState == ConnectionState.waiting){
        return Container();
      }

      if(dataFrameReturn.hasData){
        return Column(
          children: [
            Expanded(
              child: Container(
                color: AppColors.backgroundPrimary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.count(
                    crossAxisCount: 2, // 👉 Số cột (ở đây là 2 item mỗi hàng)
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7, // chỉnh tỉ lệ chiều rộng/cao của item
                    children: [
                      for(FrameDTO frame in dataFrameReturn.data!)
                        ...[
                          FrameItemShop(
                            imgUrl: frame.urlImg,
                            title: frame.name,
                            price: "${frame.price}",
                            action: () async {
                              if(!frame.isHaving){

                                bool? confirm = await showConfirmBuyDialog(context, frame.urlImg, frame.getRarityColor(), itemName: frame.name);

                                if (confirm == true) {
                                  buyProduct(frame.idAvatarFrame, frame.price, TypeProductEnum.frame);
                                }
                              }
                            },
                            color: frame.getRarityColor(),
                            isHaving: frame.isHaving
                          ),
                        ]

                      // 👉 Thêm item khác nếu muốn
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }

      return Container();

    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // số lượng tab
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
          scrolledUnderElevation: 0,
          title: Text("Cửa Hàng", style: TextStyle(fontFamily: "Itim", fontSize: 25),),
          actions: [
            Container(
              width: 120,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(NumberFormatter.formatHumanReadable(widget.userDTO.coin), style: TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                  SizedBox(width: 5),
                  Image.asset("assets/kujicoin.png", width: 20, height: 20,),
                ],
              ),
            )
          ],
          bottom: TabBar(
            isScrollable: true, // Quan trọng: cho phép scroll và căn trái
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Khung'),
              Tab(text: 'Avatar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            tabFrameShop(),
            tabFrameShop(),
          ],
        ),
      ),
    );
  }

}