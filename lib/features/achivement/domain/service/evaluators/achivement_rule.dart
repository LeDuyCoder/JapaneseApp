import 'package:flutter/cupertino.dart';

abstract class AchievementRule<T> {
  Future<T> evaluate();
}
