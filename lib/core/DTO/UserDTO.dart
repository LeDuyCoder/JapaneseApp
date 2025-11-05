class UserDTO {
  final String idUser;
  final String nameUser;
  int coin;
  String urlFrame;
  String urlAvatar;

  UserDTO({
    required this.idUser,
    required this.nameUser,
    required this.coin,
    required this.urlFrame,
    required this.urlAvatar,
  });

  /// Tạo object từ JSON
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      idUser: json['idUser'] ?? '',
      nameUser: json['nameUser'] ?? '',
      coin: json['coin'] is int ? json['coin'] : int.tryParse(json['coin'].toString()) ?? 0,
      urlFrame: json['urlFrame'] ?? '',
      urlAvatar: json['urlAvatar'] ?? '',
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
    };
  }

  @override
  String toString() {
    return "Coin: $coin";
  }
}
