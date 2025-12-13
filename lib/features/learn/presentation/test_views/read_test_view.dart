import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';

class ReadTestView extends StatelessWidget implements BaseTestView{

  final VoidCallback? onComplete;
  final BuildContext contextPage;

  const ReadTestView({super.key, required this.contextPage, this.onComplete});

  @override
  VoidCallback? get onTestComplete => onComplete;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}