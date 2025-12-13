import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';

class ListenTestView extends StatelessWidget implements BaseTestView{

  final VoidCallback? onComplete;
  final BuildContext contextPage;

  const ListenTestView({super.key, this.onComplete, required this.contextPage});

  @override
  VoidCallback? get onTestComplete => onComplete;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}