import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required String id, required String email, String? name, String? token})
      : super(id: id, email: email, name: name, token: token);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
    };
  }
}
