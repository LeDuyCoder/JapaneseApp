import 'dart:ui';

class ShopItem {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  bool isOwned;
  bool isEquipped;
  final Color colorRarity;
  final ShopItemType type;

  ShopItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.isOwned = false,
    this.isEquipped = false,
    required this.colorRarity,
    required this.type,
  });

  ShopItem copyWith({
    bool? isOwned,
    bool? isEquipped,
  }) {
    return ShopItem(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      colorRarity: colorRarity,
      type: type,
      isOwned: isOwned ?? this.isOwned,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  @override
  String toString() {
    return '$id - $name - $imageUrl - $price - $colorRarity - $type';
  }
}

enum ShopItemType {
  frame,
  avatar,
}
