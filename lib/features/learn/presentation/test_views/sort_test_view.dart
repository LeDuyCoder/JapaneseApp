import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';

class SortTestView extends StatelessWidget implements BaseTestView {
  final VoidCallback? onComplete;
  final BuildContext contextPage;

  const SortTestView({super.key, this.onComplete, required this.contextPage});

  @override
  VoidCallback? get onTestComplete => onComplete;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}