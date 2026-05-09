import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/features/topicdetail/data/models/word_model.dart';

import 'dart:math';

import 'package:flutter/material.dart';

class BoxCardWordWidget extends StatefulWidget {
  final WordModel wordModel;

  const BoxCardWordWidget({
    super.key,
    required this.wordModel,
  });

  @override
  State<BoxCardWordWidget> createState() => _BoxCardWordWidgetState();
}

class _BoxCardWordWidgetState extends State<BoxCardWordWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isFront = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    isFront = !isFront;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(angle),
            child: angle <= pi / 2
                ? _buildFrontCard()
                : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateX(pi),
              child: _buildBackCard(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: 430,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.wordModel.word,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            widget.wordModel.word,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: 330,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.wordModel.mean,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}