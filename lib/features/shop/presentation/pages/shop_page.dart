import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/DTO/FrameDTO.dart';
import 'package:japaneseapp/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/Theme/colors.dart';
import 'package:japaneseapp/Utilities/NumberFormatter.dart';
import 'package:japaneseapp/DTO/UserDTO.dart';
import 'package:japaneseapp/features/shop/data/datasources/frame_avatar_service.dart';
import 'package:japaneseapp/features/shop/domain/entities/shop_item.dart';
import 'package:japaneseapp/features/shop/domain/usecases/buy_item_usecase.dart';
import 'package:japaneseapp/features/shop/presentation/widgets/avatar_shop_tab.dart';
import 'package:japaneseapp/features/shop/presentation/widgets/buy_fail_dialog.dart';
import 'package:japaneseapp/features/shop/presentation/widgets/buy_success_dialog.dart';
import 'package:japaneseapp/features/shop/presentation/widgets/confirm_buy_dialog.dart';
import 'package:japaneseapp/features/shop/presentation/widgets/frame_item_shop.dart';

import '../widgets/frame_shop_tab.dart';

class ShopPage extends StatefulWidget {
  final UserDTO userDTO;

  const ShopPage({super.key, required this.userDTO});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final repo = ShopRepositoryImpl();
  late final usecase = BuyItemUseCase(repo);
  DateTime? _lastClickTime;
  Future<List<ShopItem>> loadFrameItems() => repo.getAllFrames();
  Future<List<ShopItem>> loadAvatarItems() => repo.getAllAvatars();


  Future<void> onBuy(ShopItem item) async {
    print(item.type);
    final confirm = await ConfirmBuyDialog.show(
      context,
      url: item.imageUrl,
      colorBackground: item.colorRarity,
      itemName: item.name,
      isCircleImage: (item.type == ShopItemType.frame) ? false : true,
    );

    if (confirm != true) return;

    try {
      await usecase.execute(
        id: item.id,
        price: item.price,
        type: item.type,
        userCoin: widget.userDTO.coin,
      );

      widget.userDTO.coin -= item.price;
      setState(() {});

      BuySuccessDialog.show(context);
    } catch (e) {
      BuyFailDialog.show(context, reason: e.toString());
    }
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
          bottom: const TabBar(
            isScrollable: true, // Quan trọng: cho phép scroll và căn trái
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            tabs: [
              Tab(text: 'Khung'),
              Tab(text: 'Avatar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FrameShopTab(userDTO: widget.userDTO, loadItems: loadFrameItems, onBuy: (ShopItem item) {
              onBuy(item);
            },),
            AvatarShopTab(userDTO: widget.userDTO, loadItems: loadAvatarItems, onBuy: (ShopItem item) {
              onBuy(item);
            },),
          ],
        ),
      ),
    );
  }
}
