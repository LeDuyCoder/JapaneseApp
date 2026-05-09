import 'package:japaneseapp/core/enums/user_role.dart';

class UserModel {
  final String idUser;
  final String nameUser;
  int coin;
  String urlFrame;
  String urlAvatar;
  UserRole role;

  UserModel({
    required this.idUser,
    required this.nameUser,
    required this.coin,
    required this.urlFrame,
    required this.urlAvatar,
    required this.role
  });

  /// Tạo object từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['idUser'] ?? '',
      nameUser: json['nameUser'] ?? '',
      coin: json['coin'] is int ? json['coin'] : int.tryParse(json['coin'].toString()) ?? 0,
      urlFrame: json['urlFrame'] ?? '',
      urlAvatar: json['urlAvatar'] ?? '',
      role: UserRole.fromString(json['role'] ?? '')
    );
  }

  /// Chuyển object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'nameUser': nameUser,
      'coin': coin,
      'urlFrame': urlFrame,
      'urlAvatar': urlAvatar,
      'role': role
    };
  }

  @override
  String toString() {
    return 'User('
        'idUser: $idUser, '
        'nameUser: $nameUser, '
        'coin: $coin, '
        'urlFrame: $urlFrame, '
        'urlAvatar: $urlAvatar, '
        'role: $role'
        ')';
  }
}
