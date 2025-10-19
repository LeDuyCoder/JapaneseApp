import 'package:flutter/material.dart';
import 'package:japaneseapp/Utilities/NumberFormatter.dart';

import '../../../../Theme/colors.dart';
import '../../domain/entities/shop_item.dart';

class FrameItemShop extends StatelessWidget {
  final ShopItem item;
  final VoidCallback onTap;
  final bool circleImage;

  const FrameItemShop({
    super.key,
    required this.item,
    required this.onTap, required this.circleImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width/2.2,
      height: MediaQuery.sizeOf(context).width/2.8,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.55,
            colors: [
              Colors.white.withOpacity(0.15),
              item.colorRarity
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Stack(
        children: [
          circleImage ? Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: ClipOval(
                child: Image.network(
                  item.imageUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover, // đảm bảo ảnh không méo
                ),
              ),
            )
          ) : Align(
            alignment: Alignment.topCenter,
            child: Image.network(item.imageUrl, width: 120, height: 120),
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
                        if(!item.isOwned)
                          ...[
                            Icon(Icons.lock, color: AppColors.primary, size: 15,),
                            SizedBox(width: 5,),
                          ],
                        Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Giá:", style: TextStyle(fontSize: 18),),
                        SizedBox(width: 10,),
                        Text('${item.price}', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 5,),
                        Image.asset("assets/kujicoin.png", width: 20, height: 20,),
                      ],
                    ),
                    SizedBox(height: 5,),
                    GestureDetector(
                      onTap: onTap,
                      child: Center(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: !item.isOwned
                                ? Colors.green
                                : !item.isEquipped
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              !item.isOwned
                                  ? "Mua"
                                  : !item.isEquipped
                                  ? "Trang Bị"
                                  : "Tháo",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
}
