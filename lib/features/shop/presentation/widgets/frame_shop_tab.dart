import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../DTO/UserDTO.dart';
import '../../../../Service/Server/ServiceLocator.dart';
import '../../../../Theme/colors.dart';
import '../../domain/entities/shop_item.dart';
import '../widgets/frame_item_shop.dart';
import 'fast_click_warning_dialog.dart';

class FrameShopTab extends StatefulWidget {
  final UserDTO userDTO;
  final Future<List<ShopItem>> Function() loadItems;
  final Function(ShopItem item) onBuy;

  const FrameShopTab({
    super.key,
    required this.userDTO,
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
            if (item.imageUrl == widget.userDTO.urlFrame ||
                item.imageUrl == widget.userDTO.urlAvatar) {
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
                          widget.userDTO.urlFrame = '';
                          await ServiceLocator.userService.updateFrameUser(
                            FirebaseAuth.instance.currentUser!.uid,
                            '',
                          );
                        } else {
                          widget.userDTO.urlFrame = item.imageUrl;
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
