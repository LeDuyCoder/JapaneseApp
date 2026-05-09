import 'package:flutter/material.dart';
import 'package:japaneseapp/features/learn/domain/entities/card_entity.dart';

class CardWidget extends StatefulWidget{
  final CardEntity cardEntity;
  final bool isChosen;
  final bool isWrong;
  final double width;
  final double height;

  const CardWidget({super.key, required this.cardEntity, required this.isChosen, required this.width, required this.height, this.isWrong = false});

  @override
  State<StatefulWidget> createState() => _CardWidgetState();

}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shake;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // ⏱ nhanh & nhẹ
    );

    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -3, end: 3), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 3, end: -3), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -3, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // chỉ rung khi false -> true
    if (widget.isWrong && !oldWidget.isWrong) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shake.value, 0),
          child: child,
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.isWrong
              ? Colors.red.withOpacity(0.06)
              : widget.isChosen
              ? Colors.green.withOpacity(0.06)
              : Colors.white,
          border: Border.all(
            color: widget.isWrong
                ? Colors.red
                : widget.isChosen
                ? Colors.green
                : Colors.grey,
          ),
        ),
        child: Center(
          child: Text(
            widget.cardEntity.text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}