import '../entities/shop_item.dart';

abstract class ShopRepository {
  Future<List<ShopItem>> getAllFrames();
  Future<List<ShopItem>> getAllAvatars();
  Future<bool> buyItem(String id, int price, ShopItemType type);
}
