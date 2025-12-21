import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/congratulation/domain/entities/user_progress.dart';

class UserProgressModel extends UserProgress {
  UserProgressModel({required super.level, required super.exp, required super.nextExp});

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      level: json['level'],
      exp: json['exp'],
      nextExp: json['nextExp'],
    );
  }

  Map<String, dynamic> toJson() => {
    'level': level,
    'exp': exp,
    'nextExp': nextExp,
  };
}
