import 'dart:ui';

import 'package:flutter/cupertino.dart';

abstract class BaseTestView{
  final VoidCallback? onTestComplete;
  BaseTestView({required this.onTestComplete});
}