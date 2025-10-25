import 'package:flutter/material.dart';
import 'package:path/path.dart';

enum TypeProductEnum{
  frame,
  avatar,
  items
}

class FrameDTO {
  final String idAvatarFrame;
  final String name;
  final String urlImg;
  final int price;
  final String rarity;
  bool isHaving = false;

  FrameDTO({
    required this.idAvatarFrame,
    required this.name,
    required this.urlImg,
    required this.price,
    required this.rarity,
  });

  factory FrameDTO.fromJson(Map<String, dynamic> json) {
    return FrameDTO(
      idAvatarFrame: json['IdAvatarFrame'] ?? json['IdAvatar'] ?? '',
      name: json['name'] ?? '',
      urlImg: json['urlImg'] ?? '',
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      rarity: json['rarity'] ?? 'Common',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idAvatarFrame': idAvatarFrame,
      'name': name,
      'urlImg': urlImg,
      'price': price,
      'rarity': rarity,
    };
  }

  // Hàm quy đổi rarity thành Color
  Color getRarityColor() {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey.withOpacity(0.5);
      case 'uncommon':
        return Colors.green;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple.withOpacity(0.9);
      case 'legendary':
        return Colors.orange;
      case 'mythic':
        return Colors.red;
      default:
        return Colors.grey.withOpacity(0.5);
    }
  }

  // Hoặc có thể dùng hàm static để sử dụng độc lập
  static Color rarityToColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey.withOpacity(0.5);
      case 'uncommon':
        return Colors.green;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple.withOpacity(0.5);
      case 'legendary':
        return Colors.orange;
      case 'mythic':
        return Colors.red;
      default:
        return Colors.grey.withOpacity(0.5);
    }
  }
}