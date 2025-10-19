import '../entities/shop_item.dart';
import '../repositories/shop_repository.dart';

class BuyItemUseCase {
  final ShopRepository repository;

  BuyItemUseCase(this.repository);

  Future<bool> execute({
    required String id,
    required int price,
    required ShopItemType type,
    required int userCoin,
  }) async {
    if (userCoin < price) {
      throw Exception("Không đủ KuJiCoin để mua.");
    }

    return await repository.buyItem(id, price, type);
  }
}
