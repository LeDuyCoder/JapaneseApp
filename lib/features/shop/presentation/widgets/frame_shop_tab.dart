import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/DTO/UserDTO.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';
import '../../domain/entities/shop_item.dart';
import '../widgets/frame_item_shop.dart';
import 'fast_click_warning_dialog.dart';

class FrameShopTab extends StatefulWidget {
  final UserModel userModel;
  final Future<List<ShopItem>> Function() loadItems;
  final Function(ShopItem item) onBuy;

  const FrameShopTab({
    super.key,
    required this.userModel,
    required this.loadItems,
    required this.onBuy,
  });

  @override
  State<FrameShopTab> createState() => _FrameShopTabState();
}

class _FrameShopTabState extends State<FrameShopTab> {
  DateTime? _lastClickTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: AppColors.backgroundPrimary,
      child: FutureBuilder<List<ShopItem>>(
        future: widget.loadItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          for (var item in items) {
            if (item.imageUrl == widget.userModel.urlFrame ||
                item.imageUrl == widget.userModel.urlAvatar) {
              item.isEquipped = true;
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              childAspectRatio: 0.7,
              children: items.map((item) {
                return FrameItemShop(
                  item: item,
                  onTap: () async {
                    final now = DateTime.now();

                    if (_lastClickTime == null ||
                        now.difference(_lastClickTime!).inSeconds >= 1) {
                      if (item.isOwned) {
                        if (item.isEquipped) {
                          widget.userModel.urlFrame = '';
                          await ServiceLocator.userService.updateFrameUser(
                            FirebaseAuth.instance.currentUser!.uid,
                            '',
                          );
                        } else {
                          widget.userModel.urlFrame = item.imageUrl;
                          await ServiceLocator.userService.updateFrameUser(
                            FirebaseAuth.instance.currentUser!.uid,
                            item.id,
                          );
                        }
                      } else {
                        await widget.onBuy(item);
                      }

                      _lastClickTime = now;
                      setState(() {});
                    } else {
                      FastClickWarningDialog.show(context, waitSeconds: 1);
                    }
                  }, circleImage: false,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
