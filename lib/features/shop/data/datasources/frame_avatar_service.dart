import 'package:japaneseapp/core/Service/Server/FrameAvatarService.dart';

import '../../domain/entities/shop_item.dart';
import '../../domain/repositories/shop_repository.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/DTO/FrameDTO.dart';

class ShopRepositoryImpl implements ShopRepository {
  final frameAvatarService = ServiceLocator.frameAvatarService;
  final db = LocalDbService.instance;

  @override
  Future<List<ShopItem>> getAllFrames() async {
    final frames = await frameAvatarService.getAllFrame();
    return frames.map((f) => ShopItem(
      id: f.idAvatarFrame,
      name: f.name,
      imageUrl: f.urlImg,
      price: f.price,
      isOwned: f.isHaving,
      isEquipped: false, // gán tạm, cập nhật ngoài UI
      type: ShopItemType.frame,
      colorRarity: f.getRarityColor(),
    )).toList();
  }

  @override
  Future<List<ShopItem>> getAllAvatars() async {
    final avatars = await frameAvatarService.getAllAvatar();
    return avatars.map((a) => ShopItem(
      id: a.idAvatarFrame,
      name: a.name,
      imageUrl: a.urlImg,
      price: a.price,
      isOwned: a.isHaving,
      isEquipped: false, // gán tạm, cập nhật ngoài UI
      type: ShopItemType.avatar,
      colorRarity: a.getRarityColor(),
    )).toList();
  }


  @override
  Future<bool> buyItem(String id, int price, ShopItemType type) async {
    await ServiceLocator.userService
        .reduceCoin(FirebaseAuth.instance.currentUser!.uid, price);
    await db.userItemsDao.insertUserItem(type.name, id);
    return true;
  }


}
