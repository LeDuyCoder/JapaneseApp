import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';

class SpeakTestView extends StatelessWidget implements BaseTestView{

  final VoidCallback? onComplete;
  final BuildContext contextPage;

  const SpeakTestView({super.key, this.onComplete, required this.contextPage});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  VoidCallback? get onTestComplete => onComplete;

}