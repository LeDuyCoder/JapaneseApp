import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/DTO/UserDTO.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';
import '../../domain/entities/shop_item.dart';
import 'frame_item_shop.dart';
import 'fast_click_warning_dialog.dart';

class AvatarShopTab extends StatefulWidget {
  final UserModel userModel;
  final Future<List<ShopItem>> Function() loadItems;
  final Function(ShopItem item) onBuy;

  const AvatarShopTab({
    super.key,
    required this.userModel,
    required this.loadItems,
    required this.onBuy,
  });

  @override
  State<AvatarShopTab> createState() => _AvatarShopTabState();
}

class _AvatarShopTabState extends State<AvatarShopTab> {
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
                          widget.userModel.urlAvatar = '';
                          await ServiceLocator.userService.updateAvatarUser(
                            FirebaseAuth.instance.currentUser!.uid,
                            '',
                          );
                        } else {
                          widget.userModel.urlAvatar = item.imageUrl;
                          await ServiceLocator.userService.updateAvatarUser(
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
                  }, circleImage: true,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
